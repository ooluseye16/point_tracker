import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:point_tracker/data/dbhelper.dart';
import 'package:point_tracker/model/character.dart';
import 'package:point_tracker/views/update_score.dart';
import 'package:sqflite/sqflite.dart';

import 'add_character.dart';

class CharacterList extends StatefulWidget {
  const CharacterList({Key? key}) : super(key: key);

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  DbHelper dbHelper = DbHelper();
  List<Character> characterList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Leaderboard",
          style: TextStyle(
              color: Colors.teal, fontWeight: FontWeight.w600, fontSize: 20.0),
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: characterList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: getTodoListView(),
            )
          : const Center(
              child: Text("Tap the button below to add contestants"),
            ),
      floatingActionButton: FabCircularMenuPlus(
        fabOpenIcon: const Icon(
          Icons.menu,
          color: Colors.teal,
        ),
        fabCloseIcon: const Icon(
          Icons.close,
          color: Colors.teal,
        ),
        fabSize: 50.0,
        fabColor: Colors.white,
        ringDiameter: 200.0,
        ringWidth: 50.0,
        ringColor: Colors.tealAccent.withOpacity(0.1),
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              tooltip: "Add new contestant",
              icon: const Icon(
                Icons.add_box,
                color: Colors.teal,
              ),
              onPressed: () async {
                bool result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddContestant(characterList),
                    ),
                  ),
                );
                if (result == true) {
                  setState(() {
                    updateListView();
                  });
                }
              },
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              tooltip: "Add score to existing contestant",
              icon: const Icon(
                Icons.add,
                color: Colors.teal,
              ),
              onPressed: () async {
                if (characterList.length < 2) {
                  return showDialog<void>(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Empty LeaderBoard"),
                          content: Text(
                            "The leaderBoard contains no contestant. Kindly add at least 2 contestant",
                            softWrap: true,
                          ),
                        );
                      });
                } else {
                  bool result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: UpdateScore(characterList),
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() {
                      updateListView();
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Character>> characterListFuture = dbHelper.getCharacterList();
      characterListFuture.then((charList) {
        setState(() {
          characterList = charList;
          count = charList.length;
        });
      });
    });
  }

  ListView getTodoListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          Color backgroundColor = Colors.teal;

          if (index == 0) {
            backgroundColor = const Color(0xffffd700);
          } else if (index == 1) {
            backgroundColor = const Color(0xffc0c0c0);
          } else if (index == 2) {
            backgroundColor = const Color(0xffcd7f32);
          }
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                _delete(context, characterList[index]);
              });
            },
            background: Container(),
            secondaryBackground: Container(
              padding: const EdgeInsets.only(right: 20.0),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: backgroundColor,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(characterList[index].name),
                trailing: Text(
                  "${characterList[index].points} point(s)",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        });
  }

  void _delete(BuildContext context, Character character) async {
    int result = await dbHelper.deleteCharacter(character.id!);
    if (result != 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          action: SnackBarAction(
            onPressed: () async {
              result = await dbHelper.insertCharacter(character);
              updateListView();
            },
            label: "UNDO",
            textColor: Colors.blue,
          ),
          content: Text("Contestant ${character.name} has been deleted!"),
        ));
        updateListView();
      }
    }
  }
}
