from google.cloud import firestore
import http.client
import json
import geohash
from dotenv import load_dotenv
import os

load_dotenv()
API_KEY = os.getenv("API_KEY")
API_HOST = os.getenv("API_HOST")

# Must have GOOGLE_APPLICATION_CREDENTIALS env variable set
# https://googleapis.dev/python/google-api-core/latest/auth.html
db = firestore.Client()

# Connection to API Host
conn = http.client.HTTPSConnection(API_HOST)


# menu items for a restaurant, by result page
def get_menu_items(restaurant_id, page):
    url = "/restaurant/{}/menuitems?page={}".format(restaurant_id, page)
    conn.request("GET", url, headers={
        'x-rapidapi-host': API_HOST,
        'x-rapidapi-key': API_KEY
    })

    # return dict from json
    response = conn.getresponse()
    return json.loads(response.read().decode("utf-8"))["result"]


# restaurant get by lat,lon,distance, by result page
def get_restaurants_by_geo(lat, lon, distance, page):

    # make the request
    url = "/restaurants/search/geo?page={}&lon={}&lat={}&distance={}".format(page, lon, lat, distance)
    conn.request("GET", url, headers={
        'x-rapidapi-host': API_HOST,
        'x-rapidapi-key': API_KEY
    })

    # return dict from json
    response = conn.getresponse()
    return json.loads(response.read().decode("utf-8"))["result"]


# Create/Update a restaurant document in the restaurants collection
def create_restaurant_doc(restaurant):
    doc_ref = db.collection('restaurants').document(str(restaurant["restaurant_id"]))
    doc_ref.set({
        "restaurant_name": restaurant["restaurant_name"],
        "coordinates": restaurant["geo"],
        "geohash": str(geohash.encode(restaurant["geo"]["lat"], restaurant["geo"]["lon"], 15)),
        "restaurant_phone": restaurant["restaurant_phone"],
        "address": restaurant["address"]
    })


# Create/Update a menu item document in the menuitems collection
def create_menu_item_doc(menu_item):
    doc_ref = db.collection('menuitems').document(str(menu_item["item_id"]))
    doc_ref.set({
        "menu_item_name": menu_item["menu_item_name"],
        "menu_item_description": menu_item["menu_item_description"],
        "menu_item_subsection": menu_item["subsection"],
        "restaurant_id": menu_item["restaurant_id"],
        "restaurant_name": menu_item["restaurant_name"],
        "coordinates": menu_item["geo"],
        "geohash": str(geohash.encode(menu_item["geo"]["lat"], menu_item["geo"]["lon"], 15)),
    })


# return all the pages of results for this restaurant query
def get_all_restaurant_pages(lat, lon, distance):
    pages = []
    page = 1

    # get page, check if still more pages to get
    while True:
        current_page = get_restaurants_by_geo(lat, lon, distance, page)
        pages.append(current_page)
        page += 1

        if not current_page["morePages"]:
            break

    return pages


# get all the pages of results for menu items
def get_all_items(restaurant_id):
    pages = []
    page = 1

    # get page, check if still more pages to get
    while True:
        current_page = get_menu_items(restaurant_id, page)
        pages.append(current_page)
        page += 1

        if not current_page["morePages"]:
            break

    return pages


# makes menu item documents for each item at a restaurant
def create_menu_item_docs(restaurant):
    # get all the pages of items by restaurant id
    item_pages = get_all_items(restaurant["restaurant_id"])

    # create a document for each menu item at that restaurant
    for item_page in item_pages:
        for item in item_page["data"]:
            create_menu_item_doc(item)


def main():

    # 1 mile from UCF
    lat = 28.600348
    lon = -81.200632
    distance = 1

    # Get all the restaurants across multiple pages of results
    restaurant_pages = get_all_restaurant_pages(lat, lon, distance)

    for restaurant_page in restaurant_pages:
        for restaurant in restaurant_page["data"]:
            create_restaurant_doc(restaurant)
            create_menu_item_docs(restaurant)


if __name__ == "__main__":
    main()
