use strict;

my $dir = shift or die "Usage: <Input Dir> <Output Dir>\n\t note OUTDIR must be different!\n";
my $outdir = shift or die "Usage: <Input Dir> <Output Dir>\n\t note OUTDIR must be different!\n";


opendir(DIR, $dir);

while (my $file = readdir (DIR))
{
	if ($file =~ /\.txt$/ || $file =~ /\.bed$/)
	{
	my $newfile = $file;
#	$newfile =~ s/\.txt$/-convert.txt/;
	my $cmd = 'tr \'\r\' \'\n\''." < $dir$file > $outdir$newfile";
#	print $file."\n";
	print $cmd."\n"  or die "Cannot print $cmd\n";
	print `$cmd` or die "Cannot perform $cmd\n";
	}
}





