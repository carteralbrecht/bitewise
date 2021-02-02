const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Update a menuitems avgRating and numRatings when a new rating is created
// https://cloud.google.com/firestore/docs/solutions/aggregation
exports.handleRatingsCreate = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {

        // Update user's ratedItems array in userInfo
        const userInfoRef = db.collection('userInfo').doc(snapshot.data().userUid);
        await userInfoRef.update({
            ratedItems: admin.firestore.FieldValue.arrayUnion(snapshot.data().menuItemId)
        });

        // Get the value of the newly added rating
        const ratingVal =  snapshot.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuItemId);

        // Get document snapshot
        let menuItemDoc = await menuItemRef.get();

        // Create document if not exists
        if (!menuItemDoc.exists) {
            await menuItemRef.set({
                avgRating: 0,
                numRatings: 0
            });
            menuItemDoc = await menuItemRef.get();
        }

        // Compute the new number of ratings (+=1)
        const newNumRatings = menuItemDoc.data().numRatings + 1;

        // Compute The new average rating
        const oldRatingTotal = menuItemDoc.data().avgRating * menuItemDoc.data().numRatings;
        const newAvgRating = (oldRatingTotal + ratingVal) / newNumRatings;

        // Update the menu item document
        await menuItemRef.set({
            avgRating: newAvgRating,
            numRatings: newNumRatings
        });
    });

// update menuitems avgRating when a rating is changed
exports.handleRatingsUpdate = functions.firestore
    .document('ratings/{ratinguid}')
    .onUpdate(async (snapshot, context) => {

        const ratingBefore = snapshot.before.data().rating;
        const ratingAfter = snapshot.after.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.after.data().menuItemId);

        // Get document snapshot
        const menuItemDoc = await menuItemRef.get();

        // Compute the new average rating
        const oldRatingTotal = menuItemDoc.data().avgRating * menuItemDoc.data().numRatings;

        const newAvgRating = (oldRatingTotal - ratingBefore + ratingAfter) / menuItemDoc.data().numRatings;

        // Update the menu item document
        await menuItemRef.update({
            avgRating: newAvgRating,
        });
    });

exports.handleRatingsDelete = functions.firestore
    .document('ratings/{ratinguid}')
    .onDelete(async (snapshot, context) => {

        const rating = snapshot.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuItemId);

        // Get document snapshot
        const menuItemDoc = await menuItemRef.get();

        // Compute the new average rating
        const ratingTotal = menuItemDoc.data().avgRating * menuItemDoc.data().numRatings;

        const newAvgRating = (ratingTotal - rating) / (menuItemDoc.data().numRatings - 1);

        // Update the menu item document
        await menuItemRef.update({
            avgRating: newAvgRating,
            numRatings: menuItemDoc.data().numRatings - 1
        });
    })

// creates a userInfo document when a new user is created
exports.handleUserCreate = functions.auth
    .user()
    .onCreate(async (user) => {

        const userInfoRef = db.collection('userInfo').doc(user.uid);

        await userInfoRef.set({
            ratedItems: []
        });
    });

exports.handleUserDelete = functions.auth
    .user()
    .onDelete(async (user) => {

        const userInfoRef = db.collection('userInfo').doc(user.uid);

        await userInfoRef.delete();
    });

exports.handleUserInfoDelete = functions.firestore
    .document('userInfo/{userinfouid}')
    .onDelete((snapshot, context) => {

        // get ratedItems array
        // for each menuItemId
        // --> find rating document with userUid and menuItemId
        //     delete each rating
        //     --> triggers handleRatingDelete

        const ratingsRef = db.collection('ratings');

        snapshot.data().ratedItems.forEach(async (menuItemId) => {
            const querySnapshot = await ratingsRef
                .where('userUid', '==', snapshot.data().id)
                .where('menuItemId', '==', menuItemId)
                .get();

            for (const doc of querySnapshot) {
                await doc.delete();
            }
        });
    })