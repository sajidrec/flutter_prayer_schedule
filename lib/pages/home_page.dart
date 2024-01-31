import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayer_time/get_current_time_helper.dart';
import 'package:prayer_time/pages/about_app_page.dart';
import 'package:prayer_time/pages/search_history_page.dart';
import 'package:prayer_time/request_helper.dart';
import 'package:flag/flag.dart';
import '../exit_popup_msg.dart';
import '../schedule_element_struct.dart';

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

  List<List<ScheduleElementStruct>> searchHistoryList = [
    [],
  ];

  List<ScheduleElementStruct> waqtT = [];

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
        centerTitle: true,
        title: const Text(
          "Prayer Time",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            onPressed: () {
              exitPopupMsg(context);
            },
            icon: const Icon(Icons.exit_to_app_rounded),
          ),
        ],
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchHistoryPage(
                          searchHistoryList: searchHistoryList,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        color: Colors.green.shade400,
                        child: const Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Text(
                            "Search History",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutAppPage(),
                        ));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        color: Colors.green.shade400,
                        child: const Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Text(
                            "About",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    exitPopupMsg(context);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        color: Colors.green.shade400,
                        child: const Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Text(
                            "Exit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                          Wrap(
                            children: [
                              const Text(
                                "Country : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                countryCode,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
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
                      child: Wrap(children: [
                        const Text(
                          "City : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          city,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Wrap(
                        children: [
                          const Text(
                            "State : ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            earthStateLocation,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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
                          waqtT.add(
                            ScheduleElementStruct(
                                name: _textEditingControllerSearch.text
                                    .toString()
                                    .trim()
                                    .toUpperCase(),
                                time: dateOfData),
                          );
                          return const SizedBox.shrink();
                        }

                        waqtT.add(
                          ScheduleElementStruct(
                            name: waqtNameList[index].toString().toUpperCase(),
                            time: schedule[waqtNameList[index]].toString(),
                          ),
                        );

                        if (index + 1 == waqtNameList.length) {
                          searchHistoryList.insert(0, waqtT);
                          waqtT = [];
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
