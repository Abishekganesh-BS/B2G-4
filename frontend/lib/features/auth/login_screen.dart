import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';
import '../../widgets/common/nurture_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
      // Router redirect handles navigation based on auth state
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: NurtureColors.background,
      body: Row(
        children: [
          // ── Left branding panel (wide screens only) ──────────────────────
          if (isWide)
            Expanded(
              child: _BrandingPanel(),
            ),

          // ── Right form panel ─────────────────────────────────────────────
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isWide) ...[
                        const _NurtureAILogo(),
                        const SizedBox(height: 40),
                      ],

                      Text(
                        'Welcome back',
                        style: GoogleFonts.nunito(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: NurtureColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue your journey',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: NurtureColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      NurtureButton(
                        label: 'Sign In',
                        onPressed: _isLoading ? null : _login,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: NurtureColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              'Register',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: NurtureColors.pinkAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _NurtureAILogo extends StatelessWidget {
  const _NurtureAILogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [NurtureColors.pinkAccent, Color(0xFFFF80AB)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Text(
          'Mama Care',
          style: GoogleFonts.nunito(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: NurtureColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFCE4EC),
            Color(0xFFF8BBD0),
            Color(0xFFE1F5FE),
          ],
        ),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: NurtureColors.pinkAccent.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.favorite_rounded,
                color: NurtureColors.pinkAccent, size: 36),
          ),
          const SizedBox(height: 32),
          Text(
            'NurtureAI',
            style: GoogleFonts.nunito(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: NurtureColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your intelligent companion\nfor the healthy journey.',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: NurtureColors.textPrimary.withOpacity(0.65),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 48),
          const _FeatureChip(
              icon: Icons.monitor_heart_outlined,
              label: 'Metabolic Monitoring'),
          const SizedBox(height: 16),
          const _FeatureChip(
              icon: Icons.psychology_outlined,
              label: 'Mental Well-being'),
          const SizedBox(height: 16),
          const _FeatureChip(
              icon: Icons.child_care_outlined,
              label: 'Infant Growth Tracking'),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: NurtureColors.pinkAccent.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: NurtureColors.pinkAccent, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: NurtureColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
