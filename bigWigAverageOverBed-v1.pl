use strict;


my $merge = shift or die "Usage: <dir/MergeFile.bed4> <Sample dir with .bw files> <outdir>\n";
my $dir = shift or die "Usage: <MergeFile.bed4> <Sample dir with .bw files> <outdir>\n";
my $outdir = shift or die "Usage: <MergeFile.bed4> <Sample dir with .bw files> <outdir>\n";

opendir (DIR, $dir);

while (my $file = readdir(DIR))
{
	if ($file =~ /\.bw$/)
	{
		print "I see $file\n";
		my $newfile = $file;
		$newfile =~ s/\.bw//;
		my $cmd = 'bigWigAverageOverBed -bedOut='.$outdir.$newfile.'.bed '.$dir.$file.' '.$merge.' '.$outdir.$newfile.'.tab';
		print "\n$cmd\n";
		system ($cmd);
	}
}
close DIR;

print"done done!~\n";


exit;
