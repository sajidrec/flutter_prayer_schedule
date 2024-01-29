import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayer_time/get_current_time_helper.dart';
import 'package:prayer_time/request_helper.dart';
import 'package:flag/flag.dart';

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
  List<String> waqtNameList = [];

  String countryCode = "N/A", city = "N/A", earthStateLocation = "N/A";
  String dateOfData = "";

  String _currentTime = "";

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
                              waqtNameList = [];
                              screenMsg =
                                  "No information found for this location 😓";
                              city = "N/A";
                              earthStateLocation = "N/A";
                              countryCode = "N/A";
                              dateOfData = "";
                              _currentTime = "";

                              setState(() {});
                            } else {
                              schedule = data["items"][0];
                              waqtNameList = schedule.keys.toList();

                              city = data["city"].toString().toUpperCase();
                              if (city.isEmpty) {
                                city = "N/A";
                              }
                              earthStateLocation =
                                  data["state"].toString().toUpperCase();
                              if (earthStateLocation.isEmpty) {
                                earthStateLocation = "N/A";
                              }
                              countryCode =
                                  data["country_code"].toString().toUpperCase();
                              if (countryCode.isEmpty) {
                                countryCode = "N/A";
                              }
                              dateOfData = schedule[waqtNameList[0]].toString();

                              final getTime = await getCurrentTime(
                                  latitude: data["latitude"].toString(),
                                  longitude: data["longitude"]);

                              _currentTime =
                                  jsonDecode(getTime.body)["dateTime"]
                                      .toString()
                                      .trim();

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
                      child: Wrap(
                        children: [
                          Text(
                            "Country : $countryCode",
                            style: const TextStyle(fontSize: 16),
                          ),
                          (countryCode != "N/A")
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Flag.fromCode(
                                    FlagsCode.values.byName(countryCode),
                                    // Use FlagsCode.values.byName to access the enum value
                                    height: 18,
                                    width: 18,
                                    fit: BoxFit.fill,
                                    flagSize: FlagSize.size_1x1,
                                    borderRadius: 25,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
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
              const SizedBox(
                height: 3,
              ),
              (waqtNameList.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: waqtNameList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox.shrink();
                        }
                        return Card(
                          elevation: 3,
                          color: Colors.green.shade400,
                          child: ListTile(
                            title: Text(
                              waqtNameList[index].toString().toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Wrap(
                              children: [
                                Text(
                                  schedule[waqtNameList[index]].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                const Icon(
                                  Icons.alarm_rounded,
                                  color: Colors.white,
                                ),
                              ],
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
              const SizedBox(
                height: 3,
              ),
              (dateOfData.isNotEmpty)
                  ? Center(
                      child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text(
                            "Showing result for $dateOfData",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    )
                  : const SizedBox.shrink(),
              (_currentTime.isNotEmpty)
                  ? Text(
                      "Local time in ${_textEditingControllerSearch.text.toString().trim().toUpperCase()} when data was fetched ${DateFormat.yMMMMEEEEd().add_jms().format(DateTime.parse(_currentTime))}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
