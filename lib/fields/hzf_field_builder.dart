import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../widgets/controller.dart';

/// Base builder interface for all field types
abstract class FieldBuilder {
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  );
}
