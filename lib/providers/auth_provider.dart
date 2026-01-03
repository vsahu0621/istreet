import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/auth_response.dart';
import 'package:istreet/data/services/auth_api.dart';
import 'package:istreet/data/services/auth_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isLoggedIn;
  final String? token;
  final String? refreshToken;
  final String? name;
  final String? email;
  final int? userId;
  final String? userType; // NEW
  final String? dashboard; // NEW

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isLoggedIn = false,
    this.token,
    this.refreshToken,
    this.name,
    this.email,
    this.userId,
    this.userType,
    this.dashboard,
  });

  // get user => null;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isLoggedIn,
    String? token,
    String? refreshToken,
    String? name,
    String? email,
    int? userId,
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
      userId: userId ?? this.userId,
      userType: userType ?? this.userType, // NEW
      dashboard: dashboard ?? this.dashboard, // NEW
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

      final AuthResponse res = await _api.login(
        email: email,
        password: password,
      );

      if (res.status == 'success') {
        final decoded = JwtDecoder.decode(res.token!);
        final userId = int.tryParse(decoded['user_id'].toString());
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          token: res.token,
          refreshToken: res.refresh,
          name: res.name,
          email: res.email,
          userId: userId,
          userType: res.userType,
          dashboard: res.dashboard,
        );

        // 🔑 SAVE FOR NEXT APP START
        await AuthStorage.setLoggedIn(true);
        await AuthStorage.setToken(res.token!);
        await AuthStorage.setRefreshToken(res.refresh!);
        await AuthStorage.setUserType(res.userType!); 
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
        state = state.copyWith(isLoading: false, errorMessage: null);
        return res.message;
      } else {
        state = state.copyWith(isLoading: false, errorMessage: res.message);
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
