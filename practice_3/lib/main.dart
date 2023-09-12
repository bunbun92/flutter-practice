import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: IndexWidget(),
      ),
    );
  }
}

class IndexWidget extends StatefulWidget {
  const IndexWidget({
    super.key,
  });

  @override
  State<IndexWidget> createState() => _IndexWidgetState();
}

class _IndexWidgetState extends State<IndexWidget> {

  var selectedIdx = 0;

  void dummy(){}

  void pageHome(){
    setState(() {
      selectedIdx = 0;
    });
  }

  void pageFavorites(){
    setState(() {
      selectedIdx = 1;
    });
  }

  @override
  Widget build(BuildContext context) {

    var page;

    if(selectedIdx == 0){
      page = LikeWidget();
    }else{
      page = FavoritesListWidget();
    }

    return ChangeNotifierProvider(
      create:(context) => AppState(),
      child: Center(
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 135, 155, 147)),
          ),
          home: Row(
            children: [
              Container(
                // color: Color.fromARGB(255, 216, 161, 147),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: NavigationRail(
                    backgroundColor: Color.fromARGB(221, 145, 197, 150),
                    selectedIndex: selectedIdx,
                    onDestinationSelected: (int i){
                      setState(() {
                        selectedIdx = i;
                      });
                    },
                    labelType: NavigationRailLabelType.selected,
                    destinations:[
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text("Home"),  
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.thumb_up_outlined),
                        selectedIcon: Icon(Icons.thumb_up),
                        label: Text("favorites"),  
                      )
                    ]                      
                    ),
                  ),
                ),

              Expanded(              
                child: MaterialApp(                
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 84, 221, 157)),                  
                  ),
                  home: page,
                  )
                ),            
            ],            
          ),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier{
  var current = WordPair.random();

  void newWord(){
    current = WordPair.random();
    notifyListeners();    
  }

  var favorites = <WordPair>[];

  void like(){
    if(favorites.contains(current)){
      favorites.remove(current);
    }else{
      favorites.add(current);
    }
    notifyListeners();
  }

  void unLike(WordPair word){
    favorites.remove(word);
    notifyListeners();
  }
}

class LikeWidget extends StatelessWidget {
  const LikeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    var icon;
    if(appState.favorites.contains(appState.current)){
      icon = Icons.thumb_up;
    }else{
      icon = Icons.thumb_up_outlined;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 19, 165, 92)),
          appState.current.asLowerCase
          ),
        SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ElevatedButton.icon(onPressed: appState.like, icon: Icon(icon), label: Text("Like")),
          SizedBox(width: 10,),
          ElevatedButton.icon(onPressed: appState.newWord, icon: Icon(Icons.new_label), label: Text("New Word")),
        ],)
      ],
      
    );
  }
}

class FavoritesListWidget extends StatelessWidget {
  const FavoritesListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AppState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for(var f in appState.favorites)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => appState.unLike(f),
              icon: Icon(color: Colors.red,
                Icons.cancel),
              label: Text(
                style: TextStyle(
                  fontSize: 20,                  
                ),
                f.asLowerCase
                ),
            ),
          ),
      ],
    );
  }
}
