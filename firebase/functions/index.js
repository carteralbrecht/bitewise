const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Firebase cloud functions
// TODO: How to handle transaction failures and other edge cases

// On rating create:
// Put the rated item into the user's userInfo ratedItems array
exports.addRatedItemtoUserInfo = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {

        // Create reference to the userInfoDoc
        const userInfoRef = db.collection('userInfo').doc(snapshot.data().userUid);

        await db.runTransaction(async transaction => {
            // get the doc
            await transaction.get(userInfoRef).then((doc) => {
                    if (!doc.exists) {
                        throw "Document does not exist"
                    }

                    // update the doc
                    transaction.update(userInfoRef, {
                        ratedItems: admin.firestore.FieldValue.arrayUnion(snapshot.data().menuItemId)
                    })
                }
            );
        });
    });

// On rating create:
// update a menuitem's avgRating and numRatings
exports.aggregateRatings = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {

        // Get the value of the newly added rating
        const ratingVal = snapshot.data().rating;

        // Get the restaurant id of the newly added rating
        const restId = snapshot.data().restaurantId;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuItemId);

        await db.runTransaction(async transaction => {

                let oldAvgRating = 0;
                let oldNumRatings = 0;

                // if the menu item doc already exists then use current vals
                await transaction.get(menuItemRef).then(doc => {
                    if (doc.exists) {
                        oldAvgRating = doc.data().avgRating;
                        oldNumRatings = doc.data().numRatings;
                    }
                });

                // Compute the new number of ratings (+=1)
                const newNumRatings = oldNumRatings + 1;

                // Compute The new average rating
                const oldRatingTotal = oldAvgRating * oldNumRatings;
                const newAvgRating = (oldRatingTotal + ratingVal) / newNumRatings;

                // Update the menu item document
                transaction.set(menuItemRef, {
                    avgRating: newAvgRating,
                    numRatings: newNumRatings,
                    restaurantId: restId
                });
            }
        );
    });

// on rating update:
// update menuitem's avgRating when a rating is changed
exports.handleRatingsUpdate = functions.firestore
    .document('ratings/{ratinguid}')
    .onUpdate(async (snapshot, context) => {

        const ratingBefore = snapshot.before.data().rating;
        const ratingAfter = snapshot.after.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.after.data().menuItemId);

        await db.runTransaction(async (transaction) => {
            // Get document snapshot
            const menuItemDoc = await transaction.get(menuItemRef);

            // Compute the new average rating
            const oldRatingTotal = menuItemDoc.data().avgRating * menuItemDoc.data().numRatings;
            const newAvgRating = (oldRatingTotal - ratingBefore + ratingAfter) / menuItemDoc.data().numRatings;

            // Update the menu item document
            transaction.update(menuItemRef, {
                avgRating: newAvgRating,
            });
        })
    });

// On rating delete:
// recalculate the menuitem's avgRating and numRatings
exports.handleRatingsDelete = functions.firestore
    .document('ratings/{ratinguid}')
    .onDelete(async (snapshot, context) => {

        // the numeric rating being deleted
        const rating = snapshot.data().rating;

        // Get a reference to the menu item that was rated
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuItemId);

        try {
            await db.runTransaction(async (transaction) => {

                // Get document snapshot
                const menuItemDoc = await transaction.get(menuItemRef);

                if (!menuItemDoc.exists) {
                    throw "document not found";
                }

                // Compute the new average rating and total
                const ratingTotal = menuItemDoc.data().avgRating * menuItemDoc.data().numRatings;
                const newAvgRating = (ratingTotal - rating) / (menuItemDoc.data().numRatings - 1);

                // Update the menu item document
                transaction.update(menuItemRef, {
                    avgRating: newAvgRating,
                    numRatings: menuItemDoc.data().numRatings - 1
                });
            });
        } catch (e) {
            console.log('Transaction Failed', e);
        }
    });

// On user create:
// creates a userInfo document
exports.handleUserCreate = functions.auth
    .user()
    .onCreate(async (user) => {

        // get ref to userInfo doc with id as uid
        const userInfoRef = db.collection('userInfo').doc(user.uid);

        // create the doc and set ratedItems field
        await db.runTransaction(async (transaction) => {
            transaction.set(userInfoRef, {
                ratedItems: []
            })
        });
    });

// On user delete:
// deletes their userInfo doc
exports.handleUserDelete = functions.auth
    .user()
    .onDelete(async (user) => {

        // get reference to doc
        const userInfoRef = db.collection('userInfo').doc(user.uid);

        // delete the doc
        await db.runTransaction(async (transaction) => {
            transaction.delete(userInfoRef);
        });
    });

// On userInfo delete:
// deletes all of their ratings
exports.handleUserInfoDelete = functions.firestore
    .document('userInfo/{userinfouid}')
    .onDelete(async (snapshot, context) => {

        const ratingsRef = db.collection('ratings');
        const ratedItems = snapshot.data().ratedItems;

        // for each item they rated
        for (const menuItemId of ratedItems) {
            await db.runTransaction(async (transaction) => {
                // get their rating docs for that item (Should only be 1)
                const ratingQuerySnapshot = await ratingsRef
                    .where('userUid', '==', snapshot.id)
                    .where('menuItemId', '==', menuItemId)
                    .get();

                // delete those ratings (Should only be 1)
                for (const doc of ratingQuerySnapshot.docs) {
                    transaction.delete(doc.ref);
                }
            });
        }

    });