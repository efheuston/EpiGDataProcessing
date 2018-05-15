use strict;

my $dir = shift or die "Usage: <PeakDir> <OutputDir> <genome file> <options>\n";
my $outdir = shift or die "Usage: <PeakDir> <OutputDir> <genome file> <options>\n";
my $genome = shift or die;
my $new_suffix = shift or die; 
my $options = join(" ", @ARGV);

print $options."\n";
opendir(DIR, $dir);

while (my $file = readdir (DIR))
{
	if ($file =~ /\.bed$/)
	{
		my $filename = $file;
		$filename =~ s/\.bed$/$new_suffix."bed"/;
		print "Building ".$filename."\n";
		my $cmd = 'bedtools shuffle '.$options.' -i '.$dir.$file.' -g '.$genome.' > '.$outdir.$filename;
		print `$cmd`;
	}
}
close DIR;



print "\n\tDone done~!\n";




exit;
