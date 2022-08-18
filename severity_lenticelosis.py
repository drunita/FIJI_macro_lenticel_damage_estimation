#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug 24 20:16:11 2019

@author: druna
"""
#%%

# para correr: python severity_lenticelosis.py 

import csv
import argparse
import glob
import os

def compute_severity_lenticelosis(f_are_ind,f_are_tot):
    with open(f_are_ind) as csvfile:
        area_ind= csv.reader(csvfile, delimiter=',')
        next(area_ind)    
        area=0
        ct=0
        for row in area_ind:
            ct=ct+1
            area=area+float(row[1])
        #print(area)    
    with open(f_are_tot) as csvfile1:
        area_tot= csv.reader(csvfile1, delimiter=',')        
        next(area_tot)
        for row in area_tot:
            area_t=float(row[1])
        #print(area_t)
    severity=area/area_t*100
    sev="%.2f" %severity

    csvData = [sev,ct]
    return(csvData)

if __name__=="__main__":
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('path', type=str, default="aguacates_1")
    args = parser.parse_args()


#    fieldnames = ['Imagen','Severity (%)', 'Incidence']
#    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
#
#    writer.writeheader()
#    writer.writerow({'first_name': 'Baked', 'last_name': 'Beans'})
#    writer.writerow({'first_name': 'Lovely', 'last_name': 'Spam'})
#    writer.writerow({'first_name': 'Wonderful', 'last_name': 'Spam'})

    with open(args.path + "/output.csv", 'w') as csvFile:
        writer = csv.writer(csvFile)
        writer.writerow(['Imagen','Severity (%)', 'Incidence'])
        
        for f in glob.glob(args.path + "/*.txt"):
            filename = f[:-4]
            f_are_ind = filename + "_areas_ind.csv"
            f_are_tot = filename + "_areas_tot.csv"
        
            if not (os.path.exists(f_are_ind) and os.path.exists(f_are_tot)):
                csvData = [os.path.basename(filename), "##", "##"]
                writer.writerow(csvData)
                continue
    
            csvData = compute_severity_lenticelosis(f_are_ind,f_are_tot)
            writer.writerow([os.path.basename(filename)] + csvData)
    
