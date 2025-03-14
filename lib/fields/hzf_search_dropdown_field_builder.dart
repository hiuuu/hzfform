import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/search_dropdown_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class SearchableDropdownBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final dropdownModel = model as HZFFormSearchableDropdownModel;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown field with search
        DropdownSearch<HZFDropdownItem>(
          popupProps: _buildPopupProps(dropdownModel, theme),
          dropdownDecoratorProps: _buildDecoratorProps(dropdownModel),
          items: dropdownModel.items,
          selectedItem: _findSelectedItem(dropdownModel),
          itemAsString: (item) => item.label,
          onChanged: dropdownModel.enableReadOnly == true
              ? null
              : (value) {
                  if (value != null) {
                    controller.updateFieldValue(dropdownModel.tag, value.id);
                    dropdownModel.onItemSelected?.call(value);
                  }
                },
          asyncItems: dropdownModel.asyncItemsCallback != null
              ? (String filter) => _handleAsyncSearch(filter, dropdownModel)
              : null,
          compareFn: (item1, item2) => item1.id == item2.id,
          clearButtonProps: ClearButtonProps(
            isVisible:
                dropdownModel.showClearButton && dropdownModel.value != null,
            icon: Icon(dropdownModel.clearIcon ?? Icons.clear),
          ),
          filterFn: dropdownModel.customFilterFn,
          enabled: dropdownModel.enableReadOnly != true,
        ),
      ],
    );
  }

  PopupProps<HZFDropdownItem> _buildPopupProps(
    HZFFormSearchableDropdownModel model,
    ThemeData theme,
  ) {
    return PopupProps.menu(
      showSearchBox: model.showSearchBox,
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          hintText: model.searchHint ?? 'Search...',
          prefixIcon: Icon(model.searchIcon ?? Icons.search),
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        autofocus: model.autoFocusSearchField,
      ),
      menuProps: MenuProps(
        backgroundColor: model.menuBackgroundColor,
        borderRadius: BorderRadius.circular(model.menuBorderRadius ?? 8),
      ),
      title: model.popupTitle != null
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                model.popupTitle!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            )
          : null,
      itemBuilder: model.customItemBuilder,
      loadingBuilder: (context, searchEntry) =>
          const Center(child: CircularProgressIndicator()),
      emptyBuilder: (context, searchEntry) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            model.noResultsText ?? 'No results found',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ),
      ),
      fit: FlexFit.loose,
      constraints: BoxConstraints(
        maxHeight: model.maxPopupHeight ?? 300,
      ),
    );
  }

  DropDownDecoratorProps _buildDecoratorProps(
    HZFFormSearchableDropdownModel model,
  ) {
    return DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        hintText: model.hint,
        labelText: model.labelText,
        prefixIcon: model.prefixWidget,
        suffixIcon: model.postfixWidget,
        border: model.border ?? const OutlineInputBorder(),
        enabledBorder: model.enabledBorder,
        focusedBorder: model.focusedBorder,
        errorBorder: model.errorBorder,
        filled: model.filled,
        fillColor: model.fillColor,
        contentPadding: model.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  HZFDropdownItem? _findSelectedItem(HZFFormSearchableDropdownModel model) {
    if (model.value == null) return null;

    // Find item by selected ID
    return model.items.firstWhere(
      (item) => item.id == model.value,
      orElse: () => HZFDropdownItem(
          id: model.value.toString(), label: model.value.toString()),
    );
  }

  Future<List<HZFDropdownItem>> _handleAsyncSearch(
    String filter,
    HZFFormSearchableDropdownModel model,
  ) async {
    if (model.asyncItemsCallback == null) return model.items;

    try {
      // Use debounce to avoid excessive API calls
      await Future.delayed(
          Duration(milliseconds: model.searchDebounceTime ?? 300));

      // Call the async callback
      final results = await model.asyncItemsCallback!(filter);
      return results;
    } catch (e) {
      debugPrint('Error fetching dropdown items: $e');
      return [];
    }
  }
}
