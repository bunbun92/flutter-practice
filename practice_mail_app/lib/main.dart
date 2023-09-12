import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

int myId= 1;
var db = DataBase();
var serverStreamController = StreamController();
void dummy(){}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MainWidget()
      );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(      
      // home: ListWidget(),
      routes: {
        '/' : (context) => ListWidget(),
        '/write' : (context) => MailWriteWidget(),
        // '/read' : (context) => MailReadWidget(),
      },
      initialRoute: '/',   
    );    
  }
}

class ListWidget extends StatefulWidget {
  const ListWidget({
    super.key,
  });

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {

  var _selectedIdx = 0;
  var title = "";
  var actionFunc;
  var actionIcon;
  var page;

  void navigate(){
    if(_selectedIdx == 0){
      Navigator.pushNamed(context, '/write');
    }
  }

  @override
  Widget build(BuildContext context) {    

    if(_selectedIdx == 0){
      title = "Mails";
      actionFunc = dummy;      
      page = MailsWidget();            
      actionIcon = Icon(Icons.edit);
      

    }else{
      title = "Friends";
      actionFunc = dummy;      
      page = FriendsWidget();
      actionIcon = Icon(Icons.person_add);
    }

    return Scaffold(
      appBar: AppBar(                 
        title: Text(title),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: (){Scaffold.of(context).openEndDrawer();} ,
                icon: Icon(Icons.account_circle),
              );
            }
          )
        ],
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Mails',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIdx,
        onTap: (int i){
          setState(() {
            _selectedIdx = i;                                    
          });       
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigate,
        child: actionIcon,
        ),
      endDrawer: Drawer(
        child: Placeholder(),        
      ),
    );
  }
}

class MailsWidget extends StatelessWidget {
  const MailsWidget({super.key});

  @override
  Widget build(BuildContext context) {    
    var mails = db.users[myId]!.mails;    
    
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: mails.length,
      itemBuilder: (BuildContext c, int i){          
        return Card(
          child: ElevatedButton(
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle),
              ),
              Container(width: 80,
                child: Text(mails[i]["name"], style: TextStyle(fontSize: 15))),
              SizedBox(width: 10,),
              Column(children: [                
                Container(width: 150,
                  child: Text(mails[i]["title"], style: TextStyle(fontSize: 13))),
                Container(width: 150,
                  child: Text(mails[i]["text"], style: TextStyle(fontSize: 10))),
                ],              
              )
            ],),
            onPressed: (){
              final Mail mail = Mail(
                mails[i]["id"], 
                mails[i]["name"], 
                mails[i]["title"], 
                mails[i]["text"],
                );                 
              Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => MailReadWidget()),
                settings: RouteSettings(arguments: mail),
                ));
            },
          ),
        );
      }
    );
  }
}

class FriendsWidget extends StatelessWidget {
  const FriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {

    var friends = db.users[myId]!.friends;

    return ChangeNotifierProvider(
      create: (context) => db,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            child: ElevatedButton(      
              style: ElevatedButton.styleFrom(
                // textStyle: TextStyle(color: Colors.black,),
                backgroundColor: Colors.white,
              ),        
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.account_circle, color: Colors.black,),
                ),
                Container(width: 80,
                  child: Text(friends[i]["name"], style: TextStyle(fontSize: 15, color: Colors.black))),
                SizedBox(width: 10,),
                Container(width: 150,
                  child: Text(friends[i]["state"], style: TextStyle(fontSize: 13, color: const Color.fromARGB(255, 82, 82, 82))),
                )
              ],),
              onPressed: (){
                Navigator.pushNamed(context, '/write', arguments: friends[i]["name"]);
              },
            ),
          );
        }
      ),
    );
  }
}

class MailReadWidget extends StatelessWidget {
  const MailReadWidget({super.key});  

  void navigate(String name){
    
  }

  @override
  Widget build(BuildContext context) {    
    final Mail mail = ModalRoute.of(context)!.settings.arguments as Mail;

    return Scaffold(
      appBar: AppBar(        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle),
            SizedBox(width: 10),
            Text(mail.name),
          ],
        ),
       actions: [
        Container(width: 45,),
       ],     
      ),
      body: Column(children: [
          Card(
            child: Row(children: [              
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mail.title,
                    style: TextStyle(fontSize: 30),
                    ),
                ),
            ],),
          ),
          
          Expanded(
            child: Card(              
              child: Container(
                alignment: Alignment.topLeft,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      mail.text,
                      style: TextStyle(fontSize: 15),
                      ),
                  ),
                ],),
              ),
            ),
          )
        ],),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/write', arguments: mail.name);
        },
        child: Icon(Icons.reply),
        ),      
    );
  }
}

class MailWriteWidget extends StatelessWidget {
  MailWriteWidget({super.key});
  
  var title;
  var text;
  var to;

  void send(){
    
  }

  @override
  Widget build(BuildContext context) {

    final String? to = ModalRoute.of(context)?.settings.arguments as String?;
    TextEditingController _controller = TextEditingController();//dispose() 안해놨음
    if(to != null){
        _controller.text = to;
    }    
    return Scaffold(
      appBar: AppBar(
        title: Text("메일 쓰기"),
      ),
      body: Column(children: [
          Card(
            child: TextField(
              decoration: InputDecoration(
                labelText: '제목',
                hintText: '제목을 입력하세요',                
              ),
              onChanged: (str){
                title = str;
              },
            ),
          ),
          Card(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '받는이',                
                hintText: '이름을 입력하세요',
              ),
              onChanged: (str){
                this.to = str;
              },
            ),
          ),         
          Expanded(
            child: Card(              
              child: Container(
                alignment: Alignment.topLeft,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '내용',
                    hintText: '내용 입력하세용',
                  ),
                  onChanged: (str){
                    text = str;
                  },
                ),
              ),
            ),
          )
        ],),
        floatingActionButton: FloatingActionButton(
          onPressed: dummy,
          child: Icon(Icons.send),
          ),
    );    
  }
}

class ImageUploader extends AppState{
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if( pickedFile != null){
      _image = XFile(pickedFile.path);
      notifyListeners();
    }
  }

}


class AppState extends ChangeNotifier{

  

}

class Server{
  
  // Server(){
  //   serverStreamController.stream.listen(
  //     (mail){
  //       db.add(mail)
  //     });

  // }
}


class UserInfo {
  int id= -1;
  String name = "none";
  List<Map<String, dynamic>> mails= [
    {
      "id"    : -99,
      "name"  : "테스트이름2",
      "title" : "제목",
      "text"  : "내용",
    },   
    {
      "id"    : 0,
      "name"  : "상우",
      "title" : "안녕",
      "text"  : "방구마렵다",
    }, 
    {
      "id"    : 3,
      "name"  : "김동동",
      "title" : "오랜만이네여",
      "text"  : "잘지내시는?",
    },  
  ]; 
  List<Map<String, dynamic>> friends= [
    {
      "id"    : -99,
      "name"  : "테스트이름2",
      "state" : "테스트상태",
    },
    {
      "id"    : 0,
      "name"  : "상우",
      "state" : "이기적 유전자, 마음의 양식",
    },    
  ];

  UserInfo(this.id, this.name){}

  void addFriend(){}
  void addMail(Mail mail){

  }
}

class DataBase extends ChangeNotifier{

  final Map<int, UserInfo> users = {};  

//
  var a = UserInfo(0, "상우");
  var b = UserInfo(1, "봉봉이");
  var c = UserInfo(2, "멍멍이");
  var d = UserInfo(3, "김동동");
  
  DataBase(){
    users[a.id]= a;
    users[b.id]= b;
    users[c.id]= c;
    users[d.id]= d;
    notifyListeners();
  }
//
  // UserInfo getUserInfo(int id){
  //   var r = users[id];
  //   return r;
  // }

}

class Mail{
  final int id;
  final String name;
  final String title;
  final String text;
  bool unSend = true;
  bool unRead = true;

  Mail(this.id, this.name, this.title, this.text);  
}