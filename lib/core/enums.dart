enum RequiredCheckListEnum { none, atLeastOneItem, allItem }

enum HZFFormFieldStatusEnum { normal, success, error, disabled }

enum HZFFormTimePickerType {
  dial, // Standard material dial interface
  spinner, // iOS-style spinner wheel
  input, // Input fields for hour/minute
  dropdown, // Compact dropdown style
  military, // 24-hour format
  amPm // 12-hour AM/PM format
}

enum NumberDisplayFormat {
  integer, // 1,234
  decimal, // 1,234.56
  currency, // $1,234.56
  percentage, // 12.34%
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

enum HZFTimeFormat {
  amPmLowercase, // 3:30 pm
  amPmUppercase, // 3:30 PM
  military, // 15:30
}

enum HZFFormImageSource { camera, gallery, both }

enum HZFCardType {
  visa,
  mastercard,
  amex,
  discover,
  shetab,
  other,
}

/// Position for character counter
enum CounterPosition {
  inline, // Within input decoration
  below, // Below the text field
}

/// Predefined mask types
enum MaskType {
  phone, // (###) ###-####
  date, // ##/##/####
  time, // ##:##
  creditCard, // #### #### #### ####
  zipCode, // #####-####
  currency, // Decimal format
}

enum MetaDataOutputFormat {
  list, // List<MetaDataEntry>
  map, // Map<String, dynamic>
}

/// Add button position
enum AddButtonPosition {
  header, // Next to headers
  bottom, // Below all entries
}

/// Color picker modes
enum ColorPickerMode {
  material, // Material design colors
  rgb, // RGB sliders
  hsl, // HSL picker
  wheel, // Color wheel
}

/// QR code modes
enum QRCodeMode {
  generate, // Only generate QR codes
  scan, // Only scan QR codes
  both, // Generate and scan QR codes
}

enum HZFFormFieldTypeEnum {
  password,
  text,
  textPlain,
  spinner,
  datePicker,
  dateRangePicker,
  timePicker,
  number,
  checkList,
  radioGroup,
  pinCode,
  slider,
  sliderRange,
  bankCard,
  imagePicker,
  multiImagePicker,
  radioChips,
  checkChips,
  searchableDropdown,
  metaData,
  mapPicker,
  colorPicker,
  qrCodePicker,
  documentPicker,
  videoPicker,
  audioPicker,
  signaturePicker,
}
