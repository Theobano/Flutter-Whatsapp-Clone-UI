import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final Future<List<Contact>> _contacts = ContactsService.getContacts(
    withThumbnails: false,
    orderByGivenName: true,
    photoHighResolution: false,
  );
  String noOfContacts = "";

  @override
  void initState() {
    super.initState();
    setNoOfContacts();
  }

  setNoOfContacts() async {
    List<Contact> dummyContacts = await _contacts;

    setState(() {
      noOfContacts = dummyContacts.length.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select contact",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
            Text(
              noOfContacts,
              // "${contacts.length} contacts",
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "New group",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  ContactsService.openContactForm();
                },
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "New contact",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.qr_code),
              ),
              FutureBuilder<List<Contact>>(
                  future: _contacts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Contact> contacts = snapshot.data!;

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (BuildContext context, int index) {
                          Contact contact = contacts[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.account_circle,
                              size: 50.0,
                            ),
                            title: Text(
                              contact.displayName.toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          )),
    );
  }
}
