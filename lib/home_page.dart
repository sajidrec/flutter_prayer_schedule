import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prayer_time/request_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _globalSearchKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerSearch =
      TextEditingController();

  Map<String, dynamic> schedule = {};
  List<String> waqthNameList = [];

  String screenMsg = "Nothing to show here";

  @override
  void dispose() {
    _textEditingControllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prayer Time",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _globalSearchKey,
                child: TextFormField(
                  maxLength: 25,
                  validator: (value) {
                    String v = value.toString().trim();
                    if (v.isEmpty) {
                      return "Enter something";
                    }
                    return null;
                  },
                  controller: _textEditingControllerSearch,
                  decoration: InputDecoration(
                    hintText: "Dhaka",
                    contentPadding: const EdgeInsets.only(
                        left: 18, top: 5, bottom: 6, right: 5),
                    labelText: "Enter Location",
                    suffix: IconButton(
                      icon: const Icon(Icons.search_rounded),
                      onPressed: () async {
                        if (_globalSearchKey.currentState!.validate()) {
                          String location = _textEditingControllerSearch.text
                              .toString()
                              .trim();
                          location.toLowerCase();

                          final res = await RequestHelper(location: location)
                              .makeRequest();

                          if (res.statusCode == 200) {
                            Map<String, dynamic> data = jsonDecode(res.body);
                            if (data["status_description"] != "Success.") {
                              waqthNameList = [];
                              screenMsg =
                                  "No information for this location found 😓";
                              setState(() {});
                            } else {
                              schedule = data["items"][0];
                              waqthNameList = schedule.keys.toList();
                              setState(() {});
                            }
                          } else {
                            screenMsg = "Something went wrong";
                            setState(() {});
                          }
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 6,
              // ),

              (waqthNameList.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: waqthNameList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox.shrink();
                        }
                        return ListTile(
                          title: Text(
                            waqthNameList[index].toString().toUpperCase(),
                          ),
                          trailing: Text(
                            schedule[waqthNameList[index]].toString(),
                          ),
                        );
                      },
                    )
                  : Text(
                      screenMsg,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
