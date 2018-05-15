use strict;


my $dir = shift or die "Usage: input dir\n";
print "Okay, working\n";
opendir(DIR, $dir) or die "Can't open $dir\n";
while (my $file = readdir(DIR))
{
	if ($file =~ /\.txt/ && $file !~ /OUT\.txt/)
	{
		open(FILE, $dir.$file) or die "Can't open $file. Exiting...";
		my $newfile = $file;
		$newfile =~ s/\.txt$//;
		open (OUT, "> ".$dir.$newfile."-OUT.txt") or die "Can't open $dir$newfile-OUT.txt";
		while (my $row = <FILE>)
		{
			chomp($row);
			if ($row =~ /^PRIMER\sPICKING/)
			{
				$row =~ /\s(chr[\:\w\d\-]+)/;
				my $chrom = $1;
				$chrom =~ s/[\:\-]/\t/g;
				print OUT $chrom."\t";
			}
			if($row =~ /^LEFT/ || $row =~ /^RIGHT/)
			{
				my $seq = $row;
				$seq =~ s/^LEFT\sPRIMER//;
				$seq =~ s/^RIGHT\sPRIMER//;
				$seq =~ s/[\d\.\s]+//;


				print OUT $seq."\t";
			}
			if ($row =~ /^PRODUCT\sSIZE/ && $row !~ /^\s/)
			{
				$row =~ /PRODUCT\sSIZE\:\s([\d]+)\,/;
				my $prodsize = $1;
				print OUT $prodsize."\n";
				
			}
		}
		close OUT;
		close FILE;
	}
}
close DIR;

print "Done done!~~\n";






exit