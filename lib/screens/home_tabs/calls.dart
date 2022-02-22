import 'package:flutter/material.dart';

class Calls extends StatelessWidget {
  const Calls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Container(
              child: const Icon(
                Icons.account_circle,
                size: 50.0,
              ),
            ),
            title: const Text(
              "Name",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.call_received,
                    size: 14.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Text(
                  "3 January, 21:55",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.call,
              color: Theme.of(context).primaryColor,
            ),
          );
        });
  }
}
