import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointtrackernew/data/dbhelper.dart';
import 'package:pointtrackernew/model/character.dart';
import 'package:pointtrackernew/utils/util.dart';

class UpdateScore extends StatefulWidget {

  final List<Character> characterList;
  UpdateScore(this.characterList);
  @override
  _UpdateScoreState createState() => _UpdateScoreState(this.characterList);
}

class _UpdateScoreState extends State<UpdateScore> {
  DbHelper helper = DbHelper();
  List<Character> characterList;
  String selectedCharacterName;
  int points;

  _UpdateScoreState(this.characterList);

  Character editCharacterPoints(String name, int points) {
    final tile =
    characterList.firstWhere((element) => element.name == name, orElse: null);
    if (tile != null) tile.points += points;

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
          child: Text(charName),
          value: charName,
        );
        dropdownItems.add(newItem);
      }
    } catch (e) {
      print(e);
    }
    return DropdownButton<String>(
      value: selectedCharacterName,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCharacterName = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
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
                          Text(
                            "Name:",
                            style: TextStyle(
                                color: Color(0xff787878),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            child: characterList.isNotEmpty
                                ? dropdown()
                                : null,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Point(s)to add",
                        style: TextStyle(
                            color: Color(0xff787878),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                        cursorColor: Colors.teal,
                        decoration: kInputDecoration.copyWith(
                            hintText: "Points toadd to existing points"),
                        autovalidate: false,
                        keyboardType: TextInputType.number,
                        validator: (input) {
                          final isDigitsOnly = int.tryParse(input);
                          return isDigitsOnly == null
                              ? 'Input needs to be digits only'
                              : null;
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          points = int.parse(value);
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: ButtonTheme(
                          minWidth: 350.0,
                          height: 50.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: RaisedButton(
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                              Character char = editCharacterPoints(selectedCharacterName, points);
                                _add(char);
                              });
                            },
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            color: Colors.teal,
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
    if(result != 0){
    } else {
    }
  }
}
