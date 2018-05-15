use strict;

my $dir = shift or die "Usage: <indir> <outdir>\n";
my $outdir = shift or die "Usage: <indir> <outdir>\n";


opendir (DIR, $dir);

while (my $file = readdir(DIR))
{
	if ($file =~ /\.bed$/ || $file =~ /\.narrowPeak/)
	{
		my $cmd = 'sortBed -i '.$dir.$file.' > '.$outdir.$file;
		print "\n\tsorting $cmd and exporting to $outdir\n";
		system ($cmd);
	}
}
close DIR;




exit;
