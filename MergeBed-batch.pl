use strict;

my $dir = shift or die "Usage: <PeakDir> <OutputDir> <replace .bed> <options>\n";
my $outdir = shift or die "Usage: <PeakDir> <OutputDir> <replace .bed> <options>\n";
my $rename = shift or die "Usage: <PeakDir> <OutputDir> <replace .bed> <options>\n";
my $options = join(" ", @ARGV);

print $options."\n";
opendir(DIR, $dir);

while (my $file = readdir (DIR))
{
	if ($file =~ /\.bed$/)
	{
	my $filename = $file;
	$filename =~ s/\.bed$/$rename\.bed/;
	print "Building $filename\n";
	my $cmd = 'bedtools merge '.$options.' -i '.$dir.$file.' > '.$outdir.$filename;
	print `$cmd`;
#	print $cmd."\n";
	}
}




print "\n\tMight I suggest running CleanUpClosestBed.pl next?\n";




exit;
