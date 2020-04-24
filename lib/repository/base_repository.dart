abstract class BaseRepository<T> {
  Future<void> add(T t);

  Future<void> delete(T t);

  Stream<List<T>> getAll();

  Future<void> update(T t);
}