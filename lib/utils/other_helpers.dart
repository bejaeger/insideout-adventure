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
