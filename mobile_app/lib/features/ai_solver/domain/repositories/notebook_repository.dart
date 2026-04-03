abstract class NotebookRepository {
  Future<List<String>> loadNotebooks();
  Future<List<String>> addNotebook(String name, List<String> current);
}
