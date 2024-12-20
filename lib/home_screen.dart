import 'package:flutter/material.dart';
import 'package:todo/tabs/tasks/add_task_bottom_sheet.dart';
import 'app_theme.dart';
import 'tabs/tasks/tasks_tab.dart';
import 'tabs/settings/settings_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget{
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<Widget> tabs = [
    const TasksTab(),
    const SettingsTab(),
  ];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: EdgeInsets.zero,
        color: AppTheme.white,
        child: BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (index) => setState(() => currentTabIndex = index),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.tasknav,
                  icon: const Icon(
                    Icons.list,
                    size: 32,)
              ),
               BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.set,
                  icon: Icon(
                    Icons.settings,
                    size: 32,)
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => const AddTaskBottomSheet(), ),
          child: const Icon(
              Icons.add,
              size: 32,
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}