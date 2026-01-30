extension StringExtensions on String {
  String capitalize({
    String splitter = ' ',
    String delimiter = ' ',
    bool capitalizeAnd = false,
  }) {
    if (length <= 1) {
      return toUpperCase();
    }
    StringBuffer stringBuffer = StringBuffer();
    List<String> words = split(splitter);
    for (final word in words) {
      if (word.length <= 1) {
        stringBuffer.write(word.toUpperCase());
      } else if (word.toLowerCase() == 'and') {
        if (capitalizeAnd) {
          stringBuffer.write(word.substring(0, 1).toUpperCase());
          stringBuffer.write(word.substring(1));
        } else {
          stringBuffer.write(word);
        }
      } else {
        stringBuffer.write(word.substring(0, 1).toUpperCase());
        stringBuffer.write(word.substring(1));
      }
      if (words.length > 1) {
        stringBuffer.write(delimiter);
      }
    }
    return stringBuffer.toString();
  }
}
