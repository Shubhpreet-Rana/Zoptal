import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/src/controller/home_controller.dart';
import 'package:workmanager/workmanager.dart';

class SavedContacts extends StatelessWidget {
  const SavedContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Contacts"),
          actions: [
            TextButton(
                onPressed: () async{
                 homeController.messanger(context);
                },
                child: const Text(
                  "Timer",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: GetBuilder(
            init: homeController,
            builder: (HomeController controller) {
              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return ListTile(
                    title: Text(homeController.SavedContacts[i].name),
                    leading: homeController.SavedContacts[i].image != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.memory(
                              Uint8List.fromList(homeController
                                  .SavedContacts[i].image.codeUnits),
                              height: 50,
                              width: 50,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              color: Colors.blue.shade400.withOpacity(.6),
                              child: Text(
                                homeController.SavedContacts![i].name[0]
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                  );
                },
                itemCount: homeController.SavedContacts.length,
              );
            }));
  }
}
