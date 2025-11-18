// lib/src/list_utils.dart
class ListUtils {
  ListUtils._();

  static List<T> unique<T>(List<T> list) => list.toSet().toList();

  static List<List<T>> chunk<T>(List<T> list, int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < list.length; i += size) {
      chunks.add(list.sublist(i, i + size > list.length ? list.length : i + size));
    }
    return chunks;
  }

  static List<T> flatten<T>(List<List<T>> list) =>
      list.expand((e) => e).toList();

  static List<T> removeDuplicates<T>(List<T> list) => unique(list);

  static List<T> paginate<T>(List<T> list, int page, int size) {
    final start = (page - 1) * size;
    if (start >= list.length) return [];
    return list.sublist(start, start + size > list.length ? list.length : start + size);
  }
}
