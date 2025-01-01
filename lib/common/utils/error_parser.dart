import 'dart:convert';

String errorParser(String error) {
  try {
    final Map<String, dynamic> decodedError = jsonDecode(error);

    if (decodedError.containsKey('message')) {
      return decodedError['message'];
    }

    if (decodedError.containsKey('detail')) {
      return decodedError['detail'];
    }

    return decodedError.entries.map((entry) => entry.value[0]).join(' ');
  } catch (_) {
    return "Something went wrong.";
  }
}
