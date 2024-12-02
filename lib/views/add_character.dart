import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:point_tracker/data/dbhelper.dart';
import 'package:point_tracker/model/character.dart';
import 'package:point_tracker/utils/util.dart';

class AddContestant extends StatefulWidget {
  final List<Character> characterList;
  const AddContestant(this.characterList, {Key? key}) : super(key: key);
  @override
  State<AddContestant> createState() => _AddContestantState();
}

class _AddContestantState extends State<AddContestant> {
  DbHelper helper = DbHelper();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int points = 0;
  String newContestants = "";

  List<Character> characterList = [];

  @override
  void initState() {
    super.initState();
    characterList = widget.characterList;
  }

  List<String> get getCharNames {
    List<String> charNames = [];
    for (Character char in characterList) {
      String charName = char.name;
      charNames.add(charName);
    }
    return charNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
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
              "Add New Contestant",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Name:",
                        style: TextStyle(
                            color: Color(0xff787878),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        validator: (input) {
                          if (getCharNames.contains(input)) {
                            return "Name already exists";
                          } else {
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
                        style: const TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text(
                        "Starting Point(s):",
                        style: TextStyle(
                            color: Color(0xff787878),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.teal,
                        ),
                        cursorColor: Colors.teal,
                        decoration: kInputDecoration.copyWith(
                            hintText: "Starting point e.g 100"),
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
                          setState(() {
                            points = int.parse(value);
                          });
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
                              //add new character to list
                              setState(() {
                                if (formKey.currentState!.validate()) {
                                  _save(Character(
                                      name: newContestants, points: points));
                                }
                              });
                            },
                            child: const Text(
                              "ADD",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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

  void _save(Character character) async {
    Navigator.pop(context, true);
    int result = await helper.insertCharacter(character);
    if (result != 0) {
    } else {}
  }
}
