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
            return ListTile(
              title: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // title: Text("Hehe"),
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
                        );
                      },
                    );
                  },
                  child: Text(searchHistoryList[index][0].name),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
