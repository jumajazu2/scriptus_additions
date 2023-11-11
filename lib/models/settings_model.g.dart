// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SettingsModel _$$_SettingsModelFromJson(Map<String, dynamic> json) =>
    _$_SettingsModel(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      themeBrightness:
          $enumDecodeNullable(_$BrightnessEnumMap, json['themeBrightness']) ??
              Brightness.light,
      showSlovak: json['showSlovak'] as bool? ?? false,
      showSearch: json['showSearch'] as bool? ?? false,
      showFound: json['showFound'] as bool? ?? true,
      showAssignedOne: json['showAssignedOne'] as bool? ?? false,
      showAssignedAll: json['showAssignedAll'] as bool? ?? false,
      showSavedFromApi: json['showSavedFromApi'] as bool? ?? false,
      showObject: json['showObject'] as bool? ?? false,
      exportHtmlWithOriginalVerse:
          json['exportHtmlWithOriginalVerse'] as bool? ?? true,
    );

Map<String, dynamic> _$$_SettingsModelToJson(_$_SettingsModel instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeBrightness': _$BrightnessEnumMap[instance.themeBrightness]!,
      'showSlovak': instance.showSlovak,
      'showSearch': instance.showSearch,
      'showFound': instance.showFound,
      'showAssignedOne': instance.showAssignedOne,
      'showAssignedAll': instance.showAssignedAll,
      'showSavedFromApi': instance.showSavedFromApi,
      'showObject': instance.showObject,
      'exportHtmlWithOriginalVerse': instance.exportHtmlWithOriginalVerse,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$BrightnessEnumMap = {
  Brightness.dark: 'dark',
  Brightness.light: 'light',
};
