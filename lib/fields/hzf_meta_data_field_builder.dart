import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/meta_data_model.dart';
import '../widgets/controller.dart';
import 'hzf_field_builder.dart';

class MetaDataFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final metaModel = model as HZFFormMetaDataModel;

    // Create state notifier for entries
    return _MetaDataFieldState(
      model: metaModel,
      controller: controller,
      context: context,
    );
  }
}

/// Stateful widget for managing metadata entries
class _MetaDataFieldState extends StatefulWidget {
  final HZFFormMetaDataModel model;
  final HZFFormController controller;
  final BuildContext context;

  const _MetaDataFieldState({
    required this.model,
    required this.controller,
    required this.context,
  });

  @override
  _MetaDataFieldStateState createState() => _MetaDataFieldStateState();
}

class _MetaDataFieldStateState extends State<_MetaDataFieldState> {
  late List<MetaDataEntry> entries;
  bool get canAddMore =>
      widget.model.maxEntries == null ||
      entries.length < widget.model.maxEntries!;

  @override
  void initState() {
    super.initState();
    // Initialize entries from model value or create default
    entries = _initializeEntries();
  }

  List<MetaDataEntry> _initializeEntries() {
    if (widget.model.value != null &&
        widget.model.value is List<MetaDataEntry>) {
      return List<MetaDataEntry>.from(
          widget.model.value as List<MetaDataEntry>);
    } else if (widget.model.value != null &&
        widget.model.value is Map<String, dynamic>) {
      // Convert map to entries
      final map = widget.model.value as Map<String, dynamic>;
      return map.entries
          .map((e) => MetaDataEntry(key: e.key, value: e.value.toString()))
          .toList();
    }

    // Start with minimum entries
    return List.generate(
        widget.model.minEntries, (_) => MetaDataEntry(key: '', value: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with add button
          _buildHeader(),

          const SizedBox(height: 8),

          // Entries list
          ...entries.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildEntryRow(item, index);
          }),

          // Add button at bottom
          if (canAddMore &&
              widget.model.addButtonPosition == AddButtonPosition.bottom)
            _buildAddButton(),

          // Counter
          if (widget.model.showCounter)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${entries.length}/${widget.model.maxEntries ?? '∞'} entries',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Key label
        Expanded(
          flex: widget.model.keyColumnFlex,
          child: Text(
            widget.model.keyLabel ?? 'Key',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Value label
        Expanded(
          flex: widget.model.valueColumnFlex,
          child: Text(
            widget.model.valueLabel ?? 'Value',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Add button placeholder or actual button
        SizedBox(
          width: 40,
          child: widget.model.addButtonPosition == AddButtonPosition.header &&
                  canAddMore
              ? IconButton(
                  icon: Icon(
                    widget.model.addIcon ?? Icons.add_circle_outline,
                    color: widget.model.addIconColor ?? Colors.blue,
                  ),
                  onPressed: _addEntry,
                  tooltip: widget.model.addTooltip ?? 'Add field',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildEntryRow(MetaDataEntry entry, int index) {
    final isRemovable = entries.length > widget.model.minEntries;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key field (dropdown if options provided)
          Expanded(
            flex: widget.model.keyColumnFlex,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: widget.model.keyOptions.isNotEmpty
                  ? _buildKeyDropdown(entry, index)
                  : _buildKeyTextField(entry, index),
            ),
          ),

          // Value field
          Expanded(
            flex: widget.model.valueColumnFlex,
            child: _buildValueTextField(entry, index),
          ),

          // Remove button
          SizedBox(
            width: 40,
            child: widget.model.enableReadOnly != true && isRemovable
                ? IconButton(
                    icon: Icon(
                      widget.model.removeIcon ?? Icons.remove_circle_outline,
                      color: widget.model.removeIconColor ?? Colors.red,
                      size: 20,
                    ),
                    onPressed: () => _removeEntry(index),
                    tooltip: widget.model.removeTooltip ?? 'Remove',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyDropdown(MetaDataEntry entry, int index) {
    return DropdownButtonFormField<String>(
      value: entry.key.isNotEmpty && widget.model.keyOptions.contains(entry.key)
          ? entry.key
          : null,
      decoration: InputDecoration(
        hintText: widget.model.keyHint ?? 'Select key',
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      items: widget.model.keyOptions
          .map((key) => DropdownMenuItem<String>(
                value: key,
                child: Text(key),
              ))
          .toList(),
      onChanged: widget.model.enableReadOnly == true
          ? null
          : (value) {
              if (value != null) {
                setState(() {
                  entries[index] = entries[index].copyWith(key: value);
                });
                _updateController();
              }
            },
    );
  }

  Widget _buildKeyTextField(MetaDataEntry entry, int index) {
    return TextFormField(
      initialValue: entry.key,
      decoration: InputDecoration(
        hintText: widget.model.keyHint ?? 'Enter key',
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      enabled: widget.model.enableReadOnly != true,
      onChanged: (value) {
        setState(() {
          entries[index] = entries[index].copyWith(key: value);
        });
        _updateController();
      },
    );
  }

  Widget _buildValueTextField(MetaDataEntry entry, int index) {
    return TextFormField(
      initialValue: entry.value,
      decoration: InputDecoration(
        hintText: widget.model.valueHint ?? 'Enter value',
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      enabled: widget.model.enableReadOnly != true,
      onChanged: (value) {
        setState(() {
          entries[index] = entries[index].copyWith(value: value);
        });
        _updateController();
      },
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextButton.icon(
        onPressed: _addEntry,
        icon: Icon(
          widget.model.addIcon ?? Icons.add_circle_outline,
          size: 18,
          color: widget.model.addIconColor ?? Colors.blue,
        ),
        label: Text(
          widget.model.addButtonText ?? 'Add Field',
          style: TextStyle(
            color: widget.model.addIconColor ?? Colors.blue,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  void _addEntry() {
    if (!canAddMore) return;

    setState(() {
      entries.add(MetaDataEntry(key: '', value: ''));
    });
    _updateController();
  }

  void _removeEntry(int index) {
    if (entries.length <= widget.model.minEntries) return;

    setState(() {
      entries.removeAt(index);
    });
    _updateController();
  }

  void _updateController() {
    // Update form controller with current entries
    if (widget.model.outputFormat == MetaDataOutputFormat.list) {
      widget.controller.updateFieldValue(widget.model.tag, entries);
    } else {
      // Convert to map
      final map = <String, dynamic>{};
      for (final entry in entries) {
        if (entry.key.isNotEmpty) {
          map[entry.key] = entry.value;
        }
      }
      widget.controller.updateFieldValue(widget.model.tag, map);
    }
  }
}

/// Metadata entry model
class MetaDataEntry {
  final String key;
  final String value;

  const MetaDataEntry({
    required this.key,
    required this.value,
  });

  MetaDataEntry copyWith({
    String? key,
    String? value,
  }) {
    return MetaDataEntry(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() => {
        'key': key,
        'value': value,
      };

  @override
  String toString() => 'MetaDataEntry(key: $key, value: $value)';
}
