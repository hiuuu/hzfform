import 'package:flutter/material.dart';
import 'package:hzfform/core/enums.dart';
import 'package:hzfform/models/field_model.dart';

/// Model for representing a slidable list view field.
class HZFSlidableListViewModel extends HZFFormFieldModel {
  /// List of items to be displayed in the slidable list view.
  final List<HZFSlidableListItemModel> items;

  /// Start actions (left side)
  final List<HZFSlidableListAction>? startActions;

  /// End actions (right side)
  final List<HZFSlidableListAction>? endActions;

  /// Creates a [HZFSlidableListViewModel].
  HZFSlidableListViewModel({
    required super.tag,
    required this.items,
    this.startActions,
    this.endActions,
  }) : super(type: HZFFormFieldTypeEnum.slidableListView);
}

/// Model for representing an item within the slidable list view.
class HZFSlidableListItemModel {
  /// The title of the list item.
  final String title;

  /// An optional subtitle for the list item.
  final String? subtitle;

  /// Creates a [HZFSlidableListItemModel].
  HZFSlidableListItemModel({required this.title, this.subtitle});
}

/// Model for representing an action within the slidable list view.
class HZFSlidableListAction {
  /// Unique identifier for the list item associated with this action.
  final String itemId;

  /// Optional icon for the action.
  final IconData? icon;

  /// Text label for the action.
  final String label;

  /// Optional background color for the action button.
  final Color? color;

  /// Callback to execute when the action is tapped.
  final VoidCallback onTap;

  /// Placement of the action (leading or trailing).
  final HZFSlidableActionPosition position;

  /// If true, the action will be triggered when the slide is completed.
  /// If false (default), the action will be triggered on tapping the action.
  final bool triggerOnSlideComplete;

  /// Creates a [HZFSlidableListAction].
  HZFSlidableListAction({
    required this.itemId,
    required this.label,
    required this.onTap,
    this.triggerOnSlideComplete = false, // Default to false (tap required)
    this.icon,
    this.color,
    this.position = HZFSlidableActionPosition.trailing, // Default to trailing
  });

  // Helper to create a "delete" action
  static HZFSlidableListAction deleteAction(
      {required String itemId, required VoidCallback onDelete, Color? color}) {
    return HZFSlidableListAction(
      itemId: itemId,
      label: 'Delete',
      icon: Icons.delete,
      color: color ?? Colors.red, // Default to red
      onTap: onDelete,
    );
  }

  // Helper to create a "edit" action
  static HZFSlidableListAction editAction(
      {required String itemId, required VoidCallback onEdit, Color? color}) {
    return HZFSlidableListAction(
      itemId: itemId,
      label: 'edit',
      icon: Icons.edit,
      color: color ?? Colors.blue,
      onTap: onEdit,
    );
  }

  // Helper to create a "show" action
  static HZFSlidableListAction showAction(
      {required String itemId, required VoidCallback onShow, Color? color}) {
    return HZFSlidableListAction(
      itemId: itemId,
      label: 'show',
      icon: Icons.visibility,
      color: color ?? Colors.green,
      onTap: onShow,
    );
  }
}
