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

  String country = "N/A", city = "N/A", earthStateLocation = "N/A";
  String dateOfData = "";

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
        elevation: 3,
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
              const SizedBox(
                height: 8,
              ),
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
                                  "No information found for this location 😓";
                              city = "N/A";
                              earthStateLocation = "N/A";
                              country = "N/A";
                              dateOfData = "";
                              setState(() {});
                            } else {
                              schedule = data["items"][0];
                              waqthNameList = schedule.keys.toList();
                              city = data["city"];
                              if (city.isEmpty) {
                                city = "N/A";
                              }
                              earthStateLocation = data["state"];
                              if (earthStateLocation.isEmpty) {
                                earthStateLocation = "N/A";
                              }
                              country = data["country"];
                              if (country.isEmpty) {
                                country = "N/A";
                              }
                              dateOfData =
                                  schedule[waqthNameList[0]].toString();
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
              const SizedBox(
                height: 3,
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Country : $country",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text("City : $city",
                          style: const TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text("State : $earthStateLocation",
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              (dateOfData.isNotEmpty)
                  ? Center(
                      child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text(
                            "Showing result for ${dateOfData}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          )),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 3,
              ),
              (waqthNameList.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: waqthNameList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox.shrink();
                        }
                        return Card(
                          elevation: 3,
                          color: Colors.green.shade400,
                          child: ListTile(
                            title: Text(
                              waqthNameList[index].toString().toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            trailing: Text(
                              schedule[waqthNameList[index]].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
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
