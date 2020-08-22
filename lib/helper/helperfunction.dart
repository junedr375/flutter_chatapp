import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

class HelperFunction {
	static String sharedPreferencesLoggedInKey = "ISLOGGEDIN";
	static String sharedPreferencesUserNameKey = "USERNAMEKEY";
	static String sharedPreferencesUserEmailKey = "USEREMAILKEY";

/////////////   saving the data
	static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return await prefs.setBool(sharedPreferencesLoggedInKey,isUserLoggedIn);
	}

	static Future<bool> saveUserNameSharedPreference(String userName) async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return await prefs.setString(sharedPreferencesUserNameKey,userName);
	}

	static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return await prefs.setString(sharedPreferencesUserEmailKey,userEmail);
	}


//////////   Getting the data

	static Future<bool> getUserLoggedInSharedPreference() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return await prefs.getBool(sharedPreferencesLoggedInKey);
	}

	static Future<String> getUserNameSharedPreference() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return await prefs.getString(sharedPreferencesUserNameKey);
	}

	static Future<String> getUserEmailSharedPreference() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return await prefs.getString(sharedPreferencesUserEmailKey);
	}


}
