class PostList{
  final List<Post> posts;

  PostList({required this.posts});

  factory PostList.fromJson(List<dynamic> parsedJson) {
    //we will make whole list(payload) into an object
    List<Post> posts = <Post>[];
    posts = parsedJson.map((i) => Post.fromJson(i)).toList();

    return new PostList(posts: posts); //Post[0].

  }
}
class Post{ // we are gonna mimic one class


  Post({required this.userId, required this.id, required this.title, required this.body}); //PODO
  int userId; // we are mapping these all fields,
  int id; //in our json fields
  String title;
  String body;

  factory Post.fromJson(Map<String, dynamic> json) //factory:-allow us to do mapping
  {
    return Post( //map all of the field to json
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],

    );
  }


}