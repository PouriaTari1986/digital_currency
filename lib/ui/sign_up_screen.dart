import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_a/models/crypto_model/user_model.dart';
import 'package:training_a/network/response_model.dart';
import 'package:training_a/ui/ui_helper/main_wrapper.dart';

import '../providers/register_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  late RegisterProvider userProvider;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<RegisterProvider>(context);
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Lottie.asset(
              'assets/images/waveloop.json',
              height: height * 0.2,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Sign up",
                style: GoogleFonts.ubuntu(
                  fontSize: height * 0.035,
                  color: Theme.of(context).unselectedWidgetColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Create Account",
                style: GoogleFonts.ubuntu(
                  fontSize: height * 0.03,
                  color: Theme.of(context).unselectedWidgetColor,
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'User Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your user-name';
                        } else if (value.length < 4) {
                          return 'User-name must be at least 4 characters';
                        } else if (value.length > 13) {
                          return 'User-name must be less than 13 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        hintText: "gmail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter your gmail';
                        } else if (!value.endsWith("@gmail.com")) {
                          return 'please enter a valid gmail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        hintText: 'password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter your password";
                        } else if (value.length < 7) {
                          return "password must be at least 7 characters";
                        } else if (value.length > 13) {
                          return "password must be less than 13 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Creating an account means you are accepted our Terms of Services and our Privacy Policy",
                      style: GoogleFonts.ubuntu(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.02),
                    Consumer<RegisterProvider>(
                      builder: (context, value, child) {
                        switch (value.registerStatus?.status) {
                          case Status.LOADING:
                            return CircularProgressIndicator();
                          case Status.COMPLETE:
                            savedLogin(value.registerStatus?.data);
                            WidgetsBinding.instance.addPostFrameCallback(
                                  (timeStamp) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainWrapper(),
                                ),
                              ),
                            );
                            return signUpBtn();
                          case Status.ERROR:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                signUpBtn(),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.error, color: Colors.redAccent),
                                    SizedBox(width: 6),
                                    Text(
                                      value.registerStatus!.message,
                                      style: GoogleFonts.ubuntu(
                                        color: Colors.redAccent,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );

                          default:
                            return signUpBtn();
                        }
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 8,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WidgetStateColor.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                Theme.of(context).primaryColor;
                              }
                              return Colors.white;
                            }),
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Login",
                            style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }

  Widget signUpBtn() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Theme.of(context).primaryColor;
            } else {
              return Theme.of(context).primaryColor;
            }
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            userProvider.callRegisterApi(
              nameController.text,
              emailController.text,
              passwordController.text,
            );
          }
        },
        child: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  void savedLogin(UserModel model) async{
    final prfes = await SharedPreferences.getInstance();

    prfes.setString("user_token", model.token!);
    prfes.setBool("loggedIn", true);
  }
}
