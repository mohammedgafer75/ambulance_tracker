import 'package:ambulance_tracker/Components/custom_button.dart';
import 'package:ambulance_tracker/Components/loading.dart';
import 'package:ambulance_tracker/Components/snackbar.dart';
import 'package:ambulance_tracker/controller/report_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Request'),
      ),
      body: GetX<ReportController>(
        autoRemove: false,
        builder: (logic) {
          return SizedBox(
            height: data.size.height,
            width: data.size.width,
            child: Stack(children: [
              logic.reports.isEmpty
                  ? const Center(
                      child: Text('no data founded'),
                    )
                  : ListView.builder(
                      itemCount: logic.reports.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('${logic.reports[index].name}'),
                                  leading: CircleAvatar(
                                    child: Text('${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    backgroundColor: Colors.blueAccent,
                                  ),

                                  // trailing: Row(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   children: [
                                  //     // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                                  //     IconButton(
                                  //       onPressed: () {
                                  //         // logic.deleteCustomer(
                                  //         //     logic.users[index].id!);
                                  //       },
                                  //       icon: const Icon(Icons.delete),
                                  //       color: Colors.red,
                                  //     ),
                                  //   ],
                                  // ),
                                ),
                                Text(
                                    'description:  ${logic.reports[index].status}',
                                    style: const TextStyle(fontSize: 16)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'status:  ${logic.reports[index].approve}',
                                      style: const TextStyle(fontSize: 16)),
                                ),
                                logic.reports[index].approve == 'waiting'
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'accept by:  ${logic.reports[index].by} ',
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'phone number:  ${logic.reports[index].driverNumber} ',
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomTextButton(
                                                    lable: 'Call',
                                                    ontap: () {
                                                      Uri tel = Uri(
                                                          scheme: 'tel',
                                                          path:
                                                              '${logic.reports[index].driverNumber}');
                                                      launchUrl(tel);
                                                    },
                                                    color: Colors.indigo),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CustomTextButton(
                                                      lable: 'Done',
                                                      ontap: () async {
                                                        showdilog();
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'reports')
                                                              .doc(logic
                                                                  .reports[
                                                                      index]
                                                                  .id)
                                                              .update({
                                                            'approve': 'Done',
                                                          });

                                                          Get.back();
                                                          showbar(
                                                              'Done request',
                                                              'subtitle',
                                                              'Done',
                                                              true);
                                                        } catch (e) {
                                                          Get.back();
                                                          showbar(
                                                              'Done request',
                                                              'subtitle',
                                                              e.toString(),
                                                              false);
                                                        }
                                                      },
                                                      color: Colors.indigo),
                                                )
                                              ]),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomTextButton(
                                                    lable: 'Cancel',
                                                    ontap: () async {
                                                      showdilog();
                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'reports')
                                                            .doc(logic
                                                                .reports[index]
                                                                .id)
                                                            .update({
                                                          'approve': 'cancel',
                                                        });

                                                        Get.back();
                                                        showbar(
                                                            'cancel request',
                                                            'subtitle',
                                                            'Canceled',
                                                            true);
                                                      } catch (e) {
                                                        Get.back();
                                                        showbar(
                                                            'cancel request',
                                                            'subtitle',
                                                            e.toString(),
                                                            false);
                                                      }
                                                    },
                                                    color: Colors.indigo),
                                              ),
                                              logic.reports[index].approve ==
                                                      'accept'
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: CustomTextButton(
                                                          lable: 'Delete',
                                                          ontap: () async {
                                                            logic.deleteReports(
                                                                logic
                                                                    .reports[
                                                                        index]
                                                                    .id!);
                                                          },
                                                          color: Colors.indigo),
                                                    ),
                                            ],
                                          )
                                        ],
                                      )
                              ],
                            ));
                      },
                    ),
            ]),
          );
        },
      ),
    );
  }
}
