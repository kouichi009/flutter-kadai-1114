const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onCreateUserLikedPost = functions.firestore
  .document("/users/{userId}/likedPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    console.log("likedPosts Created", snapshot.id);
    const userId = context.params.userId;
    const postId = context.params.postId;

    const likedPostRef = admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("likedPosts")
      .doc(postId);

    // 3) Get followed users posts
    const doc = await likedPostRef.get();
    const postUid = doc.data().uid;
    const docRef = admin.firestore().collection("users").doc(postUid);
    const docSnapshot = await docRef.get();
    const user = docSnapshot.data();
    const androidNotificationToken = user.androidNotificationToken;
    console.log("androidNotificationToken: ", androidNotificationToken);
    console.log("user: ", user.name);

    // const createdActivityFeedItem = snapshot.data();
    if (androidNotificationToken) {
      sendNotification(androidNotificationToken, postUid);
    } else {
      console.log("No token for user, cannot send notification");
    }

    function sendNotification(androidNotificationToken, postUid) {
      let body = "あなたの投稿がいいねされました。";

      // 4) Create message for push notification
      const message = {
        notification: { body },
        token: androidNotificationToken,
        data: { recipient: postUid },
      };

      // 5) Send message with admin.messaging()
      admin
        .messaging()
        .send(message)
        .then((response) => {
          // Response is a message ID string
          console.log("Successfully sent message 123", response);
        })
        .catch((error) => {
          console.log("Error sending message", error);
        });
    }
  });
