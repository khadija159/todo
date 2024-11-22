import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/auth/login_screen.dart';
import 'package:todo/tabs/auth/user_provider.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class SettingsTab extends StatelessWidget{
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Logout',
                        style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                        onPressed: (){
                          FirebaseFunctions.logout();
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                          Provider.of<TasksProvider>(context, listen: false)
                              .resetData();
                          Provider.of<UserProvider>(context, listen: false).updateUser(null);
                        },
                        icon: const Icon(
                            Icons.logout,
                            size: 28,
                        )
                    ),
                  ],
                ),
              ],
            ),
        )
    );
  }
}