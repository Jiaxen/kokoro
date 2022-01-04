import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/login_utils.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'notes_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryAppColour,
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Padding(
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '心',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: kSecondaryAppColour,
                      fontSize: 144,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Kokoro',
                        style: TextStyle(
                            color: kPrimaryFontColour,
                            fontSize: 48,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Relationship Meetings',
                        style: TextStyle(
                            color: kPrimaryFontColour,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 15),
                      SignInButton(Buttons.Google, text: 'Continue with Google',
                          onPressed: () async {
                        final progress = ProgressHUD.of(context);
                        progress?.show();
                        try {
                          UserCredential user = await signInWithGoogle();
                          Navigator.pushNamed(context, NotesScreen.id);
                        } catch (e) {
                          _errorMessage = e.toString();
                        }
                        progress?.dismiss();
                      }),
                      SignInButton(Buttons.Facebook,
                          text: 'Continue with Facebook',
                          onPressed: signInWithFacebook),
                      if (_errorMessage != null) _buildLoginMessage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginMessage() => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 18),
        child: Text(
          _errorMessage!,
          style: TextStyle(
            fontSize: 14,
            color: kErrorTextColorLight,
          ),
        ),
      );
}
