from PIL import Image, ImageColor, ImageDraw
import pytesseract
import cv2

def start_loc(size):
    match(size):
        case(4):
            return (51, 152)
        case(5):
            return (0, 0)
        case(6):
            return (0, 0)
        
def displacement(size):
    match(size):
        case(4):
            return 54
        case(5):
            return 0
        case(6):
            return 0

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
    if x > 0 and not marker[y][x - 1] and image.getpixel((start_loc(4)[0] + x * displacement(size), start_loc(4)[1] + y * displacement(size) + 20)) != black:
        separate(x - 1, y, size, image, marker, group)
    if y > 0 and not marker[y - 1][x] and image.getpixel((start_loc(4)[0] + x * displacement(size) + 20, start_loc(4)[1] + y * displacement(size))) != black:
        separate(x, y - 1, size, image, marker, group)
    if x < size - 1 and not marker[y][x + 1] and image.getpixel((start_loc(4)[0] + (x + 1) * displacement(size), start_loc(4)[1] + y * displacement(size) + 20)) != black:
        separate(x + 1, y, size, image, marker, group)
    if y < size - 1 and not marker[y + 1][x] and image.getpixel((start_loc(4)[0] + x * displacement(size) + 20, start_loc(4)[1] + (y + 1) * displacement(size))) != black:
        separate(x, y + 1, size, image, marker, group)

def detect_rule(group, image_path):
    config = r'tessedit_char_whitelist=1234567890+-x/'
    
    for cell in group:
        loc = (start_loc(4)[0] + cell[0] * displacement(size), start_loc(4)[1] + cell[1] * displacement(size))
        # target_field = image[loc[1]+5:loc[1]-5 + displacement(size), loc[0]+10:loc[0]+10 + displacement(size)]
        result = pytesseract.image_to_string(image_path, config=config)
        # result = reader.readtext(image, allowlist="1234567890+-x/", threshold=0.0, text_threshold=0.0)
        print(result)
        
        # i_pil = Image.open(image_path)
        # draw = ImageDraw.Draw(i_pil)
        # for i in result:
        #     draw.rectangle([tuple(i[0][0]), tuple(i[0][2])], fill=None, outline = 'red', width = 2)
        # i_pil.show()
        
def to_json(path, description):
    ...

if __name__ == "__main__":
    size = 4
    vol = 1
    difficulty = 0
    book = 1
    
    image_path = f"./image/size{size}/vol{vol}/{difficulty_mark(difficulty)}/book{book}/0.png"
    image = Image.open(image_path, mode="r")
    
    marker = []
    for i in range(size):
        marker.append([False, False, False, False])
    groups = []
    for y in range(size):
        for x in range(size):
            if not marker[y][x]:
                group = []
                separate(x, y, size, image, marker, group)
                groups.append(group)
    print(groups)
    
    result = detect_rule(groups[0], image_path)
    
    
    