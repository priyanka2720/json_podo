import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JsonParsingSimple extends StatefulWidget {
  const JsonParsingSimple({Key? key}) : super(key: key);

  @override
  _JsonParsingSimpleState createState() => _JsonParsingSimpleState();
}

class _JsonParsingSimpleState extends State<JsonParsingSimple> {
  late Future data;
  //data is a future type and it will call the fetch data(downside)
  //whatever will be returned must be inside Future data

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init-initial part of the application-here things happen before the Ui is rendered
    // i.e.,whenever we have a certain things that the application needs in this case the data setting up the data
    // setting up all the things that are needed before we boot up our application the inneed state
    data = getData(); //Network("https://jsonplaceholder.typicode.com/posts").fetchData();
    // getData(); is a method which calls or initialize the network object(Future getData() async)
    // again and then we fetch data and returns it.
    }

  @override
  Widget build(BuildContext context) {
    // build should be always responsible for rendering the UI
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Parsing Json")),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(// help us deal with future objects
            future: getData(), //future type data that we need
              builder: (context, AsyncSnapshot snapshot){
              //wev will give type for snapshot and the type is  AsyncSnapshot
                if(snapshot.hasData) {
                  return createListView(snapshot.data, context);
                  //return Text(snapshot.data[0]['userId'].toString());//returning a text
                }
                return CircularProgressIndicator();
            }),
        )
      )
    );
  }
  //even to make it easier
Future getData() async {
    var data;
    String url = "https://jsonplaceholder.typicode.com/posts";
    Network network = Network(url);

    data = network.fetchData();
   // data.then((value){ //then - it will resolve our future problem whatever we are hoping to receive
    //  print(value[0]['title']);// we will get the first object of our json
    //});
    return data;

}

  Widget createListView(List data, BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: data.length,
          itemBuilder: (context, int index){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(height: 5.0),
            ListTile(
              title: Text("${data[index]["title"]}"),
              subtitle: Text("${data[index]["body"]}"),
              leading: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 23,
                    child: Text("${data[index]["userID"]}")
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
Future fetchData() async{
  print("$url");
  //now we will have a "Response"- if we get any error or anything we need a response

  Response response = await get (Uri.parse(url));
  //we have to await keyword since we are inside async
  //we are just wrapping url to make sure if something happens or adding anything & its possible for it to be read

  if(response.statusCode == 200){

    //ok

    //print(response.body[0]);

    // we need to get an actual object so we use json decode that can probe in and say body that zero
    //in case we will just go & get the 1st object of this list
    //i.e, anything inside that braces which is exactly what we want. lets do:

    return json.decode(response.body);
    //body is a string representation of entire payload(showed in chrome)
    //we are decoding because we want to make sure that the string we getting
    //actually becomes json

  }
  else{
    print(response.statusCode);
  }
}
}