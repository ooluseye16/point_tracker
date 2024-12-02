import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:point_tracker/data/dbhelper.dart';
import 'package:point_tracker/model/character.dart';
import 'package:point_tracker/utils/util.dart';

class UpdateScore extends StatefulWidget {
  final List<Character> characterList;
  const UpdateScore(this.characterList, {Key? key}) : super(key: key);
  @override
  State<UpdateScore> createState() => _UpdateScoreState();
}

class _UpdateScoreState extends State<UpdateScore> {
  DbHelper helper = DbHelper();
  List<Character> characterList = [];
  String selectedCharacterName = "";
  int points = 0;

  @override
  void initState() {
    super.initState();
    characterList = widget.characterList;
    if (characterList.isNotEmpty) {
      selectedCharacterName = characterList[0].name;
    }
  }

  Character editCharacterPoints(String name, int points) {
    final tile = characterList.firstWhere((element) => element.name == name);
    tile.points += points;

    return tile;
  }

  List<String> get getCharNames {
    List<String> charNames = [];
    for (Character char in characterList) {
      String charName = char.name;
      charNames.add(charName);
    }
    return charNames;
  }

  DropdownButton dropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    try {
      for (String charName in getCharNames) {
        var newItem = DropdownMenuItem(
          value: charName,
          child: Text(charName),
        );
        dropdownItems.add(newItem);
      }
    } catch (e) {
      log(e.toString());
    }
    return DropdownButton<String>(
      value: selectedCharacterName,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCharacterName = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Add Score",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Name:",
                            style: TextStyle(
                                color: Color(0xff787878),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            child: characterList.isNotEmpty ? dropdown() : null,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text(
                        "Point(s)to add",
                        style: TextStyle(
                            color: Color(0xff787878),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        style: const TextStyle(
                          color: Colors.teal,
                        ),
                        cursorColor: Colors.teal,
                        decoration: kInputDecoration.copyWith(
                            hintText: "Points toadd to existing points"),
                        keyboardType: TextInputType.number,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Input cannot be empty';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          points = int.parse(value);
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: ButtonTheme(
                          minWidth: 350.0,
                          height: 50.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            onPressed: () {
                              setState(() {
                                Character char = editCharacterPoints(
                                    selectedCharacterName, points);
                                _add(char);
                              });
                            },
                            child: const Text(
                              "ADD",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _add(Character character) async {
    Navigator.pop(context, true);
    int result = await helper.updateCharacter(character);
    if (result != 0) {
    } else {}
  }
}
