class University {
  const University({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
  });

  final String id;
  final String name;
  final String location;
  final String? logoUrl;
}
