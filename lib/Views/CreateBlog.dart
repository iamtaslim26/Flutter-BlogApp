import 'dart:io';
import 'package:FlutterChatApp/Services/Crud.dart';
import 'package:FlutterChatApp/Views/HomePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';


class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {


   String authorname,title,description;
   bool isLoading=false;
   CrudMethods crudMethods=new CrudMethods();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  UploadBlog() async {

    if(_image!=null){

      setState(() {
        
        isLoading=true;
      });

      //Uploading Image to Firebase Storage

      StorageReference firebaseStorageRef=FirebaseStorage.instance.ref()
                                            .child("Blog Images")
                                            .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task=firebaseStorageRef.putFile(_image);
      var downloadUrl=await(await task.onComplete).ref.getDownloadURL();

      print("this is downloadurl $downloadUrl");
      Navigator.pop(context); 

      Map<String,String>blogMap={

        'ImageURL':downloadUrl,
        'Title':title,
        'Description':description,
        'AuthorName':authorname

     

      };                                    

      crudMethods.addData(blogMap).then((result){

        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        });

      });

      


    }
    
    else{}



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
          Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              Text("Flutter",style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700
              ), 
              ),
              
              Text("Blog",style: TextStyle(

                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.blue
              ), )
            ],
   
          ),

      backgroundColor: Colors.transparent,
      elevation: 0.0,

      actions: <Widget>[

        GestureDetector(

            onTap: (){

              UploadBlog();
            },
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.upload_file)),
        )
      ],
        
      ),

      body:isLoading ?
      
      Container(

          alignment: Alignment.center,
          child: CircularProgressIndicator(),

      ) :Container(
         
          child: Column(

          children: <Widget>[

            SizedBox(height: 10,
            ),

          GestureDetector(
            onTap: (){

              getImage();
            },


            child: _image!=null?
            
            Container(

              child: ClipRRect(
              child: Image.file(_image,fit: BoxFit.cover,
                
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 16),

            )
            : Container(

              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 16),

        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
            

            color: Colors.white,
            borderRadius: BorderRadius.circular(5),

        ),

        child: Icon(Icons.add_a_photo,color: Colors.black,),
        
        ),
          ),

        Container(

          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(

          children: <Widget>[

          TextFormField(

              validator: (val){

             if(val==null){

               return "Please Enter Author Name";
             }
           },
          onChanged: (value){

            authorname=value;
          },

          decoration: InputDecoration(

            
            labelText: 'Author name'
            
          ),
        ),

         TextFormField(

           validator: (val){

             if(val==null){

               return "Please Enter title";
             }
           },

          onChanged: (value){

            title=value;
          },

          decoration: InputDecoration(

            
            labelText: 'Title'
            
          ),
        ),

         TextFormField(

           validator: (val){
             if(val==null){

               return "Please Enter the Description";
             }


           },

          onChanged: (value){

            description=value;
          },
          

          decoration: InputDecoration(

            

            
            labelText: 'Description',
            
            
          ),

          
        ),

            ],
          ),
        ),

        
           
       
          ],
        ),
      ),
    );
  }
}