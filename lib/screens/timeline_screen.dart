import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:provider/provider.dart';
import 'package:instagram_flutter02/providers/bottom_navigation_bar_provider.dart';
import 'package:instagram_flutter02/providers/timeline_provider.dart';

class TimelineScreen extends StatelessWidget {
  // const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineProvider = context.watch<TimelineProvider>();
    // if (_movies.length != 0) {
    return Scaffold(
      appBar: AppHeader(
        isAppTitle: false,
        titleText: 'タイムラインページ',
      ),
      body: NotificationListener(
        onNotification: (dynamic _onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              timelineProvider.getQueryTimeline();
              return true;
            }
            return false;
          }
          return false;
        },
        child: Column(children: [
          Expanded(
            child: timelineProvider.posts.length == 0
                ? Center(
                    child: Text('No Data...'),
                  )
                : ListView.builder(
                    itemCount: timelineProvider.posts.length,
                    itemBuilder: (context, index) {
                      return new GestureDetector(
                        //You need to make my child interactive
                        onTap: () => null,
                        child: PostView(
                            userModel: timelineProvider.userModels[index],
                            post: timelineProvider.posts[index],
                            index: index),
                      );
                    },
                  ),
          ),
          // _isLoading
          //     ? Container(
          //         width: MediaQuery.of(context).size.width,
          //         padding: EdgeInsets.all(5),
          //         color: Colors.yellowAccent,
          //         child: Text(
          //           'Loading',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       )
          //     : Container()
        ]),
      ),
    );
    // } else {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.white,
    //     ),
    //   );
    // }
  }
}
