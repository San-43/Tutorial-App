class Resource {
  final String title;
  final String url;
  bool visited;

  Resource({
    required this.title,
    required this.url,
    this.visited = false,
  });
}