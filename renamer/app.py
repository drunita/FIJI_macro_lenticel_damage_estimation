# Start in the terminal with: export FLASK_APP=<filename>.py && `flask run`
from flask import Flask, request, render_template, send_file, flash
from os import getenv, listdir, path, getcwd, mkdir, rename
from io import BytesIO
from PIL import Image

app = Flask(__name__)
app.secret_key = b'_5#y2ssbL"F4Q8z\n\xec]/'

BATCH_SIZE = 3
SOURCE_DIR = getenv("IMAGES_SOURCE_DIR", path.join(getcwd(), "images"))
OUTPUT_DIR = getenv("IMAGES_OUTPUT_DIR", path.join(getcwd(), "output"))

assert path.isdir(SOURCE_DIR)
if not path.isdir(OUTPUT_DIR):
    mkdir(OUTPUT_DIR)


@app.route("/")
def index(err=None):
    if err:
        flash(err, "error")

    files = sorted(listdir(SOURCE_DIR))
    files = files[:BATCH_SIZE]

    if len(files) == 0:
        flash("All done!", "info")
        return render_template("index.html", info={}, error=err)

    cwd = getcwd()
    files = list(map(lambda x: path.join(SOURCE_DIR, x), files))
    files = map(lambda x: x[len(cwd) +1 :], files)

    info = {
        "files": list(files),
    }

    return render_template("index.html", info=info, error=err)


@app.route("/images/<path:img>", methods=["GET"])
def serve_img(img):
    image = Image.open(path.join(SOURCE_DIR, img))
    _, ext = path.splitext(img)
    ext = ext[1:]

    ratio = 0.3
    new_image = image.resize(
        (round(image.size[0] * ratio), round(image.size[1] * ratio)), Image.ANTIALIAS
    )

    output = BytesIO()
    _ext = "JPEG" if ext.upper() == "JPG" else ext
    new_image.save(output, format=_ext.upper())
    output.seek(0)

    return send_file(output, mimetype=f"image/{ext.upper()}")


@app.route("/rename", methods=["POST"])
def renamer():
    try:
        new_name_bulk = request.form["new_name"]
        imgs = request.form.getlist("imgs[]")
        _, ext = path.splitext(imgs[0])

        paths = list(map(
            lambda x: path.join(OUTPUT_DIR, f"{new_name_bulk}_{x}{ext}"),
            range(len(imgs)),
        ))

        exist = map(lambda x: path.exists(x), paths)

        if any(exist):
            return index(f"At least one file from {list(paths)} already exists")

        print(imgs)

        for i, img in enumerate(imgs):
        
            to_path = path.join(OUTPUT_DIR, f"{new_name_bulk}_{i}{ext}")
            rename(img, to_path)

    except Exception as e:
        print(e)

    return index()


@app.after_request
def after_request(response):
    print(
        f"{request.remote_addr} {request.method} {request.scheme} {request.full_path} {response.status}"
    )
    return response
