import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/features/home/home.dart';
import 'package:instagram_clone/features/sign_in_page/sign_in_page.dart';
import 'package:instagram_clone/models/member_model.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/prefs.dart';
import 'package:instagram_clone/services/validator.dart';
import 'package:instagram_clone/theme/colors/colors.dart';
import 'package:instagram_clone/widgets/cool_auth_button.dart';
import 'package:instagram_clone/widgets/cool_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isVisible1 = false;
  bool isVisible2 = false;
  bool isLoading = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  get DBService => null;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void doAuth() {
    String name = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String cpassword = _repeatPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return;
    }

    if (cpassword != password) {
      Fluttertoast.showToast(
        msg: "Password and confirm password does not match",
      );
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

    AuthService.signUpUser(
      context,
      name,
      email,
      password,
    ).then((user) => {_getFirebaseUser(user, name, email)});
  }

  void _getFirebaseUser(User? user, name, email) async {
    setState(() {
      isLoading = false;
    });

    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Member member = Member(name, email);
      member.uid = user.uid;
      await DataService.storeUser(member);
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
                      controller: _fullNameController,
                      hintText: "Full Name",
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
                    CoolTextFieldForPassword(
                      controller: _repeatPasswordController,
                      hintText: "Repeat Password",
                      isVisible: isVisible2,
                    ),
                    CoolAuthButton(
                      onPressed: () {
                        doAuth();
                      },
                      child: isLoading
                          ? CircularProgressIndicator.adaptive()
                          : Text(
                              "Sign Up",
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
                    "Already have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: Text(
                      "Sign In",
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
