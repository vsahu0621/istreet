class AuthResponse {
  final String status;
  final String message;
  final String? token;
  final String? refresh;
  final String? name;
  final String? email;

  final String? userType;    // NEW
  final String? dashboard;   // NEW

  AuthResponse({
    required this.status,
    required this.message,
    this.token,
    this.refresh,
    this.name,
    this.email,
    this.userType,
    this.dashboard,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['token'],
      refresh: json['refresh'],
      name: json['name'],
      email: json['email'],

      userType: json['user_type'],      // NEW
      dashboard: json['dashboard'],     // NEW
    );
  }
}
