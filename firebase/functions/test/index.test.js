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
    });

    async function snooz(time = 3000) {
        return new Promise(resolve => {
            setTimeout(e => {
                resolve();
            }, time);
        });
    }

    it("Tests handleRatingsCreate", async () => {
        const FAKE_USER_ID = "user123";
        const FAKE_MENU_ITEM_ID = "item123";
        const FAKE_RATING_VAL = 5;

        // add a fake userInfo to the db
        const fakeUserInfoRef = db.collection("userInfo").doc(FAKE_USER_ID);
        await fakeUserInfoRef.set({
            ratedItems: []
        })

        // add a rating doc to the db
        await db.collection("ratings").add({
            rating: FAKE_RATING_VAL,
            menuItemId: FAKE_MENU_ITEM_ID,
            userUid: FAKE_USER_ID
        });

        // wait for CF to execute
        await sleep(5000);


        await fakeUserInfoRef.get().then(snapshot => {
            assert.deepStrictEqual(snapshot.data().ratedItems.includes(FAKE_MENU_ITEM_ID), true, "Added to userInfo ratedItems");
        });

        const menuItemRef = db.collection('menuitems').doc(FAKE_MENU_ITEM_ID);
        await menuItemRef.get().then(snapshot => {
            assert.deepStrictEqual(snapshot.data().numRatings, 1, "Correct Num Ratings");
            assert.deepStrictEqual(snapshot.data().avgRating, FAKE_RATING_VAL, "Correct Avg Rating");
        });

    }).timeout(10000);
})