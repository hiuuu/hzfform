import 'package:flutter/material.dart';

import '../models/check_chips_list_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class CheckChipsListBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final chipsModel = model as HZFFormCheckChipsListModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter option
        if (chipsModel.showSearchFilter == true)
          _buildSearchFilter(chipsModel, controller, context),

        // Chips layout
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _buildChips(chipsModel, controller, context),
        ),

        // Selected count
        if (chipsModel.showSelectedCount == true)
          _buildSelectedCount(chipsModel),
      ],
    );
  }

  Widget _buildSearchFilter(
    HZFFormCheckChipsListModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    // Use ValueNotifier to avoid rebuilding the whole form
    final searchController = TextEditingController();
    final filterNotifier = ValueNotifier<String>('');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: model.searchHint ?? 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
        ),
        onChanged: (value) => filterNotifier.value = value.toLowerCase(),
      ),
    );
  }

  List<Widget> _buildChips(
    HZFFormCheckChipsListModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    // Current selection
    final selectedIds = (model.value as List<String>?) ?? [];

    return model.items.map((item) {
      final isSelected = selectedIds.contains(item.id);
      final isDisabled = model.enableReadOnly == true;

      return FilterChip(
        label: Text(item.label),
        selected: isSelected,
        onSelected: isDisabled
            ? null
            : (selected) {
                List<String> newSelection;

                if (selected) {
                  // Add to selection if under max limit
                  if (model.maxSelection == null ||
                      selectedIds.length < model.maxSelection!) {
                    newSelection = [...selectedIds, item.id];
                  } else {
                    // Max selection reached - show message if provided
                    if (model.maxSelectionMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(model.maxSelectionMessage!)),
                      );
                    }
                    return;
                  }
                } else {
                  // Remove from selection
                  newSelection =
                      selectedIds.where((id) => id != item.id).toList();
                }

                controller.updateFieldValue(model.tag, newSelection);
              },
        labelStyle: TextStyle(
          color: isSelected
              ? model.selectedTextColor ?? Colors.white
              : model.textColor ?? Colors.black,
        ),
        backgroundColor: model.backgroundColor ?? Colors.grey[200],
        selectedColor: model.selectedColor ?? Theme.of(context).primaryColor,
        checkmarkColor: model.checkmarkColor ?? Colors.white,
        avatar: item.icon != null
            ? Icon(
                item.icon,
                size: 18,
                color: isSelected
                    ? model.selectedTextColor ?? Colors.white
                    : model.textColor ?? Colors.black,
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        showCheckmark: model.showCheckmark ?? true,
      );
    }).toList();
  }

  Widget _buildSelectedCount(HZFFormCheckChipsListModel model) {
    final selectedIds = (model.value as List<String>?) ?? [];
    final hasMax = model.maxSelection != null;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        hasMax
            ? '${selectedIds.length}/${model.maxSelection} selected'
            : '${selectedIds.length} selected',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
