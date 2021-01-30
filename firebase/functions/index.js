const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Update a menuitems avgRating and numRating when a new rating is created
// https://cloud.google.com/firestore/docs/solutions/aggregation
exports.aggregateRatings = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {


        // -------------------------------------------------
        // Get the value of the newly added rating
        const ratingVal =  snapshot.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuitemuid);

        // Update aggregations in a transaction
        await db.runTransaction(async (transaction) => {

            const menuItemDoc = await transaction.get(menuItemRef);

            // Compute The new number of ratings (+= 1)
            const newNumRating = menuItemDoc.data().numRating + 1;

            // Compute The new average rating
            const oldRatingTotal = menuItemDoc.data().avgRating * menuItemDoc.data().numRating;
            const newAvgRating = (oldRatingTotal + ratingVal) / newNumRating;

            transaction.update(menuItemRef, {
                avgRating: newAvgRating,
                numRating: newNumRating
            });
      });
     // -------------------------------------------------
    });
