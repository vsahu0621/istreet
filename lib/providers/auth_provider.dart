import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/auth_response.dart';
import 'package:istreet/data/services/auth_api.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isLoggedIn;
  final String? token;
  final String? refreshToken;
  final String? name;
  final String? email;

  final String? userType;     // NEW
  final String? dashboard;    // NEW

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isLoggedIn = false,
    this.token,
    this.refreshToken,
    this.name,
    this.email,
    this.userType,
    this.dashboard,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isLoggedIn,
    String? token,
    String? refreshToken,
    String? name,
    String? email,
    String? userType,
    String? dashboard,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      name: name ?? this.name,
      email: email ?? this.email,

      userType: userType ?? this.userType,      // NEW
      dashboard: dashboard ?? this.dashboard,   // NEW
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi _api;

  AuthNotifier(this._api) : super(const AuthState());

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final AuthResponse res = await _api.login(email: email, password: password);

      if (res.status == 'success') {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          errorMessage: null,
          token: res.token,
          refreshToken: res.refresh,
          name: res.name,
          email: res.email,

          userType: res.userType,        // NEW
          dashboard: res.dashboard,      // NEW
        );
        return res.message;
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: false,
          errorMessage: res.message,
        );
        return res.message;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return 'Something went wrong. Please try again.';
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final AuthResponse res = await _api.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (res.status == 'success') {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
        return res.message;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: res.message,
        );
        return res.message;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return 'Something went wrong. Please try again.';
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final api = ref.watch(authApiProvider);
  return AuthNotifier(api);
});
