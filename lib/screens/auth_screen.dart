import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppState>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    try {
      if (_isLogin) {
        await appState.signInWithEmail(
          _emailController.text.trim(), 
          _passwordController.text.trim()
        );
      } else {
        await appState.signUpWithEmail(
          _emailController.text.trim(), 
          _passwordController.text.trim()
        );
      }
      
      if (!mounted) return;

      // Handle special status messages from AppState (like emailAlreadyInUse or statusCheckEmail)
      if (!_isLogin) {
        if (appState.statusMessage.contains('emailAlreadyInUse')) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(l10n.emailAlreadyInUse), backgroundColor: Colors.orange)
          );
          return;
        } else if (Supabase.instance.client.auth.currentSession == null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(l10n.statusCheckEmail))
          );
          return;
        }
      }
      
      navigator.pop();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.statusLoginSuccess))
      );
    } catch (e) {
      if (!mounted) return;
      
      String errorMsg = e.toString();
      if (errorMsg.contains('Invalid login credentials')) {
        errorMsg = l10n.statusLoginFailed('Invalid credentials');
      } else if (errorMsg.contains('email_not_confirmed')) {
        // Handle unconfirmed email during login attempt
        errorMsg = l10n.statusCheckEmail;
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);

    // v15.8.6: Enhanced Auto-pop with better safety checks
    final user = appState.currentUser;
    if (user != null && !user.isAnonymous) {
      debugPrint('[AuthScreen] Authenticated user detected ($user.id). Attempting auto-pop.');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.of(context).canPop()) {
           // We use canPop() and then check if we should actually pop
           // to avoid popping past the root if somehow triggered twice
           Navigator.of(context).pop();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? l10n.login : l10n.signUp),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.orange.shade50],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.lock_person_rounded, size: 80, color: Colors.orange),
                const SizedBox(height: 40),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) {
                    final trimmedValue = value?.trim();
                    if (trimmedValue == null || trimmedValue.isEmpty) {
                      return l10n.invalidEmail;
                    }
                    final bool emailValid = 
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(trimmedValue);
                    if (!emailValid) {
                      return l10n.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Submit Button
                ElevatedButton(
                  onPressed: appState.isLoggingIn ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: appState.isLoggingIn 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_isLogin ? l10n.login : l10n.signUp, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                
                const SizedBox(height: 16),
                
                // Toggle Login/SignUp
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _formKey.currentState?.reset();
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  },
                  child: Text(_isLogin ? l10n.dontHaveAccount : l10n.alreadyHaveAccount),
                ),
                
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Kakao Login Button - Brand Guidelines (Yellow #FEE500)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: appState.isLoggingIn ? null : () async {
                      final navigator = Navigator.of(context);
                      await appState.loginWithKakao();
                      if (!mounted) return;
                      
                      if (appState.currentUser != null && !appState.currentUser!.isAnonymous) {
                        navigator.pop();
                      }
                    },
                    icon: const Icon(Icons.chat_bubble_rounded, color: Colors.black87, size: 24), // Kakao-like icon
                    label: Text(
                      l10n.kakaoContinue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE500),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Google Login Button - Improved Visibility
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: appState.isLoggingIn ? null : () async {
                      final navigator = Navigator.of(context);
                      await appState.loginWithGoogle();
                      if (!mounted) return;
                      
                      if (appState.currentUser != null && !appState.currentUser!.isAnonymous) {
                        navigator.pop();
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 28), // "G" feel icon
                    ),
                    label: Text(
                      l10n.googleContinue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
