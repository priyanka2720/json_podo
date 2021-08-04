import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json/model/post.dart';

class JsonParsingMap extends StatefulWidget {
  const JsonParsingMap({Key? key}) : super(key: key);

  @override
  _JsonParsingMapState createState() => _JsonParsingMapState();
}

class _JsonParsingMapState extends State<JsonParsingMap> {
   late Future<PostList> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Network network = Network("https://jsonplaceholder.typicode.com/posts");
    data = network.loadPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("PODO")),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
            future: data,
            builder: (context,
            AsyncSnapshot<PostList> snapshot) {
              List<Post> allPosts;
              if(snapshot.hasData) {
                allPosts = snapshot.data!.posts;
                return createListView(allPosts, context);
              }else {
                return CircularProgressIndicator();
              }
            }),
        ),
      ),
    );
  }
  Widget createListView(List<Post> data, BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: data.length,
          itemBuilder: (context, int index){
          return Column(
            children: <Widget>[
              Divider(height: 5.0,),
              ListTile(
                title: Text("${data[index].title}"),
                subtitle: Text("${data[index].body}"),
                leading: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 23,
                      child: Text("${data[index].id}"),
                    )
                  ],
                ),
              )
            ],
          );
          }),
    );
  }
}
class Network //this will fetch the data from Json payload in chrome//
    {
  final String url;

  Network(this.url);

// creating a function called "fetchData" Now we will create a method which will be responsible for actually getting a Json
//and decode it and ake it so that its the actually Json which we are gonna parse
//Beyond being synchronous it also has to be a type future

  Future<PostList> loadPosts() async {
    final response = await get(Uri.parse(url));
    if(response.statusCode ==200){
      //ok
      return PostList.fromJson(json.decode(response.body));//we get json object
    }else{
      throw Exception("failed to get Posts");

    }

}

}