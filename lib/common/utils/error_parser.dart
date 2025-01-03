String errorParser(dynamic responseData) {
  if (responseData is String) {
    return responseData;
  } else if (responseData is Map<String, dynamic>) {
    // Check for error keys in the JSON
    if (responseData.containsKey('error')) {
      return responseData['error'] as String;
    } else if (responseData.containsKey('message')) {
      return responseData['message'] as String;
    }
  }

  // Default fallback
  return 'An unknown error occurred.';
}
