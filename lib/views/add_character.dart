import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointtrackernew/data/dbhelper.dart';
import 'package:pointtrackernew/model/character.dart';
import 'package:pointtrackernew/utils/util.dart';

class AddContestant extends StatefulWidget {
  final List<Character> characterList;
  AddContestant(this.characterList);
  @override
  _AddContestantState createState() => _AddContestantState(this.characterList);
}

class _AddContestantState extends State<AddContestant> {
  DbHelper helper = DbHelper();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int points;
  String newContestants;

  var characterList;


  List<String> get getCharNames {
    List<String> charNames = [];
    for (Character char in characterList) {
      String charName = char.name;
      charNames.add(charName);
    }
    return charNames;
  }
  _AddContestantState(this.characterList);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
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
              "Add New Contestant",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0
              ),
              textAlign: TextAlign.center,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name:", style: TextStyle(
                          color: Color(0xff787878),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500
                      ),),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        validator: (input) {
                          if(getCharNames.contains(input)){
                            return "Name already exists";
                          }
                          else {
                            return null;
                          }
                        },
                        cursorColor: Colors.teal,
                        onChanged: (value) {
                          setState(() {
                            newContestants = value;
                          });
                        },
                        decoration: kInputDecoration.copyWith(
                            hintText: "Name of Contestants"),
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 15.0,),
                      Text("Starting Point(s):", style: TextStyle(
                          color: Color(0xff787878),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500
                      ),),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                        cursorColor: Colors.teal,
                        decoration: kInputDecoration.copyWith(
                            hintText: "Starting point e.g 100"),
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
                          setState(() {
                            points = int.parse(value);
                          });
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
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: RaisedButton(
                            textColor: Colors.white,
                            onPressed: () {
                              //add new character to list
                             setState(() {
                               if(formKey.currentState.validate()){
                                 _save(Character(
                                     newContestants, points
                                 ));
                               }
                             });
                            },
                            child: Text("ADD", style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),),
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
  void _save(Character character) async {
    Navigator.pop(context, true);
    int result = await helper.insertCharacter(character);
    if(result != 0){} else {}
  }
}
