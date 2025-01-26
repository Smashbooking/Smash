import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class ResetPasswordDialog extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter your email to receive a password reset link'),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(authNotifierProvider.notifier)
                .resetPassword(_emailController.text);
            Navigator.pop(context);
          },
          child: Text('Send Reset Link'),
        ),
      ],
    );
  }
}