import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../services/session_manager.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _primaryController = TextEditingController();
  final _passwordController = TextEditingController();
  String _userType = 'student';
  bool _isLoading = false;
  String _errorMessage = '';

  final String apiUrl = 'http://localhost/riasec_app/login.php';

  @override
  void dispose() {
    _primaryController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final Map<String, String> body = {
        "role":     _userType,
        "password": _passwordController.text.trim(),
      };

      if (_userType == 'student') {
        body['student_id'] = _primaryController.text.trim();
      } else {
        body['email'] = _primaryController.text.trim();
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        if (!mounted) return;

        final session = SessionManager();

        if (_userType == 'student') {
          session.setStudent({
            'studentId':   data['studentId']?.toString(),
            'firstName':   data['firstName'],
            'lastName':    data['lastName'],
            'hasApproved': data['hasApproved'],
          });
          context.go('/student/dashboard');
        } else {
          session.setCounselor({
            'counselorId': data['counselorId'],
            'firstName':   data['firstName'],
            'lastName':    data['lastName'],
          });
          context.go('/guidance-counselor/dashboard');
        }
      } else {
        setState(() => _errorMessage = data['message'] ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Could not connect to server.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryPurple.withOpacity(0.1),
              AppTheme.lilac.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.school,
                          size: 64,
                          color: AppTheme.primaryPurple,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'RIASEC Assessment',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Career Assessment System',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'student',
                              label: Text('Student'),
                              icon: Icon(Icons.person),
                            ),
                            ButtonSegment(
                              value: 'guidance_counselor',
                              label: Text('Counselor'),
                              icon: Icon(Icons.psychology),
                            ),
                          ],
                          selected: {_userType},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _userType = newSelection.first;
                              _primaryController.clear();
                              _errorMessage = '';
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _primaryController,
                          decoration: InputDecoration(
                            labelText: _userType == 'student' ? 'Student ID' : 'Email',
                            prefixIcon: Icon(
                              _userType == 'student' ? Icons.badge : Icons.email,
                            ),
                          ),
                          keyboardType: _userType == 'student'
                              ? TextInputType.text
                              : TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return _userType == 'student'
                                  ? 'Please enter your Student ID'
                                  : 'Please enter your email';
                            }
                            if (_userType == 'guidance_counselor' && !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 16),

                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Login'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}