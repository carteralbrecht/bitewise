const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { debug } = require('firebase-functions/lib/logger');

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


// On menuItem creation:
// create/update the restauraunt doc for the restaurant that item is from
exports.menuItemRated = functions.firestore
.document('menuitems/{menuitemuid}')
.onCreate(async (snapshot, context) => {

        // Get the avg rating from this menu item and its docId
        const aRate = snapshot.data().avgRating;
        const iId = snapshot.id;
        // Get a reference to the restaurant item
        const restaurantRef = db.collection('restaurants').doc(snapshot.data().restaurantId);

        await db.runTransaction(async transaction => {

                let ratedItemList = [];
                // Make the new or updated menuItem map to be added to the restaurant page 
                const newItem = {avgRating : aRate, itemId : snapshot.id};

                // if the menu item doc already exists then use get the current list
                await transaction.get(restaurantRef).then(doc => {
                    if (doc.exists) {
                        ratedItemList = doc.data().ratedItems;
                    }
                });

                // If the restaurants list is empty, just add this menu item to it
                // Otherwise, insert into the restaurants list, but keep items in order of highest rated to lowest
                const listLen = ratedItemList.length;
                var i = 0;
                if(listLen == 0)
                {
                    ratedItemList[0] = newItem;
                }
                else
                {
                    // TODO: make more efficient (?)
                    for(i = 0; i < listLen; i++)
                    {
                        var currItem = ratedItemList[i];
                        if(currItem["avgRating"] <= aRate)
                        {
                            ratedItemList.splice(i, 0, newItem);
                            break;
                        }
                    }
                    if(i == listLen)
                    {
                        ratedItemList[listLen] = newItem;
                    }
                }
                
                // Update the menu item document
                const ratedArray = ratedItemList;
                await db.runTransaction(async (transaction) => {
                    transaction.set(restaurantRef, {
                        ratedItems: ratedArray,
                    })
                });
            }
        );
});

// On menuItem update:
// update the restauraunt doc for the restaurant that item is from
exports.menuItemUpdated = functions.firestore
.document('menuitems/{menuitemuid}')
.onUpdate(async (snapshot, context) => {

        // console.log("menuItem updated!");
        // Get the avg rating from this menu item and its docId
        const aRate = snapshot.after.data().avgRating;
        const iId = snapshot.after.id;
        // Get a reference to the restaurant item
        const restaurantRef = db.collection('restaurants').doc(snapshot.after.data().restaurantId);

        console.log(aRate);
        await db.runTransaction(async transaction => {

                let ratedItemList = null;
                // Make the updated menuItem map to be added to the restaurant page 
                const updateItem = {avgRating : aRate, itemId : iId};
                // console.log(updateItem);

                // if the menu item doc already exists then use get the current list
                await transaction.get(restaurantRef).then(doc => {
                    if (doc.exists) {
                        ratedItemList = doc.data().ratedItems;
                    }
                });

                if(ratedItemList == null) {
                    throw "Menu item updated, bet restaurant doc for item dne";
                }

                const listLen = ratedItemList.length;
                var index = 0;
                var i = 0;
                // TODO: make more efficient (?)
                for(index = 0; i < listLen; index++)
                {
                    // console.log("searching...");
                    var currItem = ratedItemList[index];
                    // console.log(currItem["itemId"] );
                    // console.log(iId);
                    if(currItem["itemId"] == iId)
                    {
                        // console.log("found item in list");
                        ratedItemList[index] = updateItem;
                        break;
                    }
                }
                
                // If the items rating is now higher than the item above it
                // move the updated rating up
                while(index > 0 && aRate > ratedItemList[index-1]["avgRating"])
                {
                    // console.log("swap up!");
                    ratedItemList[index] = ratedItemList[index-1];
                    ratedItemList[index-1] = updateItem;
                    index = index-1;
                }

                // If the items rating is now smaller than the item below it
                // move the updated rating down
                while(index < (listLen-1) && aRate < ratedItemList[index+1]["avgRating"])
                {
                    // console.log("swap down!");
                    ratedItemList[index] = ratedItemList[index+1];
                    ratedItemList[index+1] = updateItem;
                    index = index+1;
                }
                
                console.log("updating doc now :)");
                // Update the menu item document
                const ratedArray = ratedItemList;
                await db.runTransaction(async (transaction) => {
                    transaction.set(restaurantRef, {
                        ratedItems: ratedArray,
                    })
                });
            }
        );
});