import numpy as np
import pandas as pd
import re
import xlsxwriter 
import os
import sys
from pylab import *
import csv
import glob




def extractTFBS(dirPath, samplefile, motif_super_directory, out_file_name):
	motif_file=pd.read_csv(dirPath+"/"+samplefile, sep='\t', header=0)
	motif_subset=motif_file[['Motif Name', 'q-value (Benjamini)']]
	motif_subset=motif_subset[motif_subset['q-value (Benjamini)'].map(lambda x: x<=0.05)]
	motif_subset['TF']=motif_subset['Motif Name'].str.split('\(').str.get(0)
	motif_subset['TF_type']=motif_subset['Motif Name'].str.split(r"\(([A-Za-z0-9_]+)\)").str.get(1)
	print(motif_subset)
	if(motif_subset.empty==True):
		print(dirPath+"/"+samplefile+" was empty!")
		next
	else:
		print("printing", out_file_name)
		motif_subset.to_csv(motif_super_directory+out_file_name, sep="\t", header=True, index=False)



def main(argv):
	if len(argv) != 3:
		usage(argv)
		sys.exit(0)
		
	motif_super_directory = argv[1]
	samplefile = argv[2]
	text_file=open(motif_super_directory + "NoEnrichmentDetected.txt", "w")
	text_file.write("These samples didn't have TFBS with q-value <=0.05\n")
	
	#Cycle through the files in the subdirectories
	for sample in glob.glob(motif_super_directory+"*/"+samplefile, recursive=True):
#		print(os.path.dirname(sample), "\t", samplefile)
		if samplefile in os.path.basename(sample):
#			print("working on ", os.path, sample)
			dirPath=os.path.dirname(sample)
			out_file_name=os.path.basename(dirPath)+"-TFtable.txt"
			extractTFBS(dirPath, samplefile, motif_super_directory, out_file_name)
		else:
			next
	text_file.close()
	print("done done!~")
	

def usage(argv):
	print("Enter super_directory and filename to search for \n")
	print("arg 1 is: ",argv[1])
	print("arg 2 is: ",argv[2])
	print("this is what I saw")



if __name__ == "__main__":
	main(sys.argv)











