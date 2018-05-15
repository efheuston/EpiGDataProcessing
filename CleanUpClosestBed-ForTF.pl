use strict;

my $dir = shift or die "Usage: <input dir>\n";
my $replacename = "-UnqClstRaw.txt"; 
#my $options = join(" ", @ARGV);

chomp($replacename);


#chomp($options);
#print "Printing columns $options\n";

#my @col = split(/\ /, $options);


#my $cmd = "mkdir ".$dir."Cleaned";
#print `$cmd`;

opendir(DIR, $dir);
while (my $file = readdir(DIR))
{
	if ($file =~ /\.bed$/ || $file =~ /\.txt/)
	{
		my $tfcolumn;
		my $gene;
		my $dist;
		my $line;
		my $hashfile;
		open(FILE, $dir.$file) or die "Can't open $dir$file\n";

		print "working on $file\n";

		my $outfile = $file;
		$outfile =~ s/$replacename$/-TFUnique\.txt/;

#		open (OUT, "> ".$dir."Cleaned/".$outfile) or die "Can't open $dir Cleaned\n";
		open (OUT, "> ".$dir.$outfile) or die "Can't open $dir\n";
		
		while (my $row = <FILE>)
		{
			chomp ($row);
			my @field = split(/\t/, $row);

			if($field[3] =~ /^\w/ && $field[10]=~ /\w/) ##Identify field with TF, field with gene assignment, and field with distance
			{
				$tfcolumn = 3;
				$gene = 10;
				$dist = 11;
				$line =$field[0]."\t".$field[1]."\t".$field[2]."\t".$field[3]."\t".$field[10]."\t".$field[11];
				$hashfile-> {$line} = 1;
			}
			else
			{
				die "I con't find the right columns!! \n";
			}
		}


		foreach my $key (keys %$hashfile)
		{
			print OUT $key."\n";
		}

		close OUT;
		close FILE;
	}
}

my $cleanup = "mkdir ".$dir."aaRawClosestBed";
print `$cleanup`;

close DIR;

opendir(SORT, $dir);
while (my $raws = readdir(SORT))
{
	if ($raws =~ /$replacename$/)
	{
		my $clean = "mv ".$dir.$raws." ".$dir."aaRawClosestBed/";
		print `$clean`;
		
	}
}

close SORT;

