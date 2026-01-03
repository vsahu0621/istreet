// lib/ui/before_login/auth/sign_in_screen.dart (or your existing path)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/providers/after_login/nav_mode_provider.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';
import 'package:istreet/data/services/auth_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final void Function(String userType) onLoginSuccess; // Send userType back

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSignUp = false;
  bool _acceptTerms = false;

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTabs(),
                const SizedBox(height: 32),
                _isSignUp
                    ? _buildSignUpForm(authState)
                    : _buildSignInForm(authState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              "Sign In",
              !_isSignUp,
              () => setState(() => _isSignUp = false),
            ),
          ),
          Expanded(
            child: _buildTab(
              "Sign Up",
              _isSignUp,
              () => setState(() => _isSignUp = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          color: !isActive ? const Color(0xFFF1F5F9) : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to access your investment portfolio",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 32),

        _buildInputField(
          label: "Email / Username",
          controller: emailController,
          icon: Icons.email_outlined,
          hint: "Enter your email",
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: "Password",
          controller: passwordController,
          icon: Icons.lock_outline,
          hint: "Enter your password",
          isPassword: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Checkbox(
            //   value: _rememberMe,
            //   onChanged: (v) => setState(() => _rememberMe = v ?? false),
            // ),
            // const Text("Remember me"),
            // const Spacer(),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text(
            //     "Forgot?",
            //     style: TextStyle(color: Color(0xFF3B82F6)),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 30),

        // MAIN LOGIN BUTTON (this sets navMode and notifies parent)
        _buildPrimaryButton(
          text: "Sign In",
          isLoading: authState.isLoading,
          onPressed: () async {
            final message = await ref
                .read(authProvider.notifier)
                .login(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );

            final auth = ref.read(authProvider);

            if (auth.isLoggedIn) {
              final userType = auth.userType ?? 'generic';
             debugPrint("✅ Logged in userType: $userType");
              // 🔐 LOGIN STATE SAVE
              await AuthStorage.setLoggedIn(true);

              // 🔁 Switch to MyStreet
              ref.read(navModeProvider.notifier).state = AppNavMode.mystreet;

              widget.onLoginSuccess(userType);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message ?? "Login failed")),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSignUpForm(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create Account",
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: "Full Name",
          controller: nameController,
          icon: Icons.person_outline,
          hint: "Enter your full name",
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: "Phone Number",
          controller: phoneController,
          icon: Icons.phone_outlined,
          hint: "Enter your phone number",
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: "Email Address",
          controller: emailController,
          icon: Icons.email_outlined,
          hint: "Enter your email",
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: "Password",
          controller: passwordController,
          icon: Icons.lock_outline,
          hint: "Create a strong password",
          isPassword: true,
        ),
        const SizedBox(height: 20),
        CheckboxListTile(
          value: _acceptTerms,
          onChanged: (v) => setState(() => _acceptTerms = v ?? false),
          title: const Text("I agree to Terms & Conditions"),
        ),
        const SizedBox(height: 20),

        _buildPrimaryButton(
          text: "Create Account",
          isLoading: authState.isLoading,
          onPressed: () async {
            if (!_acceptTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please accept Terms & Conditions"),
                ),
              );
              return;
            }
            final message = await ref
                .read(authProvider.notifier)
                .register(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                  password: passwordController.text.trim(),
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message ?? "Registration error")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF3B82F6),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }
}
