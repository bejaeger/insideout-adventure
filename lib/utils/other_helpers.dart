List<List<T>> getChunksOfList<T>(List<T> list, {int size = 1}) {
  var len = list.length;
  var size = 2;
  List<List<T>> chunks = [];

  for (var i = 0; i < len; i += size) {
    var end = (i + size < len) ? i + size : len;
    chunks.add(list.sublist(i, end));
  }
  return chunks;
}

String removeLastCharacters(String string, {int removeNumber = 1}) {
  String returnValue = string.substring(0, string.length - removeNumber);
  return returnValue;
}
