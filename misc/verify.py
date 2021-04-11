import os
import json
from os.path import expanduser

home = expanduser('~')
items_path = home + '/Downloads/items_v3'
restaurants_path = home + '/Downloads/restaurants_v3'


def get_all_jsons(directory):
    jsons = []

    for file in os.listdir(directory):
        f = open(directory+'/'+file)
        jsonLoaded = json.loads(f.read())
        jsons.append(jsonLoaded)

    return jsons


def delete_all_item_files_from_restaurant(restaurant_id):
    #print("Deleting all item files from restaurant_id: " + str(restaurant_id))

    file_paths_to_delete = []

    # For every single item file that we have
    for item_file in os.listdir(items_path):
        # Read it as json
        item_file_path = str(items_path) + '/' + str(item_file)
        f = open(item_file_path)
        itemJson = json.loads(f.read())

        # If it belongs to this restaurant mark it for deletion
        if itemJson["restaurant_id"] == restaurant_id:
            #print("Marking Item For Deletion: " + str(itemJson["menu_item_name"]))
            file_paths_to_delete.append(item_file_path)

    # Delete all the files marked for deletion
    for x in file_paths_to_delete:
        if os.path.exists(x):
            pass
            #print("Deleting File: " + str(x))
            # os.remove(x)


def delete_restaurant_file(restaurant_id):
    file_path_to_delete = str(restaurants_path) + \
        "/" + str(restaurant_id) + ".json"
    if os.path.exists(file_path_to_delete):
        pass
        # print("Deleting File: " + str(file_path_to_delete))
        # os.remove(file_path_to_delete)

# Delete all files associated with this restaurant json


def purge_restaurant(restaurant_json):
    delete_all_item_files_from_restaurant(restaurant_json["restaurant_id"])
    delete_restaurant_file(restaurant_json["restaurant_id"])


def item_file_exists(item):
    # For every single item file that we have
    for item_file in os.listdir(items_path):
        # Read it as json
        item_file_path = str(items_path) + '/' + str(item_file)
        f = open(item_file_path)
        itemJson = json.loads(f.read())

        # If this item file is the item we are looking for return true
        if itemJson["menu_item_name"] == item["name"]:
            return True

    # We never found it
    print("Never found item with name: " + item["name"])
    return False


def verify_all_items(restaurant_json, item_jsons):
    for menu in restaurant_json["menus"]:
        for section in menu["menu_sections"]:
            for item in section["menu_items"]:
                if not item_file_exists(item):
                    print(
                        "restaurant " + str(restaurant_json["restaurant_id"]) + " FAILED VERIFICATION!")
                    purge_restaurant(restaurant_json)
                    return

    print("restaurant " + str(restaurant_json["restaurant_id"]) + " verified!")
    return True


def check_restaurant_exists(restaurant_id):
    file_path_to_delete = str(restaurants_path) + \
        "/" + str(restaurant_id) + ".json"
    return os.path.exists(file_path_to_delete)


def check_restaurant_has_subsection(restaurant_id, subsection_name):
    f = open(restaurants_path+'/'+str(restaurant_id) + ".json")
    jsonLoaded = json.loads(f.read())
    for menu in jsonLoaded["menus"]:
        for section in menu["menu_sections"]:
            if section["section_name"] == subsection_name:
                #print("found section " + str(subsection_name))
                return True
    return False


def verify_items_have_valid_restaurant(item_jsons, restaurant_jsons):
    count = 0
    for item_json in item_jsons:
        count += 1
        if not check_restaurant_exists(item_json["restaurant_id"]):
            print("restaurant " +
                  str(item_json["restaurant_id"]) + " does not exist")
        if not check_restaurant_has_subsection(item_json["restaurant_id"], item_json["subsection"]):
            print("restaurant " + str(item_json["restaurant_id"]) +
                  " does not have subsection " + str(item_json["subsection"]))

    print(count)


def add_location_field_res(jsons):
    for json_obj in jsons:
        latitude = json_obj["geo"]["lat"]
        longitude = json_obj["geo"]["lon"]
        to_add = {"type": "Point", "coordinates": [longitude, latitude]}
        json_obj["location"] = to_add

        filepath = str(os.path.join(restaurants_path, str(
            json_obj["restaurant_id"]))) + '.json'
        if os.path.exists(filepath):
            print("Deleting: " + filepath)
            os.remove(filepath)

        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(json_obj, f, ensure_ascii=False, indent=4)


def add_location_field_item(jsons):
    for json_obj in jsons:
        latitude = json_obj["geo"]["lat"]
        longitude = json_obj["geo"]["lon"]
        to_add = {"type": "Point", "coordinates": [longitude, latitude]}
        json_obj["location"] = to_add

        filepath = str(os.path.join(
            items_path, str(json_obj["item_id"]))) + '.json'
        if os.path.exists(filepath):
            print("Deleting: " + filepath)
            os.remove(filepath)

        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(json_obj, f, ensure_ascii=False, indent=4)


def main():
    item_jsons = get_all_jsons(items_path)
    restaurant_jsons = get_all_jsons(restaurants_path)

    add_location_field_item(item_jsons)
    add_location_field_res(restaurant_jsons)

    verify_items_have_valid_restaurant(item_jsons, restaurant_jsons)

    for restaurant_json in restaurant_jsons:
        verify_all_items(restaurant_json, item_jsons)


if __name__ == "__main__":
    main()
