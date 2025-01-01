class RegisterAuthRequest {
  final String name;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String country;

  RegisterAuthRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'country': country,
    };
  }
}
