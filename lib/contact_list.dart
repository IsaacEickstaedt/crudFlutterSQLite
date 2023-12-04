import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_crud/mydrawal.dart';

import 'colors.dart';
import 'db_manager.dart';
import 'package:path_provider/path_provider.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allCategoryData = [];

  @override
  void initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawal(),
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          title: Text("contact list"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text(""),
            Expanded(
              child: ListView.builder(
                itemCount: allCategoryData.length,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  var item = allCategoryData[index];
                  return Container(
                    color: MyColors.orangeTile,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text("${item['name']} "),
                            Text("${item['lname']} "),
                            Spacer(),
                            IconButton(
                              onPressed: null,
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _delete(item['id']);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                        const Divider(
                          color: MyColors.orangeDivider,
                          thickness: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRowsofContact();
    print('query all rows:');
    allRows.forEach(print);
    allCategoryData = allRows;
    setState(() {});
  }

  void _delete(int id) async {
    final rowsDeleted = await dbHelper.deleteContact(id);
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }
}
