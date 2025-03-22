import 'package:flutter/material.dart';
import 'package:genhealth/models/user_data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class UserDataView extends StatelessWidget {
  const UserDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Data Viewer')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<UserData>('userBox').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final user = box.getAt(index) as UserData;
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text('Email: ${user.email}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => box.deleteAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}