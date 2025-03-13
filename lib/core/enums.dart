enum RequiredCheckListEnum { none, atLeastOneItem, allItem }

enum HZFFormFieldStatusEnum { normal, success, error, disabled }

enum HZFFormTimePickerType {
  /// Standard material dial interface
  dial,

  /// iOS-style spinner wheel
  spinner,

  /// Input fields for hour/minute
  input,

  /// Compact dropdown style
  dropdown,

  /// 24-hour format
  military,

  /// 12-hour AM/PM format
  amPm
}

enum HZFFormFieldTypeEnum {
  cell,
  email,
  password,
  text,
  textPlain,
  spinner,
  date,
  dateRage,
  timePicker,
  price,
  number,
  checkList,
  radioGroup,
  pinCode,
  masked,
  bankCard,
  imagePicker,
  multiImagePicker,
  radioChips,
  checkChips,
}
