
import 'package:flutter_hacker_news_app/providers/authentication_provider.dart';
import 'package:flutter_hacker_news_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isVisible = false;


  final box = GetStorage();
  RouteSettings settings;
  final auth = Authentication();

  @override
  Widget build(BuildContext context) {
    print(box.read("key"));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
      body: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
                width: 200,
              ),

              // Login text Widget
              Center(
                child: Container(
                  height: 200,
                  width: 400,
                  alignment: Alignment.center,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(
                height: 60,
                width: 10,
              ),

              // Wrong Password text
              Visibility(
                visible: _isVisible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Wrong credentials entered",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              // Textfields for username and password fields
              Container(
                height: 140,
                width: 530,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onTap: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },
                      controller: usernameController, // Controller for Username
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Username",
                          contentPadding: EdgeInsets.all(20)),
                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    TextFormField(
                      onTap: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },

                      controller: passwordController, // Controller for Password
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          contentPadding: EdgeInsets.all(20),
                          // Adding the visibility icon to toggle visibility of the password field
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          )),
                      obscureText: _isObscure,
                    ),
                  ],
                ),
              ),

              // Submit Button
              Container(
                width: 570,
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                    color: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {
                      if (auth.fetchCredentials(
                          usernameController.text, passwordController.text)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                        box.write("key", "password");
                      } else {
                        setState(() {
                          _isVisible = true;
                        });
                      }
                    },
                    child: const Text("Submit", style: TextStyle(color: Colors.white))),
              ),
            ],
          )),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            child: const Text(
              "Hacker News App, v.01",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}