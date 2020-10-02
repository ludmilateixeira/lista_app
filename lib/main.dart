import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart'; // dependencies: social_share: ^2.0.5
//http://www.macoratti.net/19/07/flut_fomval1.htm

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
  var _nameitemController = TextEditingController();
  var _whoController = TextEditingController();
  var _priceController = TextEditingController();

  //List about the List
  //List _listagem=['Thing 0001', 'Thing 0010', 'Thing 0011','Thing 0100','Thing 0101','Thing 0110','Thing 0111','Thing 1000','Thing 1001','Thing 1010'];
  List _listagem=[];

  //The fix page / Menu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('To Buy and Share'),
        //centerTitle: false,
        //About the botton Share
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async{
              var itens =
              _listagem.reduce((value, element) => value + '\n' + element);
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
                      child: CircleAvatar(child:Text('${i + 1}'),backgroundColor: Colors.cyan,foregroundColor: Colors.white, maxRadius: 17)
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      //Name of the bottons in the row
                      _listItemName(i),
                      _listwhoController(i),
                      _listItemPrice(i),
                      _listDelete(i),
                    ],
                  )
              ),
          ],
        ),
      ),

      //About the floating button ADD in the bottom of the page
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_shopping_cart,color: Colors.white, size: 25),
        backgroundColor: Colors.pinkAccent,
        onPressed: () => _displayDialog(context), //_displayDialog is the fuction for create the new thing in the list
      ),
    );
  }

  //Label Name
  _listItemName(int i)
  {
    return Expanded(
      child: Text(
          _listagem[i]["name"].toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              fontStyle: FontStyle.italic,
              color: Colors.pinkAccent,
          )
      ),
    );
  }

  //Label who is the person?
  _listwhoController(int i)
  {
    return Expanded(
      child: Text(
          _listagem[i]["who"].toString(),
          style: TextStyle(
            fontSize: 17,
          )
      ),
    );
  }

  //Label Price
  _listItemPrice(int i)
  {
    String text = _listagem[i]["price"] != null ? "R\$ "+_listagem[i]["price"].toStringAsFixed(2) : "";
    return Expanded(
      child: Text(
        text
      ),
    );
  }

  //Botton Remove: Remove something in the list
  _listDelete(int i)
  {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: 22.0,
        //color: Colors.red[900],
        color: Colors.cyan,
      ),
      onPressed: (){
        setState(() {
          _listagem.removeAt(i);
        });
      },
    );
  }


  //About the new item at the list
  _displayDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Container(
              child: Column(
              children: [
              TextFormField(
                controller: _nameitemController,
                validator: (s) {
                  if (s.length < 2)
                    return "Please, type the item with less 2 character's";
                  else
                    return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Name of the Item*"),
              ),
                TextFormField(
                  controller: _whoController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Who is the person"),
                ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Price", prefixText: "R\$ "),
               ),
               ],
              )
              )
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
                      _listagem.add({
                        "name": _nameitemController.text,
                        "who": _whoController.text,
                        "price": double.tryParse(_priceController.text) ?? 0,
                      });
                      _nameitemController.text = "";
                      _whoController.text = "";
                      _priceController.text = "";
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

