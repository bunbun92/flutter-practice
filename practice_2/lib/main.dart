import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      home: Container(
        color: Color.fromARGB(255, 118, 204, 193),
        child: IndexPage()
        ),
      );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  var current = WordPair.random();

  void refreshWord(){
    setState(() {
      current = WordPair.random();  
    });    
  }

  var favorites = <WordPair>[];
  void like(){
    setState(() {
      if(favorites.contains(current)){
        favorites.remove(current);
      }else{
        favorites.add(current);  
      }      
    });    
  }  

  void dummy(){

  }

  @override
  Widget build(BuildContext context) {    

    IconData icon;
    if(favorites.contains(current)){
      icon = Icons.thumb_up;
    }else{
      icon = Icons.thumb_up_alt_outlined;
    }
      

    return Row(
      children: [
        Column(
          children: [
            ElevatedButton.icon(
              onPressed: dummy,
              icon: Icon(Icons.home), 
              label: Text("Home"),
              ),
            SizedBox(height: 15,),
            ElevatedButton.icon(
              onPressed: dummy,
              icon: Icon(Icons.thumb_up), 
              label: Text("Favorites"),
              ),
          ],          
        ),
        Expanded(
          child:
           Column(      
              mainAxisAlignment: MainAxisAlignment.center,           
              children: [        
                Text(current.asString),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: like,
                      icon: Icon(icon), 
                      label: Text("aa"),
                    ),
                    SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: refreshWord,
                       child: Text("New Word"),
                    ),                    
                  ],
                ),
                SizedBox(height: 15,),
                Column(
                  children: [
                    for(var f in favorites)
                      Text(
                        f.asString,
                        style: TextStyle(fontSize: 20),
                        ),                  
                  ],                  
                ),                
              ],
            ),
          ),         
      ],
    );
  }
}
