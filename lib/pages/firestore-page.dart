import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth/model/operation-type.dart';
import 'package:flutter_firebase_auth/model/record.dart';
import 'package:flutter_firebase_auth/services/firestore-service.dart';

final dummySnapshot = [
  {'name': 'filip', 'votes': 15},
  {'name': 'fip', 'votes': 11},
  {'name': 'Wini', 'votes': 152},
  {'name': 'Sandy', 'votes': 11},
  {'name': 'Fel', 'votes': 167},
];

class FireStorePage extends StatefulWidget {
  final FirestoreService firestoreService = FirestoreService();
  @override
  _FireStorePageState createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireStorePage> {
  var _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _bottomSheetController;
  String babyName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore'),
      ),
      body: _buildBody(context, dummySnapshot),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _popUp(context, OpType.adding);
              /*_bottomSheetController = showBottomSheet(
                context: context,
                builder: (ctx) {
                  return Container(
//                    constraints: BoxConstraints.expand(height: 300.0, width: 20),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => babyName = value,
                            validator: (value) =>
                                value.isEmpty ? 'please enter a name' : null,
                            onEditingComplete: () {
                              _formKey.currentState.validate();
                            },
                            decoration: InputDecoration(
                              labelText: 'Baby name',
                            ),
                          ),
                          RaisedButton(
                            elevation: 8.0,
                            child: Text('Add'),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                String ref = await _addBabyName(babyName);

                                if (ref.isEmpty)
                                  _showSnackbar(ctx, 'Error adding name');
                                else {
                                  _showSnackbar(ctx, 'added name successfully');
                                  _closeBottomSheet();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );*/
            }),
      ),
    );
  }

  _buildBody(BuildContext context, List<Map> snapshot) {
    // Todo get actual data from firestore
    return StreamBuilder<QuerySnapshot>(
      stream: widget.firestoreService.getSnapshots('babynames'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return ListView(
          padding: EdgeInsets.all(16.0),
          children: snapshot.data.documents
              .map((data) => _buildListItem(context, data))
              .toList(),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          subtitle: Text('${record.votes.toString()} votes'),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              widget.firestoreService
                  .deleteRecord(record.reference)
                  .then((_) => _showSnackbar(context, 'deleted successfully'));
            },
          ),
          onTap: () {
            widget.firestoreService.updateSnapshot(record.reference);
          },
          onLongPress: () {
            _popUp(context, OpType.editing, record: record);
          },
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _popUp(BuildContext context, OpType opType, {Record record}) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: Text('Add name'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: opType == OpType.editing ? record.name : null,
                  onSaved: (value) => babyName = value,
                  validator: (value) =>
                      value.isEmpty ? 'please enter a name' : null,
                  onEditingComplete: () {
                    _formKey.currentState.validate();
                  },
                  decoration: InputDecoration(
                    labelText: 'Baby name',
                  ),
                ),
              ),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(0),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    _formKey.currentState.reset();
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('${opType == OpType.editing ? 'Update' : 'Add'}'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (opType == OpType.adding) {
                        widget.firestoreService.addBabyName(babyName).then((_) {
                          _showSnackbar(context, 'added name successfully');
                          Navigator.of(context).pop();
                        }).catchError((e) {
                          _showSnackbar(context, 'Error adding name');
                        });
                      } else {
                        widget.firestoreService
                            .updateBabyName(record.reference, babyName)
                            .then((_) {
                          _showSnackbar(context, 'updated name successfully');
                          Navigator.of(context).pop();
                        }).catchError((e) {
                          _showSnackbar(context, 'Error updating name');
                        });
                      }
                    }
                  },
                ),
              ],
            ));
  }
}
