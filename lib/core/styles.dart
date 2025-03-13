import 'package:flutter/material.dart';

class HZFFormStyle {
  TextStyle titleTextStyle;
  TextStyle fieldHintStyle;
  TextStyle fieldTextStyle;
  TextStyle errorTextStyle;
  TextStyle helpTextStyle;
  TextStyle sectionTitleStyle;
  Color backgroundFieldColor;
  Color backgroundFieldColorDisable;
  Color backgroundSectionColor;
  Color fieldBorderColor;

  double fieldRadius;
  double sectionRadius;
  double sectionCardElevation;
  double sectionCardPadding;
  String requiredText;

  HZFFormStyle({
    TextStyle? titleStyle,
    Color? backgroundFieldColor,
    Color? backgroundSectionColor,
    Color? fieldBorderColor,
    Color? backgroundFieldColorDisable,
    double? fieldRadius,
    double? sectionRadius,
    double? sectionCardElevation,
    double? sectionCardPadding,
    TextStyle? fieldHintStyle,
    TextStyle? fieldTextStyle,
    TextStyle? errorTextStyle,
    TextStyle? helpTextStyle,
    String? requiredText,
    TextStyle? sectionTitleStyle,
  })  : backgroundSectionColor = backgroundSectionColor ?? HZFFormColors.white,
        backgroundFieldColor =
            backgroundFieldColor ?? HZFFormColors.colorBackground,
        backgroundFieldColorDisable =
            backgroundFieldColorDisable ?? HZFFormColors.colorBackgroundDisable,
        titleTextStyle =
            titleStyle ?? HZFFormTheme.textThemeStyle.displayMedium!,
        fieldRadius = fieldRadius ?? 10.0,
        sectionRadius = sectionRadius ?? 4.0,
        sectionCardElevation = sectionCardElevation ?? 2.0,
        sectionCardPadding = sectionCardPadding ?? 2.0,
        requiredText = requiredText ?? '',
        fieldHintStyle =
            fieldHintStyle ?? HZFFormTheme.textThemeStyle.bodyMedium!,
        fieldTextStyle =
            fieldTextStyle ?? HZFFormTheme.textThemeStyle.displayMedium!,
        errorTextStyle =
            errorTextStyle ?? HZFFormTheme.textThemeStyle.headlineSmall!,
        helpTextStyle =
            helpTextStyle ?? HZFFormTheme.textThemeStyle.headlineMedium!,
        sectionTitleStyle =
            sectionTitleStyle ?? HZFFormTheme.textThemeStyle.displayLarge!,
        fieldBorderColor = fieldBorderColor ?? HZFFormColors.white;

  static HZFFormStyle singleSectionFormDefaultStyle = HZFFormStyle(
    backgroundFieldColor: HZFFormColors.white,
    sectionCardElevation: 0.0,
    backgroundSectionColor: Colors.transparent,
    sectionCardPadding: 0.0,
    titleStyle: HZFFormTheme.textThemeStyle.displayMedium,
    fieldTextStyle: HZFFormTheme.textThemeStyle.displayMedium,
    fieldHintStyle: HZFFormTheme.textThemeStyle.bodyMedium!,
    errorTextStyle: HZFFormTheme.textThemeStyle.headlineSmall,
    helpTextStyle: HZFFormTheme.textThemeStyle.headlineMedium,
    sectionTitleStyle: HZFFormTheme.textThemeStyle.displayLarge,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static HZFFormStyle singleSectionFormDefaultDarkStyle = HZFFormStyle(
    backgroundFieldColor: HZFFormColors.black,
    sectionCardElevation: 0.0,
    backgroundSectionColor: Colors.transparent,
    sectionCardPadding: 0.0,
    sectionTitleStyle: HZFFormTheme.textThemeDarkStyle.displayLarge,
    titleStyle: HZFFormTheme.textThemeDarkStyle.displayMedium,
    fieldTextStyle: HZFFormTheme.textThemeDarkStyle.displayMedium,
    fieldHintStyle: HZFFormTheme.textThemeDarkStyle.bodyMedium,
    errorTextStyle: HZFFormTheme.textThemeDarkStyle.headlineSmall,
    helpTextStyle: HZFFormTheme.textThemeDarkStyle.headlineMedium,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static HZFFormStyle multiSectionFormDefaultStyle = HZFFormStyle(
    backgroundFieldColor: HZFFormColors.colorBackground,
    sectionCardElevation: 2.0,
    backgroundSectionColor: HZFFormColors.white,
    sectionCardPadding: 8.0,
    titleStyle: HZFFormTheme.textThemeStyle.displayMedium,
    fieldTextStyle: HZFFormTheme.textThemeStyle.displayMedium,
    fieldHintStyle: HZFFormTheme.textThemeStyle.bodyMedium,
    errorTextStyle: HZFFormTheme.textThemeStyle.headlineSmall,
    helpTextStyle: HZFFormTheme.textThemeStyle.headlineMedium,
    sectionTitleStyle: HZFFormTheme.textThemeStyle.displayLarge,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static HZFFormStyle multiSectionFormDefaultDarkStyle = HZFFormStyle(
    backgroundFieldColor: HZFFormColors.colorBackgroundDark,
    backgroundSectionColor: HZFFormColors.black,
    titleStyle: HZFFormTheme.textThemeDarkStyle.displayMedium,
    fieldTextStyle: HZFFormTheme.textThemeDarkStyle.displayMedium,
    fieldHintStyle: HZFFormTheme.textThemeDarkStyle.bodyMedium,
    errorTextStyle: HZFFormTheme.textThemeDarkStyle.headlineSmall,
    helpTextStyle: HZFFormTheme.textThemeDarkStyle.headlineMedium,
    sectionTitleStyle: HZFFormTheme.textThemeDarkStyle.displayLarge,
    sectionRadius: 8,
    sectionCardElevation: 2.0,
    sectionCardPadding: 8.0,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );
}

class HZFFormTheme {
  static final textThemeStyle = TextTheme(
    displayLarge: TextStyle(
      color: HZFFormColors.textColorHeader,
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
    ),
    displayMedium: TextStyle(
      color: HZFFormColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 11.0,
    ),
    displaySmall: TextStyle(
      color: HZFFormColors.hintTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 9.0,
    ),
    headlineMedium: TextStyle(
      color: HZFFormColors.hintTextColor,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    headlineSmall: TextStyle(
      color: HZFFormColors.red,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    bodyMedium: TextStyle(
      color: HZFFormColors.hintTextColor,
      fontWeight: FontWeight.w400,
      fontSize: 11.0,
    ),
  );

  static final textThemeDarkStyle = TextTheme(
    displayLarge: TextStyle(
      color: HZFFormColors.textDarkColorHeader,
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
    ),
    displayMedium: TextStyle(
      color: HZFFormColors.textColorDark,
      fontWeight: FontWeight.w700,
      fontSize: 11.0,
    ),
    displaySmall: TextStyle(
      color: HZFFormColors.hintTextDarkColor,
      fontWeight: FontWeight.w500,
      fontSize: 9.0,
    ),
    headlineMedium: TextStyle(
      color: HZFFormColors.hintTextDarkColor,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    headlineSmall: TextStyle(
      color: HZFFormColors.red,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    bodyMedium: TextStyle(
      color: HZFFormColors.hintTextDarkColor,
      fontWeight: FontWeight.w400,
      fontSize: 11.0,
    ),
  );
}

class HZFFormColors {
  static const white = Color(0xffffffff);
  static const redOpacity = Color(0x1aef5350);
  static const greenOpacity = Color(0x1a6cd38b);

  static const red = Color(0xffef5350);
  static const green = Color(0xff6cd38b);

  static const hintTextColor = Color(0xff999999);
  static const textColor = Color(0xff3a3a3a);
  static const textColorHeader = Color(0xff1c1c1c);
  static const dividerColor = Color(0xffeaeaea);
  static const colorBackground = Color(0xfff5f5f5);
  static const colorBackgroundDisable = Color(0xffbbbbbb);

  static const black = Color(0xff171717);

  static const hintTextDarkColor = Color(0xff505050);
  static const textDarkColorHeader = Color(0xff939292);
  static const textColorDark = Color(0xfff1f0f0);

  static const dividerColorDark = Color(0xff3a3939);

  static const colorBackgroundDark = Color(0xff1a1a1a);
}

class HZFFormGradients {
  static const redGradient = LinearGradient(
    colors: [HZFFormColors.red, HZFFormColors.redOpacity],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const greenGradient = LinearGradient(
    colors: [HZFFormColors.green, HZFFormColors.greenOpacity],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class HZFFormShadows {
  static const redShadow = BoxShadow(
    color: HZFFormColors.red,
    blurRadius: 10,
    offset: Offset(0, 3),
  );
  static const greenShadow = BoxShadow(
    color: HZFFormColors.green,
    blurRadius: 10,
    offset: Offset(0, 3),
  );
}

class HZFFormCorners {
  static const small = BorderRadius.all(Radius.circular(5));
  static const medium = BorderRadius.all(Radius.circular(10));
  static const large = BorderRadius.all(Radius.circular(20));
}

class HZFFormSizes {
  static const small = 5.0;
  static const medium = 10.0;
  static const large = 20.0;
}

class HZFFormPaddings {
  static const small = 5.0;
  static const medium = 10.0;
  static const large = 20.0;
}

class HZFFormIconSizes {
  static const small = 15.0;
  static const medium = 20.0;
  static const large = 25.0;
}

class HZFFormElevations {
  static const small = 5.0;
  static const medium = 10.0;
  static const large = 20.0;
}

class HZFFormBorderRadius {
  static const small = 5.0;
  static const medium = 10.0;
  static const large = 20.0;
}

class HZFFormBorderWidth {
  static const small = 1.0;
  static const medium = 2.0;
  static const large = 3.0;
}

class HZFFormOpacity {
  static const small = 0.1;
  static const medium = 0.2;
  static const large = 0.3;
}

class HZFFormIcons {
  static const arrowLeft = "assets/icons/arrow_left.png";
  static const arrowRight = "assets/icons/arrow_right.png";
}

class HZFFormImages {
  static const logo = "assets/images/logo.png";
}

class HZFFormFonts {
  static const roboto = "Roboto";
}

class HZFFormTextStyles {
  static const title = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold); // HZFFormFonts.roboto
  static const subtitle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold); // HZFFormFonts.roboto
  static const body = TextStyle(fontSize: 16); // HZFFormFonts.roboto
}

class HZFFormDecorations {
  static const roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(color: Colors.grey),
  );
}
