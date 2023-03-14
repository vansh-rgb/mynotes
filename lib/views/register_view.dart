import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter Your Email Here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Enter Your Password Here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final navigator = Navigator.of(context);
              
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(userCredential.toString());
                navigator.pushNamed(verifymailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showErrorDialog(context, 'Weak Password');
                  devtools.log('Weak Password');
                  showErrorDialog(context, e.code.toString());
                } else if (e.code == 'email-already-in-use') {
                  showErrorDialog(context, 'Email already in use');
                  devtools.log('Email already in use');
                } else if (e.code == 'invalid-email') {
                  showErrorDialog(context, 'Invalid Email entered');
                  devtools.log('Invalid Email entered');
                }
              }
              
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already have an account? Login Here!'),
          ),
        ],
      ),
    );
  }
}
