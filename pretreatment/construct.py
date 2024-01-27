from PIL import Image, ImageColor, ImageDraw
import pytesseract
import re
import json
import os

def start_loc(size):
    match(size):
        case(4):
            return (51, 152)
        case(5):
            return (52, 152)
        case(6):
            return (51, 152)
        
def displacement(size):
    match(size):
        case(4):
            return 54
        case(5):
            return 43
        case(6):
            return 36

def difficulty_mark(d):
    match(d):
        case (0):
            return "KX"
        case (1):
            return "E"
        case (2):
            return "M"
        case (3):
            return "H"
        case (4):
            return "X"
        
def separate(x, y, size, image, marker, group):
    group.append((x, y))
    marker[y][x] = True
    black = ImageColor.getrgb("#000000")
    if x > 0 and not marker[y][x - 1] and image.getpixel((start_loc(size)[0] + x * displacement(size), start_loc(size)[1] + y * displacement(size) + 10)) != black:
        separate(x - 1, y, size, image, marker, group)
    if y > 0 and not marker[y - 1][x] and image.getpixel((start_loc(size)[0] + x * displacement(size) + 10, start_loc(size)[1] + y * displacement(size))) != black:
        separate(x, y - 1, size, image, marker, group)
    if x < size - 1 and not marker[y][x + 1] and image.getpixel((start_loc(size)[0] + (x + 1) * displacement(size), start_loc(size)[1] + y * displacement(size) + 10)) != black:    
        separate(x + 1, y, size, image, marker, group)
    if y < size - 1 and not marker[y + 1][x] and image.getpixel((start_loc(size)[0] + x * displacement(size) + 10, start_loc(size)[1] + (y + 1) * displacement(size))) != black:
        separate(x, y + 1, size, image, marker, group)

def detect_rule(group, image_path):
    config = r'--psm 10'
    image = Image.open(image_path)
    
    for cell in group:
        loc = (start_loc(4)[0] + cell[0] * displacement(size), start_loc(4)[1] + cell[1] * displacement(size))
        target_field = image.crop((loc[0] + 3, loc[1] + 3, loc[0] + displacement(size) - 5, loc[1] + 2 * displacement(size) / 5))
        # target_field.show()
        result = pytesseract.image_to_string(target_field, config=config)
        result = result.strip()
        result = result.replace(" ", "")
        if re.match("\d+[\+\-x\/]", result):
            return {"target": int(result[0:len(result) - 1]), "calculation": result[len(result) - 1] if result[len(result) - 1] != "x" else "*", "cells": group}
        
def to_json(dir_path, json_name, rules):
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
    json_path = dir_path + "/" + json_name
    with open(json_path, "w", encoding = "utf-8") as json_file:
        json.dump(rules, json_file, indent=2)

if __name__ == "__main__":
    s_size = 5
    s_vol = 1
    s_difficulty = 0
    s_book = 2
    for size in range(4, 7):
        for vol in range(1, 21):
            for difficulty in range(5):
                for book in range(1, 21):
                    if (size, vol, difficulty, book) < (s_size, s_vol, s_difficulty, s_book):
                        continue
                    
                    image_path = f"./image/size{size}/vol{vol}/{difficulty_mark(difficulty)}/book{book}/0.png"
                    try:
                        image = Image.open(image_path, mode="r")
                    except:
                        continue
                                    
                    marker = []
                    for i in range(size):
                        line = []
                        for j in range(size):
                            line.append(False)
                        marker.append(line)
                    groups = []
                    for y in range(size):
                        for x in range(size):
                            if not marker[y][x]:
                                group = []
                                separate(x, y, size, image, marker, group)
                                groups.append(group)
                    print(groups)
                    
                    rules = []
                    for group in groups:
                        rule = detect_rule(group, image_path)
                        rules.append(rule)
                    
                    json_path = f"./rule/size{size}/vol{vol}/{difficulty_mark(difficulty)}"
                    json_name = f"book{book}.json"
                    to_json(json_path, json_name, rules)
                    exit()