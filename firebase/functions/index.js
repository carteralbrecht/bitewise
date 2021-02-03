const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// put the menuItemId in the users userInfo doc
exports.addRatedItemtoUserInfo = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {

        // Create reference to the userInfoDoc
        const userInfoRef = db.collection('userInfo').doc(snapshot.data().userUid);

        // Update
        await db.runTransaction(async transaction => {
            await transaction.get(userInfoRef).then((doc) => {
                    if (!doc.exists) {
                        throw "Document does not exist"
                    }

                    transaction.update(userInfoRef, {
                        ratedItems: admin.firestore.FieldValue.arrayUnion(snapshot.data().menuItemId)
                    })
                }
            );
        });
    });

// Update a menuitems avgRating and numRatings when a new rating is created
exports.aggregateRatings = functions.firestore
    .document('ratings/{ratinguid}')
    .onCreate(async (snapshot, context) => {

        // Get the value of the newly added rating
        const ratingVal =  snapshot.data().rating;

        // Get a reference to the menu item
        const menuItemRef = db.collection('menuitems').doc(snapshot.data().menuItemId);

        await db.runTransaction(async transaction => {

                let oldAvgRating = 0;
                let oldNumRatings = 0;

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
                    numRatings: newNumRatings
                });
            }
        );
    });

// update menuitems avgRating when a rating is changed
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

exports.handleRatingsDelete = functions.firestore
    .document('ratings/{ratinguid}')
    .onDelete(async (snapshot, context) => {

        const rating = snapshot.data().rating;

        // Get a reference to the menu item
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

// creates a userInfo document when a new user is created
exports.handleUserCreate = functions.auth
    .user()
    .onCreate(async (user) => {

        const userInfoRef = db.collection('userInfo').doc(user.uid);

        await db.runTransaction(async (transaction) => {
            transaction.set(userInfoRef, {
                ratedItems: []
            })
        });
    });

exports.handleUserDelete = functions.auth
    .user()
    .onDelete(async (user) => {

        const userInfoRef = db.collection('userInfo').doc(user.uid);

        await db.runTransaction(async (transaction) => {
            transaction.delete(userInfoRef);
        });
    });

exports.handleUserInfoDelete = functions.firestore
    .document('userInfo/{userinfouid}')
    .onDelete(async (snapshot, context) => {

        // get ratedItems array
        // for each menuItemId
        // --> find rating document with userUid and menuItemId
        //     delete each rating
        //     --> triggers handleRatingDelete

        const ratingsRef = db.collection('ratings');

        const ratedItems = snapshot.data().ratedItems;

        for (const menuItemId of ratedItems) {
            await db.runTransaction(async (transaction) => {
                const ratingQuerySnapshot = await ratingsRef
                    .where('userUid', '==', snapshot.id)
                    .where('menuItemId', '==', menuItemId)
                    .get();

                for (const doc of ratingQuerySnapshot.docs) {
                    transaction.delete(doc.ref);
                }
            });
        }

    });