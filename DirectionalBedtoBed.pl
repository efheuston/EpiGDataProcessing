use strict;



my $indir = shift or die "Usage: <dir in> <dir out>\n\t**Important!: Indir and Outdir must be different!\n";
my $outdir = shift or die "Usage: <dir in> <dir out>\n\t**Important!: Indir and Outdir must be different!\n";
chomp($outdir);


opendir (DIR, $indir) or die "Can't open $indir\n";

while (my $file = readdir(DIR))
{
	if($file =~ /\.bed$/)
	{
		open (OUT, "> ".$outdir.$file) or die "Can't open new file\n";
		open(FILE, $indir.$file) or die "Can't open $file\n";
		while(my $row = <FILE>)
		{
			chomp($row);
			my @line = split(/\t/, $row);
			if($line[1] > $line[2])
			{
				print OUT $line[0]."\t".$line[2]."\t".$line[1]."\n";
			}
			else
			{
				print OUT $line[0]."\t".$line[1]."\t".$line[2]."\n";
			}
		}
		close OUT;
		close FILE;
	}
}
close DIR;

print "Done done~!\n\n";



exit;