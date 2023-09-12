import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    

    return ChangeNotifierProvider(
      create: (context) => ImageUploader(),
      child: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var imageUploader = context.watch<ImageUploader>();   
    var tmp;
    if(imageUploader.image != null){
      tmp = Container(
        width: 300,
        height: 300,
        child: Image.file(File(imageUploader.image!.path)),
      );
    }else{
      tmp = Container(
        width: 300,
        height: 300,
        color: Colors.grey,
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  imageUploader.getImage(ImageSource.gallery);
              }, child: Text("갤러리에서")),
              tmp,
            ],
          ),          
        ),
      ),
    );
  }

}


class AppState extends ChangeNotifier{

}

class ImageUploader extends AppState{
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null){
      image = XFile(pickedFile.path);
      notifyListeners();
    }
  }
}
