import 'package:fab/compenents/mytextfield.dart';
import 'package:fab/screens/loginemail.dart';
import 'package:flutter/material.dart';

class Signinscreen extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  Signinscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //welcome-back
                    Text(
                      "Sign in With Email",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    //login-textfield
                    MyTextfield(
                      hinttext: "E-mail",
                      obscure: false,
                      controller: _emailcontroller,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    //password-textfield

                    MyTextfield(
                      hinttext: "Password",
                      obscure: true,
                      controller: _passwordcontroller,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    //login-button

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "already a User?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreenEmail();
                            }));
                          },
                          child: Text(
                            "Sign IN Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
