/// Interface for constructing a list of objects of type [T] from a list of maps.
abstract class ILocalDbManager<T> {
  /// Override this method to define the behavior for constructing a list of objects of type [T] from a list of maps.
  ///
  /// Parameters:
  /// - [map] : A list of [Map<String, dynamic>] representing the objects to be constructed.
  ///
  ///  Returns a list of objects of type [T] constructed from the list of maps.
  List<T> constructObject(List<Map<String, dynamic>> map);
}
