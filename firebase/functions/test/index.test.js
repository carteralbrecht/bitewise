// START with: yarn firebase emulators:exec "yarn test --exit"

const assert = require("assert");
const firebase = require("@firebase/testing");

const projectId = "bitewwisemaybelol";
const admin = firebase.initializeAdminApp({ projectId });
const db = admin.firestore();

const sleep = (milli) => new Promise((res) => setTimeout(res, milli));

describe('Unit Tests', () => {

    beforeEach(async () => {
        await firebase.clearFirestoreData({ projectId });
        console.log("Cleared Firestore Data");
    });

    it("Tests adding a rating", async () => {
        const TIMESTAMP = new Date().toISOString();
        const FAKE_MENU_ITEM_ID = "item-" + TIMESTAMP;
        const FAKE_RATING_VAL = 5;
        const FAKE_USER_ID = "uid-" + TIMESTAMP;

        // add a fake userInfo to the db
        console.log(`Adding userInfo doc for user ${FAKE_USER_ID}`);
        const fakeUserInfoRef = db.collection("userInfo").doc(FAKE_USER_ID);
        await fakeUserInfoRef.set({
            ratedItems: []
        })

        // add a rating doc to the db
        console.log(`Adding a rating doc for item ${FAKE_MENU_ITEM_ID}`);
        await db.collection("ratings").add({
            rating: FAKE_RATING_VAL,
            menuItemId: FAKE_MENU_ITEM_ID,
            userUid: FAKE_USER_ID
        });

        // wait for CF to execute
        console.log("Sleeping for cloud functions to execute...");
        await sleep(10000);

        const userInfoSnapshot = await fakeUserInfoRef.get();
        assert.deepStrictEqual(userInfoSnapshot.data().ratedItems.includes(FAKE_MENU_ITEM_ID), true, "Added to userInfo ratedItems");

        const menuItemRef = db.collection('menuitems').doc(FAKE_MENU_ITEM_ID);
        const menuItemSnapshot = await menuItemRef.get();
        assert.deepStrictEqual(menuItemSnapshot.data().numRatings, 1, "Correct Num Ratings");
        assert.deepStrictEqual(menuItemSnapshot.data().avgRating, FAKE_RATING_VAL, "Correct Avg Rating");

    }).timeout(20000);
})