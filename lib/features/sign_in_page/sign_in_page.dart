import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/features/home/home.dart';
import 'package:instagram_clone/features/sign_up_page/sign_up_page.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/prefs.dart';
import 'package:instagram_clone/services/validator.dart';
import 'package:instagram_clone/theme/colors/colors.dart';
import 'package:instagram_clone/widgets/cool_auth_button.dart';
import 'package:instagram_clone/widgets/cool_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isVisible1 = false;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void doAuth() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    if (!Validators.validateEmail(email)) {
      Fluttertoast.showToast(msg: "Enter a valid email");
      return;
    }

    if (!Validators.validatePassword(password)) {
      Fluttertoast.showToast(
        msg:
            "Password must have uppercase, lowercase, number and special character",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    User? user = await AuthService.signInUser(context, email, password);
    _getFirebaseUser(user);
  }

  void _getFirebaseUser(User? user) async {
    setState(() {
      isLoading = false;
    });

    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Check your email or password");
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryFirst, AppColors.primarySecond],
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Instagram",
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.white,
                        fontFamily: "Billabong",
                      ),
                    ),
                    CoolTextField(
                      controller: _emailController,
                      hintText: "Email",
                    ),
                    CoolTextFieldForPassword(
                      controller: _passwordController,
                      hintText: "Password",
                      isVisible: isVisible1,
                    ),
                    CoolAuthButton(
                      onPressed: () {
                        doAuth();
                      },
                      child: isLoading
                          ? CircularProgressIndicator.adaptive()
                          : Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don`t have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
