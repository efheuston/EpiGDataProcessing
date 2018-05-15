import pandas as pd
import argparse


parser=argparse.ArgumentParser()
parser.parse_args()
parser.add_argument("Input_file", help="File containing attributes")
parser.add_argument("Output_file", help="User-specified name of output file")
parser.add_argument("-s", help=" pandas.to_csv deliminator option (e.g., sep=)")
parser.add_argument("--index", help="pandas.to_csv index-column specification (e.g., index_)")


def main (argv):
	if len(argv)!=3:
		usage(argv)
		sys.exit(0)
	
	join(argv[2])
		attribute_file=pd.read_csv(argv[1], )



def usage(argv):
	print("Enter /dir/input.file and /dir/output.file \n Optional: specify deliminators\n")
	print("Example: Drop_duplicates_in_attribute_file.py ~/protein.links.txt ~/protein.links_nodups.txt sep="\s|\."")
	

	
	
if __name__=="__main__":
	main(sys.argv)
