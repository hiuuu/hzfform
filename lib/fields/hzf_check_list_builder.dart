import 'package:flutter/material.dart';

import '../models/check_list_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class CheckListFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final checkModel = model as HZFFormCheckListModel;
    final selectedValues = (model.value as List<String>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search filter
        if (checkModel.enableSearch) _buildSearchField(context, checkModel),

        // Items list
        AnimatedBuilder(
          animation: checkModel.searchController,
          builder: (context, _) {
            final filteredItems = _getFilteredItems(checkModel);

            return Column(
              children: [
                // List items
                ...filteredItems.map((item) => _buildCheckItem(
                    item, checkModel, selectedValues, controller, context)),

                // No results message
                if (filteredItems.isEmpty &&
                    checkModel.searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        checkModel.noResultsText ?? 'No matching items',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        // Selection counter
        if (checkModel.showCounter)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${selectedValues.length}/${checkModel.items.length} selected',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),

        // Actions row
        if (checkModel.enableBulkActions && !checkModel.enableReadOnly!)
          _buildActionButtons(checkModel, controller, selectedValues),
      ],
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    HZFFormCheckListModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: model.searchController,
        decoration: InputDecoration(
          hintText: model.searchHint ?? 'Search...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: model.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => model.searchController.clear(),
                )
              : null,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
      ),
    );
  }

  List<HZFFormCheckListItem> _getFilteredItems(HZFFormCheckListModel model) {
    final query = model.searchController.text.toLowerCase();
    if (query.isEmpty) return model.items;

    return model.items
        .where((item) => item.label.toLowerCase().contains(query))
        .toList();
  }

  Widget _buildCheckItem(
    HZFFormCheckListItem item,
    HZFFormCheckListModel model,
    List<String> selectedValues,
    HZFFormController controller,
    BuildContext context,
  ) {
    final isSelected = selectedValues.contains(item.id);
    final isDisabled = model.enableReadOnly! || item.disabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled
            ? null
            : () => _toggleSelection(
                item.id, isSelected, selectedValues, model, controller),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              // Checkbox
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,
                  onChanged: isDisabled
                      ? null
                      : (value) => _toggleSelection(item.id, isSelected,
                          selectedValues, model, controller),
                  activeColor:
                      model.checkColor ?? Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),

              // Icon (if any)
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 18,
                  color: isDisabled ? Colors.grey : null,
                ),
                const SizedBox(width: 8),
              ],

              // Label
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : null,
                    decoration:
                        item.disabled ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),

              // Subtitle
              if (item.subtitle != null)
                Text(
                  item.subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSelection(
    String id,
    bool isCurrentlySelected,
    List<String> selectedValues,
    HZFFormCheckListModel model,
    HZFFormController controller,
  ) {
    List<String> newSelection;

    if (isCurrentlySelected) {
      // Remove item
      newSelection = selectedValues.where((val) => val != id).toList();
    } else {
      // Add item (check max selection)
      if (model.maxSelection != null &&
          selectedValues.length >= model.maxSelection!) {
        return; // Max selection reached
      }
      newSelection = [...selectedValues, id];
    }

    controller.updateFieldValue(model.tag, newSelection);
  }

  Widget _buildActionButtons(
    HZFFormCheckListModel model,
    HZFFormController controller,
    List<String> selectedValues,
  ) {
    final allSelected = selectedValues.length == model.items.length;
    final anySelected = selectedValues.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Select all
          TextButton(
            onPressed: allSelected
                ? null
                : () {
                    final allIds = model.items
                        .where((item) => !item.disabled)
                        .map((item) => item.id)
                        .toList();
                    controller.updateFieldValue(model.tag, allIds);
                  },
            child: Text(model.selectAllText ?? 'Select All'),
          ),

          // Clear selection
          TextButton(
            onPressed: anySelected
                ? () {
                    controller.updateFieldValue(model.tag, <String>[]);
                  }
                : null,
            child: Text(model.clearSelectionText ?? 'Clear'),
          ),
        ],
      ),
    );
  }
}
