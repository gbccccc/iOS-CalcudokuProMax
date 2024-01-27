import os
import fitz
import requests

def download_pdf(url, save_path):
    print(url)
    response = requests.get(url)
    with open(save_path, 'wb') as f:
        f.write(response.content)

def convert(pdfPath, path):
    doc = fitz.open(pdfPath)
    if not os.path.exists(path):
        os.makedirs(path)
    with open(path + "/size.txt", 'w') as f:
        f.write(str(doc.page_count - 1))
    for i in range(doc.page_count - 1):
        page = doc.load_page(i)  # number of page
        pix = page.get_pixmap()
        pix.save(path + f"/{i}.png")
    doc.close()

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

if __name__ == "__main__":
    s_size = 4
    s_vol = 13
    s_difficulty = 1
    s_book = 2
    for size in range(4, 7):
        for vol in range(1, 21):
            for difficulty in range(5):
                for book in range(1, 101):
                    if (size, vol, difficulty, book) < (s_size, s_vol, s_difficulty, s_book):
                        continue
                    name = f"INKY{f'_v{vol}' if vol != 1 else ''}_{size}{difficulty_mark(difficulty)}_b{'%03d'% book}_4pp"
                    download_pdf(f"https://files.krazydad.com/inkies/sfiles/{name}.pdf", "./output/temp.pdf")
                    convert("./output/temp.pdf", f"./image/size{size}/vol{vol}/{difficulty_mark(difficulty)}/book{book}")