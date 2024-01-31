import 'package:flutter/material.dart';

import '../schedule_element_struct.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({
    super.key,
    required this.searchHistoryList,
  });

  final List<List<ScheduleElementStruct>> searchHistoryList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        title: const Text(
          "Search History",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          primary: false,
          itemCount: searchHistoryList.length,
          itemBuilder: (context, index) {
            return Visibility(
              visible: (searchHistoryList[index].isNotEmpty &&
                  searchHistoryList[index][0].name.isNotEmpty),
              child: ListTile(
                title: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 1.2,
                              child: ListView.builder(
                                itemCount: searchHistoryList[index].length,
                                itemBuilder: (context, indexTwo) => ListTile(
                                  title: Text(
                                      searchHistoryList[index][indexTwo].name),
                                  subtitle: Text(
                                      searchHistoryList[index][indexTwo].time),
                                ),
                              ),
                            ),
                            actions: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.red.shade400),
                                    foregroundColor: const MaterialStatePropertyAll(
                                      Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Close",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: (searchHistoryList[index].isNotEmpty &&
                            searchHistoryList[index][0].name.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: searchHistoryList[index][0].name,
                                  ),
                                  const TextSpan(text: "\n"),
                                  TextSpan(
                                    text: searchHistoryList[index][0].time,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Spacer(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
