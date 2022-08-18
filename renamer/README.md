# renamer

Application to rename groups (3) of images and adding a incremental value.

From:
```
./images
    |
    \_ 'Screenshot 2021-01-23 at 11.34.50.jpeg'
    \_ 'Screenshot 2021-01-23 at 11.35.34.jpeg'
    \_ 'Screenshot 2021-01-23 at 11.36.03.jpeg'
```

To:
```
./output
    |
    \_ 123_0.jpeg
    \_ 123_1.jpeg
    \_ 123_2.jpeg
```

## Usage

1. install requierements: python -m pip install -r requirements.txt
1. Ensure images are named in an alphabetical order.
1. Place images in the `./images` directory.
1. Run `FLASK_ENV=development flask run -h 0.0.0.0 -p 5000`
1. Open `http://localhost:5000`
1. Renamed images will be in the `./output` directory.
