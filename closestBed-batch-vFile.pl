use strict;

my $dir = shift or die "Usage: <PeakDir> <OutputDir> <reference file> <options>\n";
my $outdir = shift or die "Usage: <PeakDir> <OutputDir> <reference file> <options>\n";
my $referencefile = shift or die "Usage: <PeakDir> <OutputDir> <reference file> <options>\n";
my $options = join(" ", @ARGV);

print $options."\n";
opendir(DIR, $dir);

while (my $file = readdir (DIR))
{
	if ($file =~ /\.bed$/)
	{
	print "My reference file = $referencefile\n";
	$referencefile =~ /([\w\.\-]+)$/;
	my $ref = $1;
	my $filename = $file;
	$filename =~ s/\.bed$//;
	$filename =~ $filename."\-".$ref;
#	$filename =~ s/\-MultiIntersectBed-1width_Unique.bed//g;
#	$filename =~ s/\-IntersectV-1width_Unique.bed//g;
#	$filename =~ s/EBMeg-//g;
#	$filename =~ s/\.bed-ChIPFile.bed//g;
#	$filename =~ s/\-EBMeglncRNA/lncRNA/g;
#	$filename =~ s/\.bed$//;
	my $outfile = $filename.'-UnqClstRaw.txt';
	print "Building ".$outfile."\n";
	my $cmd = 'bedtools closest '.$options.' -a '.$dir.$file.' -b '.$referencefile.' > '.$outdir.$outfile;
	print `$cmd`;
#	print $cmd."\n";
	}
}
close DIR;



print "\n\tMight I suggest running CleanUpClosestBed.pl next?\n";




exit;
