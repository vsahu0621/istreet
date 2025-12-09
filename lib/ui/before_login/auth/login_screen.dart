import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // Light background
              Color(0xFFEFF6FF), // Very light blue
              Color(0xFFDBEAFE), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _fadeAnimation != null
                  ? FadeTransition(
                      opacity: _fadeAnimation!,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Section
                          _buildLogo(),
                          const SizedBox(height: 40),

                          // Main Card
                          _buildMainCard(),

                          const SizedBox(height: 32),

                          // Footer
                          _buildFooter(),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Section
                        _buildLogo(),
                        const SizedBox(height: 40),

                        // Main Card
                        _buildMainCard(),

                        const SizedBox(height: 32),

                        // Footer
                        _buildFooter(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Column(
      children: [
        Text(
          'iStreet',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A84FF).withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tabs
          _buildTabs(),
          const SizedBox(height: 32),

          // Form Content
          _isSignUp ? _buildSignUpForm() : _buildSignInForm(),
        ],
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
            child: _buildTab('Sign In', !_isSignUp, () {
              setState(() => _isSignUp = false);
            }),
          ),
          Expanded(
            child: _buildTab('Sign Up', _isSignUp, () {
              setState(() => _isSignUp = true);
            }),
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
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to access your investment portfolio',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),

        // Email Field
        _buildInputField(
          label: 'Email / Username',
          controller: emailController,
          icon: Icons.email_outlined,
          hint: 'Enter your email',
        ),
        const SizedBox(height: 20),

        // Password Field
        _buildInputField(
          label: 'Password',
          controller: passwordController,
          icon: Icons.lock_outline,
          hint: 'Enter your password',
          isPassword: true,
        ),
        const SizedBox(height: 16),

        // Remember Me & Forgot Password
        Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                      fillColor: MaterialStateProperty.all(
                        const Color(0xFFF8FAFC),
                      ),
                      checkColor: const Color(0xFF1E40AF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Remember me',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Forgot?',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Sign In Button
        _buildPrimaryButton(
          text: 'Sign In',
          onPressed: () {
            debugPrint("Login pressed");
            debugPrint(emailController.text);
            debugPrint(passwordController.text);
          },
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join thousands of smart investors on iStreet',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),

        // Full Name Field
        _buildInputField(
          label: 'Full Name',
          controller: nameController,
          icon: Icons.person_outline,
          hint: 'Enter your full name',
        ),
        const SizedBox(height: 20),

        // Phone Field
        _buildInputField(
          label: 'Phone Number',
          controller: phoneController,
          icon: Icons.phone_outlined,
          hint: '+91 98765 43210',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        // Email Field
        _buildInputField(
          label: 'Email Address',
          controller: emailController,
          icon: Icons.email_outlined,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // Password Field
        _buildInputField(
          label: 'Password',
          controller: passwordController,
          icon: Icons.lock_outline,
          hint: 'Create a strong password',
          isPassword: true,
        ),
        const SizedBox(height: 16),

        // Terms & Conditions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() => _acceptTerms = value ?? false);
                },
                fillColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.1),
                ),
                checkColor: const Color(0xFF0A84FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    'I agree to the ',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    ' and ',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Create Account Button
        _buildPrimaryButton(
          text: 'Create Account',
          onPressed: () {
            debugPrint("Sign Up pressed");
            debugPrint(nameController.text);
            debugPrint(phoneController.text);
            debugPrint(emailController.text);
            debugPrint(passwordController.text);
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
    TextInputType? keyboardType,
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
            obscureText: isPassword && _obscurePassword,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF3B82F6),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
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
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const SizedBox.shrink();
  }
}
