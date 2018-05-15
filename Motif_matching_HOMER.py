import numpy as np
import pandas as pd
import csv
import os
import re
import sys

class My_class:
	input_dir=""
	matrix_file=""


def extract_relevent_TF_columns(matrix_file, tf_col, maximum_column_count):
	# print ("looking at ", tf_col, "\n")
	if tf_col < maximum_column_count:
		TF_matrix=matrix_file[[0,1,2,tf_col]].copy()
		column_title=TF_matrix[[3]].columns.to_series()
		my_tf=column_title.str.extract('([\w\-\.\_]+)\(').iloc[0]
		# print ("I've reached ", my_tf," at ", tf_col,"\n")
		tf_export_table=TF_matrix.dropna()
		return(my_tf, tf_export_table)
	else:
		print("done done~!")



def main (argv):
	if len(argv)!=2:
		usage(argv)
		sys.exit(0)

	input_dir=argv[1]


	for input_matrix_file in os.listdir(input_dir):
		if input_matrix_file.endswith(".txt"):
			if input_matrix_file.startswith("."):
				pass
			else:
				tf_col=20
				matrix_file= pd.read_table(os.path.join(input_dir, input_matrix_file), sep="\t", index_col=0, header=0)
				print("Working on ", input_matrix_file)
				maximum_column_count=len(matrix_file.columns)
				
				while tf_col<= (maximum_column_count-1):
					my_tf, tf_export_table=extract_relevent_TF_columns(matrix_file, tf_col, maximum_column_count)
					# print(my_tf,"\n")
					if my_tf=="":
						break
					else:
						file_name=input_matrix_file.replace('MOTIFs.txt', my_tf+".bed")
						print("\tcreating "+file_name+"\n")
						tf_export_table.to_csv(os.path.join(input_dir, file_name), sep="\t", header=False, index=False)
						tf_col = (tf_col+1)





					# if tf_col>maximum_column_count:
					# 	print(tf_col," reached ", maximum_column_count,". Moving on\n")
					# 	pass
					# else:
					# 	print(tf_col, " ",maximum_column_count, "\n")
					# 	tf_col=(tf_col+1)




    
def usage(argv):
	# print(len(argv))
	print("Enter directory with input files\n\t\t**Assuming first TF column is Column 21 (zero-based)**\nWorks with output from annotatePeaks.py \(HOMER\)")


if __name__=="__main__":
    main(sys.argv)

