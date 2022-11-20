import 'package:ambulance_tracker/Components/custom_textfield.dart';
import 'package:ambulance_tracker/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:ambulance_tracker/constants.dart';
import 'package:ambulance_tracker/screens/Login/login_screen.dart';
import 'package:ambulance_tracker/Components/already_have_an_account_acheck.dart';
import 'package:ambulance_tracker/Components/rounded_button.dart';
import 'package:ambulance_tracker/Components/rounded_input_field.dart';
import 'package:ambulance_tracker/Components/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey2,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                SizedBox(
                  child: Image.asset(
                    "assets/images/hands.png",
                    width: size.width * 0.7,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: controller.name,
                  validator: (validator) {
                    return controller.validate(validator!);
                  },
                  lable: 'Name',
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  input: TextInputType.text,
                  bol: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    bol: false,
                    controller: controller.email,
                    validator: (validator) {
                      return controller.validateEmail(validator!);
                    },
                    lable: 'Email',
                    icon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    input: TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    bol: false,
                    controller: controller.number,
                    validator: (validator) {
                      return controller.validateNumber(validator!);
                    },
                    lable: 'Phone Number',
                    icon: const Icon(
                      Icons.call,
                      color: Colors.black,
                    ),
                    input: TextInputType.number),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    bol: true,
                    controller: controller.password,
                    validator: (validator) {
                      return controller.validatePassword(validator!);
                    },
                    lable: 'Password',
                    icon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    input: TextInputType.number),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    bol: true,
                    controller: controller.repassword,
                    validator: (validator) {
                      return controller.validateRePassword(validator!);
                    },
                    lable: 'Re Type Password',
                    icon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    input: TextInputType.number),
                const SizedBox(
                  height: 15,
                ),
                RoundedButton(
                  text: "SIGNUP",
                  press: () {
                    controller.register();
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        // Here i can use size.width but use double.infinity because both work as a same
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.25,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
