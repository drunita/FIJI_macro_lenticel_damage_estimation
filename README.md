# Lenticelosis severity measurement

## Description


FIJI:


The files in this folder are intended to measure the severity of the 
lenticelosis in avocado.


The headless Fiji macros are: macro_elbody.ijm and macro_laheadlesshead.ijm

They must be run in the terminal as follow:


druwork:Lenticelosis druna$ /Volumes/hd/Applications/Fiji.app/Contents/MacOS/ImageJ-macosx --headless -macro macro_laheadlesshead.ijm  ./datasets/aguacate

Note: ./datasets/aguacate == is the parameter and is the path to the Folder were the images to analyzeze are saved. note that the folder in in the lentiselosis folder were the macros are

The macro_laheadlesshead.ijm macro calls the macro_elbody.ijm macro.

Images showing the lenticelosis masks) and 2 .cvs files (a file containing the area of the avocado and a file with each individual lentcelosis spot area) that are used latter by a the Python script to compute the severity 

PYTHON:
 The severity_lenticelosis.py is a Python script that Calculates the severity of lenticelosis using the two .cvs output files from the Fiji macros and returns a csv file with the calculations for each images. 

It must be run in the terminal as follow:

(base) druwork:~ druna$ python severity_lenticelosis.py datasets/aguacate  

Note: datasets/avocado_1 is the path were the image that is needed to annalyse is. The image must be called imagen.jpg and is where the csv file are sabes

SCRIPT:

The file Makefile is a file that integrantes the Fiji macro and the Python script and must be run in the terminal as: 

make DIR=datasets/aguacate

This file also cleans all the not needed files.