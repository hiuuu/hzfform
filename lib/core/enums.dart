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

enum HZFFormCalendarType { gregorian, hijri, persian, buddhist, japanese }

/// Date format display types
enum HZFFormDateFormatType {
  mmddyyyy, // 12/31/2023
  ddmmyyyy, // 31/12/2023
  yyyymmdd, // 2023-12-31
  custom, // For custom formatting
  fullText, //  شنبه 04 تیر 1401
  mediumText, // شنبه 04 تیر
  shortText, // 04 تیر ,1401
}

enum HZFFormImageSource { camera, gallery, both }

enum HZFFormFieldTypeEnum {
  cell,
  email,
  password,
  text,
  textPlain,
  spinner,
  datePicker,
  dateRangePicker,
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
