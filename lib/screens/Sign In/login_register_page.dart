import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_uploading/service/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  late DatabaseReference userDB;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      String email = _controllerEmail.text.trim();
      String password = _controllerPassword.text.trim();
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Retrieve the UID of the newly created user
      String uid = userCredential.user!.uid;

      // Store user data in Realtime Database
      await storeUserData(uid, firstName, lastName, email);

      print('User created successfully');
    } catch (e) {
      print('Error creating user: $e');
      // Handle the error as needed
    }
  }

  Future<void> storeUserData(
      String userId, String firstName, String lastName, String email) async {
    try {
      final ref = FirebaseDatabase.instance.reference().child('Users');

      await ref.child(userId).set({
        'user_id': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'bio': '',
      });

      print('User data stored in Realtime Database');
    } catch (e) {
      print('Error storing user data: $e');
      // Handle the error as needed
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : signUpWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead ' : 'Login instead'),
    );
  }

  @override
  void initState() {
    super.initState();
    userDB = FirebaseDatabase.instance.ref().child('Users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 239, 239),
      body: SingleChildScrollView(
        child: isLogin
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 100, top: 180),
                    child: Text(
                      "Video Uploading",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "email cannot be empty";
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _controllerEmail,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "password cannot be empty";
                          }
                          return null;
                        },
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        controller: _controllerPassword,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'password',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(child: _submitButton()),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(child: _loginOrRegistrationButton()),
                  Center(child: _errorMessage()),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50, top: 80),
                    child: Text(
                      "SignUp to SMART HOME",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        // ignore: non_constant_identifier_names
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "First Name cannot be empty";
                          } else if (Value.length < 3) {
                            return 'First Name must be more than 2 character';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'FirstName',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "Last Name cannot be empty";
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'LastName',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "email cannot be empty";
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: _controllerEmail,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "password cannot be empty";
                          }
                          return null;
                        },
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: _controllerPassword,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(Icons.key, color: Colors.grey),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: HexColor('#6FC1C5'),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "password cannot be empty";
                          } else if (Value != _controllerPassword.text) {
                            return "password doesn't Match";
                          }
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(6),
                          hintText: 'ConfirmPassword',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(Icons.key, color: Colors.grey),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: HexColor('#6FC1C5'),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(child: _submitButton()),
                  Center(
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: HexColor('#6FC1C5'),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(child: _loginOrRegistrationButton()),
                  Center(child: _errorMessage()),
                ],
              ),
      ),
    );
  }
}
