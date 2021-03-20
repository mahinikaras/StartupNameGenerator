import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'Names.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name generator',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize:18);
  final _saved =<WordPair>{};

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Startup Name Generator"),
          actions:[
            IconButton(icon:Icon(Icons.list),onPressed: _pushSaved),
          ]
        ),
        body: _buildSuggestions(),
      );
  }

  Widget _buildSuggestions(){
    return ListView.builder(
      padding:const EdgeInsets.all(16) ,
      itemBuilder: (BuildContext _context,int i){
        if(i.isOdd){
          return Divider();
        }

        final int index = i~/2;
        if(i>=index){
          _suggestions.addAll(generateWordPairs().take(10));

        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final _alreadySaved = _saved.contains(pair);
    Random random = new Random();
    final randomNameIndex = random.nextInt(names.length-1);
    return ListTile(
      title: Text(

        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red: null,
      ),
      onTap: (){
        setState(() {
          if(_alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved(){
     if(_saved.length > 0 ){
       Navigator.of(context).push(
         MaterialPageRoute<void>(
             builder: (BuildContext context){
               final tiles = _saved.map(
                     (WordPair pair){
                   return ListTile(
                     title: Text(
                       pair.asPascalCase,
                       style: _biggerFont,
                     ),
                   );
                 },
               );
               final divided = ListTile.divideTiles(tiles: tiles,context: context,).toList();
               return Scaffold(
                 appBar: AppBar(
                   title: Text("Saved Names"),
                 ),
                 body: ListView(children: divided,),
               );
             }
         ),
       );
     }

  }

}

