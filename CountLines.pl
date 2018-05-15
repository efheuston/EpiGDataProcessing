 use strict;

my $dir = shift or die "Usage: <dir>";

opendir(DIR, $dir);

$dir =~ /\/([\w\.\-\_]+)\/$/;
my $newname = $1;

my $newdir = $dir;

$newdir =~ s/\/([\w\.\-\_]+\/)$/\//;
#print $newdir."\n";
#print $newname."\n";

open (OUT, "> ".$newdir."Count-".$newname.".txt") or die "cannot open output log\n";

while (my $file = readdir (DIR))
{
	if($file =~ /\.(txt|bed|fa)$/)
	{
		my $cmd = 'wc -l '.$dir.$file;
		print OUT `$cmd` or die "Either cannot print out or cannot execute command\n";
		my $tempvar = `$cmd`;
		my $row = $tempvar;
		$row = s/^\s//;
		$row = s/\s/\t/;
		print OUT $row;
	}
}
print "Printed $newdir$newname to next directory up!\n";
close OUT;

exit;

