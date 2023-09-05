// settigs model to keep track of the settings
// for the app
// ==================================================
// SettingsModel class
// uses freezed to make the class immutable
// and equatable to compare objects
// stores following settings:
// - themeMode
// - themeColor
// - themeBrightness
// - showSlovak - bool

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  const factory SettingsModel({
    @Default(ThemeMode.system) ThemeMode themeMode,
    // @Default(Colors.blue) Color themeColor,
    @Default(Brightness.light) Brightness themeBrightness,
    @Default(false) bool showSlovak,
    @Default(false) bool showSearch,
    @Default(false) bool showFound,
    @Default(false) bool showAssignedOne,
    @Default(false) bool showAssignedAll,
    @Default(false) bool showSavedFromApi,
    @Default(false) bool showObject,
    @Default(false) bool exportHtmlWithOriginalVerse,
  }) = _SettingsModel;
  // ({
  //   required this.themeMode,
  //   required this.themeColor,
  //   required this.themeBrightness,
  //   required this.showSlovak,
  // });

  // default settings
  // static const defaultSettings = SettingsModel(
  //   themeMode: ThemeMode.system,
  //   themeColor: Colors.blue,
  //   themeBrightness: Brightness.light,
  //   showSlovak: false,
  // );

  // factory method to create a new SettingsModel
  // from the old one
  // SettingsModel copyWith({
  //   ThemeMode? themeMode,
  //   Color? themeColor,
  //   Brightness? themeBrightness,
  //   bool? showSlovak,
  // }) {
  //   return SettingsModel(
  //     themeMode: themeMode ?? this.themeMode,
  //     themeColor: themeColor ?? this.themeColor,
  //     themeBrightness: themeBrightness ?? this.themeBrightness,
  //     showSlovak: showSlovak ?? this.showSlovak,
  //   );
  // }

  // factory method to create a new SettingsModel
  // from a json map
  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  // method to convert the SettingsModel to a json map
  // Map<String, dynamic> toJson() {
  //   return {
  //     'themeMode': themeMode.index,
  //     'themeColor': themeColor.value,
  //     'themeBrightness': themeBrightness.index,
  //     'showSlovak': showSlovak,
  //   };
  // }

  // method to compare two SettingsModels
  // returns true if they are equal
  // false otherwise
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is SettingsModel &&
  //       other.themeMode == themeMode &&
  //       other.themeColor == themeColor &&
  //       other.themeBrightness == themeBrightness &&
  //       other.showSlovak == showSlovak;
  // }

  // method to get the hashcode of the SettingsModel
  // returns the hashcode
  // @override
  // int get hashCode {
  //   return themeMode.hashCode ^
  //       themeColor.hashCode ^
  //       themeBrightness.hashCode ^
  //       showSlovak.hashCode;
  // }
}
