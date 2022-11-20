import 'dart:ui';
import 'package:ambulance_tracker/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      // backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          children: [
            GetBuilder<SettingController>(
                autoRemove: false,
                init: SettingController(),
                builder: (logic) {
                  return logic.loading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: data.padding.left * 2,
                                right: data.padding.right * 2,
                                top: data.padding.top * 2,
                              ),
                              // decoration: BoxDecoration(
                              //   color: Colors.grey[500]!.withOpacity(0.5),
                              //   borderRadius: BorderRadius.circular(16),
                              // ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                        'Name : ' + logic.userName.value,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.black),
                                      onPressed: () {
                                        logic.changeName();
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Email : ${logic.user_email}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.black),
                                      onPressed: () {
                                        logic.changeEmail();
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('Password',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.black),
                                      onPressed: () {
                                        logic.changePassword();
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        'Phone Number: ${logic.number.value}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.edit_sharp,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        logic.changePhone();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                }),
          ],
        ),
      ),
    );
  }
}
