import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import '../modal/contact_hive.dart';

class HomeController extends GetxController {
  RxBool permission = true.obs;
  List<Contact>? contacts;
  RxBool multiSelect = false.obs;
  List<String> selectedId = [];
  List<ContactHive> SavedContacts = [];

  @override
  void onInit() {
    getContact();
    super.onInit();
  }

  void hiveStorage() async {
    Box box = await Hive.openBox('contacts_sa');

    List<Contact> contactForStorage =
        contacts!.where((element) => selectedId.contains(element.id)).toList();

    if (contactForStorage.isNotEmpty) {
      contactForStorage.forEach((element) {

        List<int> data = [];
        if(element.photo != null)  element.photo!.forEach((element) {data.add(element);});
        box.put(
            element.id,
            ContactHive(
                id: element.id,
                name: element.displayName,
                image: element.photo == null ? "" :  String.fromCharCodes(data),
            phone: element.phones[0].number));
        data= [];
      });

      selectedId = [];
      multiSelect.value = false;
      update();
    }

    box.close();
  }

  void sendSMSToSavedList() async {

    List<String> recipients = SavedContacts.map((e) => e.phone).toList();
    print(recipients);
    if (await Permission.sms.request().isGranted) {
      String _result = await sendSMS(
              message: "Testing",
              recipients:recipients,
              sendDirect: true)
          .catchError((onError) {
        print(onError);
      });
      print(_result);
    } else {
      openAppSettings();
    }
  }

  void messanger(BuildContext context) async{
    print("object");
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute ),
    );
    var uniqueId = DateTime.now().toString();
    sendSMSToSavedList();

   await Workmanager().registerOneOffTask(uniqueId, "messanger", initialDelay: Duration(seconds: 5)
    );
  }

  void getSavedContacts() async{

    Box box = await Hive.openBox('contacts_sa');
    box.values.map((e) => SavedContacts.add(ContactHive(id: e.id, name: e.name, image: e.image , phone: e.phone)));
  List<ContactHive> data = [...box.values];
  data.forEach((element) {print(element.image  + "name  "+element.name);

  });
  SavedContacts = data;

  update();
   }
  void longPressFunction(String id) {
    if (!multiSelect.value) {
      multiSelect.value = true;
      selectedId.add(id);
    } else {
      selectedIdListUpdate(id);
    }
    update();
  }

  void onTap(String id) {
    if (multiSelect.value) {
      selectedIdListUpdate(id);
    }
    update();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print("contact  ${contacts![0]}");
    } else {
      permission.value = false;
    }
    update();
  }

  void selectedIdListUpdate(String id) {
    if (selectedId.contains(id)) {
      selectedId.remove(id);
      if (selectedId.isEmpty) {
        multiSelect.value = false;
      }
    } else {
      selectedId.add(id);
    }
  }
}
