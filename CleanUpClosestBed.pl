use strict;

my $dir = shift or die "Usage: <input dir> <Replacement name [i.e., -UnqClstRaw.txt]>\n";
my $replacename = shift or die "Usage: <input dir> <Replacement name [i.e., -UnqClstRaw.txt]>\n"; 
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
		my $column;
		my $gene;
		my @col;
		open(FILE, $dir.$file) or die "Can't open $dir$file\n";

		print "working on $file\n";

		my $outfile = $file;
		$outfile =~ s/$replacename$/-Unique\.txt/;

#		open (OUT, "> ".$dir."Cleaned/".$outfile) or die "Can't open $dir Cleaned\n";
		open (OUT, "> ".$dir.$outfile) or die "Can't open $dir\n";
		
		while (my $row = <FILE>)
		{
			chomp ($row);
			my @field = split(/\t/, $row);

			if($field[6] =~ /^\d/ && $field[14]=~ /\w/) ##Identify field with Intensity score and field with gene assignment
			{
				$column = 6;
				$gene = 14;
				@col = (0,1,2,6,14)
			}
			elsif($field[4]=~ /^\d/ && $field[10]=~ /\w/)				##Identify field with Intensity score and field with gene assignment
			{
				$column = 6;
				$gene = 10;
				@col = (0,1,2,6,10)
			}
			elsif($field[3] =~ /^\d/ && $field[8]=~ /\w/) ##Identify field with Intensity score and field with gene assignment
			{
				$column = 3;
				$gene = 8;
				@col = (0,1,2,3,8)
			}
			elsif($field[8] =~ /^\d/ && $field[7]=~ /\w/) ##Identify field with Intensity score and field with gene assignment
			{
				$column = 8;
				$gene = 7;
				@col = (0,1,2,8,7)
			}
			else
			{
				die "I con't find the right columns!! \n";
			}


			foreach (@col)
			{
#				print $_."\n";
				print OUT $field[$_]."\t";
			}
			print OUT "\n";
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

print "Might I suggest running \"PrintUniqueGenesIn_UniqueBedFile.pl\"?\n";

exit;
