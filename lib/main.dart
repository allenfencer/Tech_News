import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:async';
import 'dart:convert';


Map data;
List newsData;
var date=DateTime.now();


void main() async{
  data= await getNews();
  newsData=data['articles'];

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NewsApp(),
  ));
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Tech News', style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.w800),),
        elevation: 0,
      ),
      body: Content(),
    );
  }
}

Future <Map> getNews()async{
  final String _api='55a177bad241441b89864b27e16a87d2';
  String url='https://newsapi.org/v2/everything?q=tech&from=${date.year}-${date.month}-${date.day}&to=${date.year}-${date.month}-${date.day}&sortBy=popularity&apiKey=$_api';
  http.Response response= await http.get(Uri.parse(url));
  return jsonDecode(response.body);
}




class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNews(),
        builder: (BuildContext context,snapshot){
          if(snapshot.hasData)
          {
            return ListView.builder(
                itemCount: newsData.length,
                itemBuilder: (BuildContext context,index)
                {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12,25,12,0),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[800],
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(2,3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network('${newsData[index]['urlToImage']}',),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text('${newsData[index]['title']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,color: Colors.grey[800]),),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,10,12,20),
                            child: Text('${newsData[index]['description']}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.grey[700],fontStyle: FontStyle.normal),),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blue,),
            );
          }
        });
  }
}