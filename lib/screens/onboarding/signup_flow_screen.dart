import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../state/instagram_state.dart';

class SignupFlowScreen extends StatefulWidget {
  final bool isLoginMode;

  const SignupFlowScreen({super.key, this.isLoginMode = false});

  @override
  State<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends State<SignupFlowScreen> {
  late bool _isLogin;
  int _currentStep = 0;

  // Controllers
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _avatarUrlController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberPassword = true;
  bool _isPhoneSelected = false;
  final DateTime _selectedBirthday = DateTime(2001, 5, 20);

  final List<String> _avatarChoices = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500&auto=format&fit=crop&q=80',
  ];
  String _selectedAvatar = '';

  final Set<String> _followedUserIds = {};

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLoginMode;
  }

  @override
  void dispose() {
    _contactController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 7) {
      setState(() => _currentStep++);
    } else {
      _finishOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _finishOnboarding() {
    final state = InstagramScope.of(context);
    final avatar = _selectedAvatar.isNotEmpty
        ? _selectedAvatar
        : _avatarUrlController.text.trim();
    state.register(
      username: _usernameController.text.trim().isNotEmpty
          ? _usernameController.text.trim()
          : 'new_user',
      fullName: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'Instagram User',
      emailOrPhone: _contactController.text.trim(),
      password: _passwordController.text.trim(),
      avatarUrl: avatar,
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: _previousStep,
        ),
      ),
      body: SafeArea(
        child: _isLogin ? _buildLoginView() : _buildWizardStep(),
      ),
    );
  }

  // --- LOGIN MODE VIEW ---
  Widget _buildLoginView() {
    final state = InstagramScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 1),
          const Text(
            'Instagram',
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 48,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 36),
          _buildTextField(
            controller: _contactController,
            hint: 'Username, email or mobile number',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _passwordController,
            hint: 'Password',
            isPassword: true,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Color(0xFF00376B),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                state.login(
                  username: _contactController.text.trim(),
                  password: _passwordController.text.trim(),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const Spacer(flex: 2),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isLogin = false),
                  child: const Text(
                    'Sign up.',
                    style: TextStyle(
                      color: Color(0xFF0095F6),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MULTI-STEP ONBOARDING WIZARD ---
  Widget _buildWizardStep() {
    switch (_currentStep) {
      case 0:
        return _buildContactStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildNamePasswordStep();
      case 3:
        return _buildBirthdayStep();
      case 4:
        return _buildUsernameStep();
      case 5:
        return _buildTermsStep();
      case 6:
        return _buildProfilePicStep();
      case 7:
        return _buildDiscoverPeopleStep();
      default:
        return _buildContactStep();
    }
  }

  // Step 0: Phone / Email
  Widget _buildContactStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your mobile number or email?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the mobile number or email where you can be reached. No one will see this on your profile.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // Phone / Email Segmented Tab
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPhoneSelected = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: !_isPhoneSelected
                              ? Colors.black87
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Email address',
                        style: TextStyle(
                          fontWeight: !_isPhoneSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: !_isPhoneSelected
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPhoneSelected = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _isPhoneSelected
                              ? Colors.black87
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Mobile number',
                        style: TextStyle(
                          fontWeight: _isPhoneSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _isPhoneSelected
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: _contactController,
            hint: _isPhoneSelected ? 'Mobile number' : 'Email address',
            keyboardType: _isPhoneSelected
                ? TextInputType.phone
                : TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton(text: 'Next', onPressed: _nextStep),
          const Spacer(),
          _buildAlreadyHaveAccountRow(),
        ],
      ),
    );
  }

  // Step 1: Confirmation Code
  Widget _buildOtpStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the confirmation code',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'To confirm your account, enter the 6-digit code we sent to ${_contactController.text}.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _otpController,
            hint: 'Confirmation code',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code resent! Use 839210')),
              );
            },
            child: const Text(
              'I didn\'t get the code',
              style: TextStyle(
                color: Color(0xFF0095F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPrimaryButton(text: 'Next', onPressed: _nextStep),
          const Spacer(),
          _buildAlreadyHaveAccountRow(),
        ],
      ),
    );
  }

  // Step 2: Name & Password
  Widget _buildNamePasswordStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name and password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your name so your friends can find you on Instagram.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nameController,
            hint: 'Full name',
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _passwordController,
            hint: 'Password (at least 6 characters)',
            isPassword: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _rememberPassword,
                activeColor: const Color(0xFF0095F6),
                onChanged: (val) =>
                    setState(() => _rememberPassword = val ?? true),
              ),
              const Text('Remember password', style: TextStyle(fontSize: 13.5)),
            ],
          ),
          const SizedBox(height: 16),
          _buildPrimaryButton(
            text: 'Continue and sync contacts',
            onPressed: _nextStep,
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: _nextStep,
              child: const Text(
                'Continue without syncing contacts',
                style: TextStyle(color: Color(0xFF0095F6), fontSize: 13),
              ),
            ),
          ),
          const Spacer(),
          _buildAlreadyHaveAccountRow(),
        ],
      ),
    );
  }

  // Step 3: Birthday
  Widget _buildBirthdayStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add your birthday',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'This won\'t be part of your public profile.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedBirthday.day} ${_getMonthName(_selectedBirthday.month)} ${_selectedBirthday.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${DateTime.now().year - _selectedBirthday.year} years old',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton(text: 'Next', onPressed: _nextStep),
          const Spacer(),
          _buildAlreadyHaveAccountRow(),
        ],
      ),
    );
  }

  // Step 4: Create a Username
  Widget _buildUsernameStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create a username',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a username or use our suggestion. You can change this at any time.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _usernameController,
            hint: 'Username',
            suffixIcon: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton(text: 'Next', onPressed: _nextStep),
          const Spacer(),
          _buildAlreadyHaveAccountRow(),
        ],
      ),
    );
  }

  // Step 5: Terms & Policies
  Widget _buildTermsStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agree to Instagram\'s terms and policies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Text(
            'People who use our service may have uploaded your contact information to Instagram.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 14),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(text: 'By tapping '),
                TextSpan(
                  text: 'I agree',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ', you agree to create an account and to Instagram\'s Terms, Privacy Policy and Cookies Policy.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildPrimaryButton(text: 'I agree', onPressed: _nextStep),
          const Spacer(),
          _buildAlreadyHaveAccountRow(),
        ],
      ),
    );
  }

  // Step 6: Add Profile Picture
  Widget _buildProfilePicStep() {
    final hasAvatar = _selectedAvatar.isNotEmpty || _avatarUrlController.text.trim().isNotEmpty;
    final displayUrl = _selectedAvatar.isNotEmpty ? _selectedAvatar : _avatarUrlController.text.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Add a profile picture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a profile picture so your friends know it\'s you. Everyone will be able to see your picture.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // Selected Avatar Circle
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: hasAvatar ? NetworkImage(displayUrl) : null,
              child: !hasAvatar
                  ? Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
            const SizedBox(height: 20),

            // Custom URL input field
            _buildTextField(
              controller: _avatarUrlController,
              hint: 'Paste photo URL (optional)',
              keyboardType: TextInputType.url,
              suffixIcon: IconButton(
                icon: const Icon(Icons.check, color: Color(0xFF0095F6)),
                onPressed: () {
                  setState(() {
                    _selectedAvatar = _avatarUrlController.text.trim();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Quick Avatar Picker Carousel
            const Text(
              'Or choose a starter avatar:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _avatarChoices.map((url) {
                final isSelected = url == _selectedAvatar;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = url;
                      _avatarUrlController.text = url;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0095F6)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            _buildPrimaryButton(text: 'Continue', onPressed: _nextStep),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() => _selectedAvatar = '');
                _nextStep();
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFF0095F6),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Step 7: Welcome & Discover People to Follow
  Widget _buildDiscoverPeopleStep() {
    final suggested = MockData.suggestedUsers;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Discover people',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Follow 3 or more accounts to see photos and videos in your feed.',
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: suggested.length,
              itemBuilder: (context, index) {
                final user = suggested[index];
                final isFollowing = _followedUserIds.contains(user.id);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Row(
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            color: Color(0xFF0095F6), size: 14),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    user.fullName,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        if (isFollowing) {
                          _followedUserIds.remove(user.id);
                        } else {
                          _followedUserIds.add(user.id);
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isFollowing ? Colors.white : const Color(0xFF0095F6),
                      side: BorderSide(
                        color: isFollowing
                            ? Colors.grey.shade300
                            : const Color(0xFF0095F6),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        color: isFollowing ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildPrimaryButton(
            text: 'Finish & Go to Feed',
            onPressed: _finishOnboarding,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // --- REUSABLE COMPONENTS ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                )
              : suffixIcon,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0095F6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyHaveAccountRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: GestureDetector(
          onTap: () => setState(() => _isLogin = true),
          child: const Text(
            'Already have an account? Log in.',
            style: TextStyle(
              color: Color(0xFF0095F6),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
