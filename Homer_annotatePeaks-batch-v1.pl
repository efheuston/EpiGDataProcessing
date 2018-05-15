use strict;

my $indir = shift or die "Usage: <INdir> <OUTDIR><genome (i.e., mm9)>\n";
my $outdir = shift or die "Usage: <INdir> <OUTDIR><genome (i.e., mm9)>\n";
my $genome = shift or die "Usage: <INdir> <OUTDIR><genome (i.e., mm9)>\n";

opendir(DIR, $indir);

while (my $file = readdir(DIR))
{
	if ($file =~ /\.bed$/)
	{
		my $folder = $file;
		my $annstats = $file;
		my $motifBed = $file;
		$folder =~ s/\.bed$/-HOMER.txt/;
		$annstats =~ s/\.bed$/-HOMERannStats.txt/;
		$motifBed=~s/\.bed$/-HOMERmotifs.bed/;
		my $cmd = 'annotatePeaks.pl '.$indir.$file.' '.$genome.' -hist 10 -annStats '.$outdir.$annstats. ' -m SigTFMotifs_toLookFor.txt -mbed '.$outdir.$motifBed.'>'.$outdir.$folder;

		print "Running $file through HOMER annotatePeaks.pl...\n";

		print $cmd."\n" or die "Cannot process command";
		print `$cmd`  or die "Cannot run command";

		print "Done with $file!\n";
	}
}

print "Done done~!!";


exit;	

