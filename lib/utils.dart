import 'package:collection/collection.dart';

T? enumFromString<T>(Iterable<T> values, String value) {
return values.firstWhereOrNull((type) => type.toString().split(".").last == value);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

List<String> enumToCapitalisedList<T>(Iterable<T> enumeration) {
  List<String> a = [];
  for (var element in enumeration) { a.add(enumToString(element));}
  return a;
}

String enumToString(element) => element.toString().split(".").last.capitalize();