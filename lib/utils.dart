import 'package:collection/collection.dart';

T? enumFromString<T>(Iterable<T> values, String value) {
return values.firstWhereOrNull((type) => type.toString().split(".").last == value.toLowerCase());
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

List<String> enumToCapitalisedList<T>(Iterable<T> enumeration) {
  return enumeration.map((e) => enumToCapitalisedString(e)).toList();
}

String enumToString(element) => element.toString().split(".").last;

String enumToCapitalisedString(element) => enumToString(element).capitalize();