import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:pointtrackernew/data/dbhelper.dart';
import 'package:pointtrackernew/model/character.dart';
import 'package:pointtrackernew/views/update_score.dart';
import 'package:sqflite/sqflite.dart';

import 'add_character.dart';

class CharacterList extends StatefulWidget {
  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  DbHelper dbHelper = DbHelper();
  List<Character> characterList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (characterList == null) {
      characterList = List<Character>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "LeaderBoard",
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
          : Center(
              child: Text("Tap the button below to add contestants"),
            ),
      floatingActionButton: FabCircularMenu(
        fabOpenIcon: Icon(
          Icons.menu,
          color: Colors.teal,
        ),
        fabCloseIcon: Icon(
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
              icon: Icon(
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
              icon: Icon(
                Icons.add,
                color: Colors.teal,
              ),
              onPressed: () async {
                if (characterList.length < 2) {
                  return showDialog<void>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
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
          this.characterList = charList;
          this.count = charList.length;
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
            backgroundColor = Color(0xffffd700);
          } else if (index == 1) {
            backgroundColor = Color(0xffc0c0c0);
          } else if (index == 2) {
            backgroundColor = Color(0xffcd7f32);
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
              padding: EdgeInsets.only(right: 20.0),
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white,),
              color: Colors.red,
            ),
            child: Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: backgroundColor,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(characterList[index].name),
                trailing: Text(
                  "${characterList[index].points} point(s)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        });
  }

  void _delete(BuildContext context, Character character) async {
    int result = await dbHelper.deleteCharacter(character.id);
    if (result != 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          onPressed: () async{
         
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
