use strict;

my $file = shift or die "Usage: <Input File><Output File Name>\n";
#my $outputFile = shift or die "Usage: <Input File><Output File Name, ie \"Ery-Len23.txt\">\n";
chomp($file);

#print $file ."\n";
$file =~ /^([\w\.\-\_\/]+\/)[\w\.\-\_]+\.txt$/;
my $dir = $1;
#print "my dir is :   ".$1."\n\n";

open(FILE, $file) or die "Can't open $file\n";

while (my $line = <FILE>)
{
	chomp($line);
	$line =~ s/[:\-]/\t/g;m
	my @array = split(/\t/, $line);
	my $seqid = $array[0].":". $array[1]."-". $array[2];
	my $seqtempl = $array[3];
#	my $prmrleft =  $array[4];
#	my $prmrright =  $array[5];
	
	
	open (OUT, "> ".$dir."primer3Temp.txt") or die "Can't open temp file \n";
	print OUT "SEQUENCE_ID=$seqid\nSEQUENCE_TEMPLATE=$seqtempl\nPRIMER_TASK=generic\nPRIMER_PICK_LEFT_PRIMER=1\nPRIMER_PICK_INTERNAL_OLIGO=0\nPRIMER_PICK_RIGHT_PRIMER=1\nPRIMER_OPT_SIZE=23\nPRIMER_MIN_SIZE=21\nPRIMER_MAX_SIZE=25\nPRIMER_MAX_NS_ACCEPTED=1\nPRIMER_PRODUCT_SIZE_RANGE=75-200\nP3_FILE_FLAG=1\nPRIMER_EXPLAIN_FLAG=1\nPRIMER_THERMODYNAMIC_PARAMETERS_PATH=/usr/local/bin/primer3-2.3.7/src/\nP3_FILE_FLAG=0\n=";
	close OUT;
	
	my $cmd = "primer3_core -format_output < ".$dir."primer3Temp.txt";
	print `$cmd`;
	my $cleancmd = "rm ".$dir."primer3Temp.txt";
	#print `$cleancmd`;
	}
#print "You probably want to run Primer3-CleanupOutput.pl\n";
#
##PRIMER_PAIR_NUM_RETURNED=1


#primer3_core [ -format_output ] [ -default_version=1|-default_version=2 ] [ -io_version=4 ] [ -p3_settings_file=<file_path> ] [ -echo_settings_file ] [ -strict_tags ] [ -output=<file_path> ] [ -error=<file_path> ] [ input_file ] 






exit;