import 'package:chat_app/screens/group_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  // TextEditingController passController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Chat',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 3),
                  width: 100,
                  height: 40,
                  color: Colors.green,
                  child: const Text(
                    'Mate',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white,),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a valid name';
                      } else if (value.length < 4) {
                        return 'please write a name with more than 3 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'please provide a name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TextFormField(
                  //   controller: passController,
                  //   validator: (value) {
                  //     if (value!.isEmpty || value.length < 4) {
                  //       return 'Please provide valid password';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                String name = nameController.text;

                if (formKey.currentState!.validate()) {
                  nameController.clear();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupPage(name: name),
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green,
                ),
                child: const Center(
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
