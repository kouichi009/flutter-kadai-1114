import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/news/article_model.dart';
import 'package:instagram_flutter02/screens/news_api/articles_details_page.dart';

Widget newsCustomListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticlePage(
                    article: article,
                  )));
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          article.urlToImage != null
              ? Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //let's add the height

                    image: DecorationImage(
                        image: NetworkImage(article.urlToImage!),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
              : Container(child: Text('no image')),
          SizedBox(
            height: 8.0,
          ),
          article.source?.name != null
              ? Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    article.source!.name!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(child: Text('no name')),
          SizedBox(
            height: 8.0,
          ),
          article.title != null
              ? Text(
                  article.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                )
              : Text('no title')
        ],
      ),
    ),
  );
}
