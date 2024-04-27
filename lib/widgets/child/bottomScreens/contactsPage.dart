import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Utils/constants.dart';
import '../../../db/db_services.dart';
import '../../../db/model/contacts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  filterContact() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      contactsFiltered = contacts.where((contact) {
        String contactName = contact.displayName?.toLowerCase() ?? "";
        return contactName.contains(searchTerm);
      }).toList();
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handInvaliedPermissions(permissionStatus);
    }
  }

  handInvaliedPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "May contact does exist in this device");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  getAllContacts() async {
    List<Contact> _contacts =
    await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExists = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
      body: contacts.length == 0
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search contact",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            listItemExists
                ? Expanded(
              child: ListView.builder(
                itemCount: isSearching
                    ? contactsFiltered.length
                    : contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = isSearching
                      ? contactsFiltered[index]
                      : contacts[index];
                  return ListTile(
                    title: Text(contact.displayName ?? ""),
                    leading: contact.avatar != null &&
                        contact.avatar!.length > 0
                        ? CircleAvatar(
                      backgroundColor: kColorRed,
                      backgroundImage:
                      MemoryImage(contact.avatar!),
                    )
                        : CircleAvatar(
                      backgroundColor: kColorRed,
                      child: Text(contact.initials()),
                    ),
                    onTap: () {
                      if (contact.phones!.length > 0) {
                        final String phoneNumber =
                        contact.phones!.elementAt(0).value!;
                        final String name =
                            contact.displayName ?? "";
                        _addContact(TContact(phoneNumber, name));
                      } else {
                        Fluttertoast.showToast(
                          msg:
                          "Oops! Phone number of this contact does not exist",
                        );
                      }
                    },
                  );
                },
              ),
            )
                : Container(
              child: Text("No contacts found"),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}
