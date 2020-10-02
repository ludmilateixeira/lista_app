import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart'; // dependencies: social_share: ^2.0.5

void main() {
  runApp(MaterialApp(
    title: 'Listagem',
    debugShowCheckedModeBanner: false,
    home: MainApp(),
  ));
}
//Principal stf State Full -  Before _State, I have to put the name of application
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  //Forms
  final _formKey = GlobalKey<FormState>();
  var _itemController = TextEditingController();
  //List about the List
  List _listagem=['Thing 0001', 'Thing 0010', 'Thing 0011','Thing 0100','Thing 0101','Thing 0110','Thing 0111','Thing 1000','Thing 1001','Thing 1010'];
  List _sublistagem=['Teste 0001', 'Teste 0010', 'Teste 0011','Teste 0100','Teste 0101','Teste 0110','Teste 0111','Teste 1000','Teste 1001','Teste 1010'];

  //The fix page / Menu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Buy and Share'),
        centerTitle: false,
        //About the botton Share
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async{
              var itens =
              _listagem.reduce((value, element) => value + '\n' + element);
              _sublistagem.reduce((value, element) => value + '\n' + element);
              SocialShare.shareWhatsapp("To Buy and Share:\n" + itens)
                  .then((data){
                //print(data);
              });
            },
          )
        ],
      ),
      //Data about the List
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (int i = 0; i < _listagem.length; i++)
              ListTile(
                    leading: ExcludeSemantics(
                    child: CircleAvatar(child: Text('${i + 1}')),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _listagem[i].toString(),
                        ),
                      ),
                      //Botton Remove: Remove something in the list
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 22.0,
                          //color: Colors.red[900],
                          color: Colors.redAccent,
                        ),
                         onPressed: (){
                          setState(() {
                            _listagem.removeAt(i);
                          });
                        },
                      ),
                    ],
                  )),
          ],
        ),
      ),

      //About the floating button ADD in the bottom of the page
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayDialog(context), //_displayDialog is the fuction for create the new thing in the list
      ),
    );
  }

  _displayDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _itemController,
                validator: (s) {
                  if (s.isEmpty)
                    return "Please, type the item";
                  else
                    return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Item"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _listagem.add(_itemController.text);
                      _itemController.text = "";
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}

