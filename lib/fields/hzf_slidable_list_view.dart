import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../hzfform.dart';
import '../models/field_model.dart';
import 'hzf_field_builder.dart';

/// A slidable list view widget for HZFform.
class HZFSlidableListViewBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model1,
    HZFFormController controller,
    BuildContext context,
  ) {
    final slidableModel = model1 as HZFSlidableListViewModel;
    return Material(
      type: MaterialType.transparency,
      child: ListView.builder(
        itemCount: slidableModel.items.length,
        itemBuilder: (context, index) {
          final item = slidableModel.items[index];
          return Slidable(
            // Specify the direction for sliding actions
            // (startActionPane for leading actions, endActionPane for trailing)
            startActionPane:
                _buildStartActionPane(slidableModel, context, item, index),
            endActionPane:
                _buildEndActionPane(slidableModel, context, item, index),
            child: ListTile(
              title: Text(item.title),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
            ),
          );
        },
      ),
    );
  }

  ActionPane _buildStartActionPane(HZFSlidableListViewModel model1,
      BuildContext context, HZFSlidableListItemModel item, int index) {
    return ActionPane(
      motion:
          const ScrollMotion(), // You can customize the sliding motion BehindMotion()
      children: model1.startActions
              ?.where((action) => action.itemId == model1.items[index].title)
              .map((action) {
            // Customize the appearance of action buttons
            return SlidableAction(
              onPressed: (_) => action.onTap(),
              backgroundColor: action.color ?? Colors.grey[200]!,
              foregroundColor: Colors.white,
              icon: action.icon,
              label: action.label,
            );
          }).toList() ??
          [],
    );
  }

  ActionPane _buildEndActionPane(HZFSlidableListViewModel model1,
      BuildContext context, HZFSlidableListItemModel item, int index) {
    return ActionPane(
      motion:
          const ScrollMotion(), // You can customize the sliding motion BehindMotion()
      children: model1.endActions
              ?.where((action) => action.itemId == model1.items[index].title)
              .map((action) {
            // Customize the appearance of action buttons
            return SlidableAction(
              onPressed: (_) => action.onTap(),
              backgroundColor: action.color ?? Colors.grey[200]!,
              foregroundColor: Colors.white,
              icon: action.icon,
              label: action.label,
            );
          }).toList() ??
          [],
    );
  }
}
