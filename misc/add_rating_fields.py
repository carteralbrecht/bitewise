from google.cloud import firestore
from dotenv import load_dotenv

load_dotenv()

# Must have GOOGLE_APPLICATION_CREDENTIALS env variable set
# https://googleapis.dev/python/google-api-core/latest/auth.html
db = firestore.Client()


def reformat_collection(collection_name):
    docs = db.collection(collection_name).get()
    for doc_snapshot in docs:
        doc_id = doc_snapshot.id
        doc_dict = doc_snapshot.to_dict()
        field_updates = {
            'numRating': 0,
            'avgRating': 0
        }
        doc_ref = db.collection(collection_name).document(doc_id)
        doc_ref.update(field_updates)


def main():
    reformat_collection("menuitems")


if __name__ == "__main__":
    main()
