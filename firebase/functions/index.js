const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Update a menuitems avgRating and numRatings when a new rating is created
// https://cloud.google.com/firestore/docs/solutions/aggregation
exports.aggregateRatings = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {

        // Get the value of the newly added rating
        const ratingVal =  snapshot.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuItemId);

        // Create document if not exists
        await menuItemRef.get().then(doc => {
            if (!doc.exists) {
                menuItemRef.set({
                    avgRating: 0,
                    numRatings: 0
                });
            }
        });

        // Get document snapshot
        const menuItemDoc = await menuItemRef.get();

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
exports.handleRatingChange = functions.firestore
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

