import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../state/instagram_state.dart';
import 'signup_flow_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      InstagramScope.of(context).login(
        username: username,
        password: _passwordController.text.trim(),
      );
    } else {
      // If blank, take user to sign up
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupFlowScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final user = state.currentUser;
    final hasExistingAccount = user.username.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Language Selector
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'English (United States)',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      size: 18, color: Colors.grey.shade600),
                ],
              ),
            ),
            const Spacer(flex: 2),

            // Instagram Logo
            const Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 54,
                color: Colors.black87,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 36),

            // Card: Either "Continue as..." or Clean Login
            if (hasExistingAccount)
              _buildContinueAsCard(context, state, user)
            else
              _buildFreshWelcomeCard(context),

            const Spacer(flex: 3),

            // Divider & Bottom CTA
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Create New Account Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupFlowScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0095F6), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create new account',
                    style: TextStyle(
                      color: Color(0xFF0095F6),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Meta Footer Branding
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'from ',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                Text(
                  'Meta',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueAsCard(
      BuildContext context, InstagramState state, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFBAA47),
                  Color(0xFFD91A46),
                  Color(0xFFA60F93),
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: user.avatarUrl.isEmpty
                  ? Text(
                      user.username.isNotEmpty
                          ? user.username[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user.username,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => state.login(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue as ${user.fullName.isNotEmpty ? user.fullName.split(' ').first : user.username}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupFlowScreen(isLoginMode: true),
                ),
              );
            },
            child: const Text(
              'Log into another account',
              style: TextStyle(
                color: Color(0xFF0095F6),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreshWelcomeCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Phone number, username, or email',
                hintStyle:
                    TextStyle(fontSize: 13.5, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle:
                    TextStyle(fontSize: 13.5, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
