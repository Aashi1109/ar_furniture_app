class AuthModel {
  final String name;
  final String imageUrl;
  final DateTime userCreationDate;
  final bool isAdmin;

  AuthModel({
    required this.imageUrl,
    required this.name,
    required this.userCreationDate,
    this.isAdmin = false,
  });
}
