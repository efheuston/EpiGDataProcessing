import numpy as np
import pandas as pd
import re
import xlsxwriter 
import os
import sys
from pylab import *
import csv




def appender2(correltab_variable, sampletab_subset, sample_variable, unique_chromName):
	correltab_subset=pd.DataFrame(correltab_variable[correltab_variable['chrom'].str.strip()==unique_chromName])
	chrom_offset = correltab_subset.index.values.min()
	correltab_subset.dropna(inplace=True)
	if(correltab_subset.empty==True):
		next
	else:
		# samplepos = np.searchsorted(correltab_subset.ix[:,1], sampletab_subset.ix[:,1], side='left')+chrom_offset
#        correltab_variable.set_value(samplepos, sample_variable, sampletab_subset.ix[:,5])
		# correltab_variable.ix(samplepos,sample_variable)=sample_variable.ix[:,5]
		for indvar, row in sampletab_subset.iterrows():
			correltab_index = np.searchsorted(correltab_subset.ix[:,1], sampletab_subset.ix[indvar,1], side='right')+chrom_offset-1
			
			pk_score = sampletab_subset.ix[indvar,'adjustedPeakScore']
			# print("correltab_index is: ", correltab_index, " and pk_score is: ", pk_score)
			# print("correltab_index is ",correltab_index, "; sample index is ", index, "; peak score is ",pk_score)
			correltab_variable.set_value(correltab_index, sample_variable, pk_score)


	# for index in range(len(samplepos)):
	# 	position=samplepos[index]
	# 	print(position)
	# 	print(sample_variable)
	# 	print(sampletab_subset.ix[index,'adjustedPeakScore'])
	# 	correltab_variable.set_value(position, sample_variable, sampletab_subset.ix[index,'adjustedPeakScore'])




def main(argv):
	if len(argv) != 3:
		usage(argv)
		sys.exit(0)
		
	uniontable = argv[1]
	samplefile = argv[2]

	uniontab = pd.read_table(uniontable, header=None)
	correltab = uniontab.copy()
	correltab.columns=['chrom', 'start', 'stop']
	
	
	#Cycle through the bed files in the directory
	for sample in os.listdir(samplefile):
		if sample.endswith(".bed"):
#			print(os.path.basename(uniontable))
			if sample == os.path.basename(uniontable):
				pass
	
			else:
				sampletab=pd.read_table(os.path.join(samplefile,sample), header=None)
				print("working on ", sample)
				sampletab.columns=['chrom', 'start', 'stop', 'rawscore', 'adjustedPeakScore']
				# print(sample)
				correltab[sample] = ""
				
				sample_chrom = sampletab['chrom'].unique()
				
				for unique_chromosome in sample_chrom:
					sampletab_subset = pd.DataFrame(sampletab[sampletab['chrom'].str.strip()==unique_chromosome]).dropna()
					appender2(correltab,sampletab_subset, sample, unique_chromosome)
	# print (correltab)


	correltab.to_csv(samplefile+"CorrelationTable.txt", sep="\t", index=False)
	print("done done!~")

def usage(argv):
	print("Enter MergedPeakFile and directory containing bed files \n")
	print("arg 0 is: ",argv[1])
	print("arg 1 is: ",argv[2])
	print("this is what I saw")



if __name__ == "__main__":
	main(sys.argv)











