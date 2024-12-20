import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/auth/login_screen.dart';
import 'package:todo/tabs/auth/user_provider.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app_theme.dart';
import 'language.dart';

class SettingsTab extends StatefulWidget{
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  List<Language> languages = [
    Language(name: 'English', code: 'en'),
    Language(name: 'العربية', code: 'ar'),
  ];
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        AppLocalizations.of(context)!.exit,
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
                        icon:  Icon(
                            Icons.logout,
                            size: 28,
                          color: Provider.of<SettingsProvider>(context, listen: false).isDark ? AppTheme.white : AppTheme.black,
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.themedark,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Switch(value: settingsProvider.isDark,
                      activeColor: AppTheme.primary,
                      onChanged: (value) => settingsProvider.changeTheme(value ? ThemeMode.dark : ThemeMode.light),),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.langs,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    DropdownButtonHideUnderline(child:
                    DropdownButton<Language>(
                      value: languages.firstWhere((language)
                      => language.code == SettingsProvider.languageCode),
                      items: languages.map(
                            (language) => DropdownMenuItem(
                          child: Text(language.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          value: language,),
                      ).toList(),
                      onChanged: (selectedLanguage){
                        if(selectedLanguage != null){
                          settingsProvider.changeLanguage(selectedLanguage.code);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: settingsProvider.isDark ? AppTheme.primary : AppTheme.white,

                    ),

                    ),
                  ],
                ),
              ],
            ),
        )
    );
  }
}