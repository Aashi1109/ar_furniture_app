const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Delete user and related data when a user is deleted from Firebase console
exports.deleteUserData = functions.auth.user().onDelete((user) => {
  const userId = user.uid;

  // Delete user document
  const userDocRef = admin.firestore().collection("users").doc(userId);
  const userDeletePromise = userDocRef.delete();

  // Delete user's reviews
  const reviewsQuery = admin
    .firestore()
    .collection("reviews")
    .where("userId", "==", userId);
  const reviewsDeletePromise = reviewsQuery.get().then((querySnapshot) => {
    const deletePromises = [];
    querySnapshot.forEach((doc) => {
      deletePromises.push(doc.ref.delete());
    });
    return Promise.all(deletePromises);
  });

  // Wait for all delete operations to complete
  return Promise.all([userDeletePromise, reviewsDeletePromise]);
});

// Create notification on new product add
exports.createProductNotification = functions.firestore
  .document("products/{productId}")
  .onCreate((snap, context) => {
    const product = snap.data();
    const productName = product.name;
    const productId = context.params.productId;

    // Get all user documents
    const usersRef = admin.firestore().collection("users");
    return usersRef.get().then((querySnapshot) => {
      const promises = [];

      // For each user, create a notification document
      querySnapshot.forEach((userDoc) => {
        const userId = userDoc.id;
        const notificationRef = usersRef
          .doc(userId)
          .collection("notifications")
          .doc();

        const notification = {
          text: `${productName} is added.`,
          id: notificationRef.id,
          title: "New Product Added",
          icon: "983040",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          isRead: false,
          action: { action: "product", params: productId },
          productId: productId,
        };

        promises.push(notificationRef.set(notification));
      });

      return Promise.all(promises);
    });
  });
