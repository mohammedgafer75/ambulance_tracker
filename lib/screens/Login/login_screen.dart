import 'package:ambulance_tracker/Animation/FadeAnimation.dart';
import 'package:ambulance_tracker/screens/PatienPage/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Components/custom_textfield.dart';
import '../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                // decoration: const BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage('assets/images/background.png'),
                //         fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child:
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),

                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child:
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),

                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child:
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),

                    Positioned(
                      child:
                          Container(
                            margin: const EdgeInsets.only(top: 80),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: <Widget>[

                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                ),
                                CustomTextField(
                                    bol: false,
                                    controller: controller.email,
                                    validator: (validator) {
                                      return controller
                                          .validateEmail(validator!);
                                    },
                                    lable: 'Email',
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                    input: TextInputType.emailAddress),
                                SizedBox(
                                  height: 40,
                                ),
                                CustomTextField(
                                    bol: true,
                                    controller: controller.password,
                                    validator: (validator) {
                                      return controller
                                          .validatePassword(validator!);
                                    },
                                    lable: 'Password',
                                    icon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    input: TextInputType.text),
                              ],
                            ),
                          ),
                      const SizedBox(
                        height: 30,
                      ),

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: Center(
                              child: TextButton(
                                  onPressed: () {
                                    controller.login();
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),),

                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
