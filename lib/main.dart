import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Model/UserMaster.dart';
import 'dart:convert';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  static const String pageTitle = "Login Page";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: pageTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(pageTitle)),
        body: const MyLoginPage(title: '',),
      ),
    );
  }
  
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  String username = "";
  String password = "";

  void setCredentials() {
    setState(() {
      username = userNameController.text;
      password = passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'WIT DEMO LOGIN APP',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    print(userNameController.text);
                    print(passwordController.text);

                    if(userNameController.text == "100") {
                      print("INSIDE IF LOGICAL CHECK");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage(userNameController.text)),
                        );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar( content: Text("Invalid credentials"),));
                    }
                  },
                )
            ),
          ],
        ));
  }
}

class Homepage extends StatelessWidget {

  String user;
  Homepage(this.user);

  String greetingText() {
    var dt = DateTime.now();
    if(dt.hour > 4 && dt.hour < 12) {
      return "Good Morning $user";
    } else if(dt.hour > 11 && dt.hour < 17) {
      return "Good Afternoon $user" ;
    }
    return "Good Evening $user";
  }

  List? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(greetingText()),
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
          child: Center(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            child: FutureBuilder(
                future: DefaultAssetBundle
                    .of(context)
                    .loadString('lib/assets/drinks.json'),
                builder: (context, snapshot) {
                  // Decode the JSON
                  var json_data = json.decode(snapshot.data.toString());
                  print(json_data);
                  var new_data = json_data['drinks'];
                  print(new_data);
                  return ListView.builder(
                    // Build the ListView
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Id: " + new_data[index]['idDrink']),
                            Text("Drink: " + new_data[index]['strDrink']),
                            Text("Category: " + new_data[index]['strCategory'])
                          ],
                        ),
                      );
                    },
                    itemCount: new_data == null ? 0 : new_data.length,
                  );
                }),
          ),
        ));
  }
}

class dbHelper {

  Future<Database> initializeDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'application_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE UserMaster(id INTEGER PRIMARY KEY, username TEXT, password TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

    Future<List<UserMaster>> users() async {
      final Database db = await initializeDB();

      final List<Map<String, dynamic>> maps = await db.query('UserMaster');

      return List.generate(maps.length, (i) {
        return UserMaster(
            maps[i]['id'], maps[i]['username'], maps[i]['password']);
      });
    }

    Future<UserMaster> findUserByUserName(String username) async {
      final Database db = await initializeDB();
      var res = await db.rawQuery(
          "SELECT * FROM UserMaster WHERE username = '" + username + "'");

      if (res.length > 0) {
        return UserMaster.fromMap(res.first);
      }

      return UserMaster(0, "error", "error");
    }

    Future<void> insertUser(UserMaster userMaster) async {
      // Get a reference to the database.
      final Database db = await initializeDB();

      await db.insert(
        'UserMaster',
        userMaster.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> updateUser(UserMaster userMaster) async {
      final db = await initializeDB();
      await db.update(
        'UserMaster',
        userMaster.toMap(),
        where: "id = ?",
        whereArgs: [userMaster.id],
      );
    }

    Future<void> deleteUser(int id) async {
      final db = await initializeDB();
      await db.delete(
        'UserMaster',
        where: "id = ?",
        whereArgs: [id],
      );
    }
}
