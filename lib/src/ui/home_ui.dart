import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/src/controller/home_controller.dart';
import 'package:interview/src/utils/routes/app_routes.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        actions: [
          Obx(() => Visibility(
              visible: !homeController.multiSelect.value,
              child: TextButton(
                  onPressed: () {
                    homeController.getSavedContacts();
                    Get.toNamed(AppRoutes.savedContacts);
                  },
                  child: const Text(
                    "Saved Contacts",
                    style: TextStyle(color: Colors.white),
                  )))),
          Obx(() => Visibility(
              visible: homeController.multiSelect.value,
              child: TextButton(
                  onPressed: () {
                    homeController.hiveStorage();
                  },
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                  )))),
          Obx(() => Visibility(
              visible: homeController.multiSelect.value,
              child: TextButton(
                  onPressed: () {
                    homeController.selectedId = [];
                    homeController.multiSelect.value = false;
                    homeController.update();
                  },
                  child: const Text(
                    "Remove Selected",
                    style: TextStyle(color: Colors.white),
                  )))),
        ],
      ),
      body: GetBuilder(
        init: homeController,
        builder: (HomeController controller) {
          return _contactList(controller);
        },
      ),
    );
  }

  Widget _contactList(HomeController homeController) {
    if (!homeController.permission.value) {
      return const Center(child: Text('Permission denied'));
    }
    if (homeController.contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: homeController.contacts!.length,
        itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                onTap: () {
                  homeController.onTap(homeController.contacts![i].id);
                },
                onLongPress: () {
                  homeController
                      .longPressFunction(homeController.contacts![i].id);
                },
                title: Text(homeController.contacts![i].displayName),
                trailing: Icon(
                  Icons.check,
                  color: homeController.selectedId
                          .contains(homeController.contacts![i].id)
                      ? Colors.blue.shade400
                      : Colors.transparent,
                ),
                leading: homeController.contacts![i].photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.memory(
                          homeController.contacts![i].photo!,
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
                            homeController.contacts![i].displayName[0]
                                .toUpperCase(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
              ),
            ));
  }
}
