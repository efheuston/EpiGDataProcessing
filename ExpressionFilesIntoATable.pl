use strict;


my $dir = shift or die "\t***Usage: <Dir of Gene+XprsnComparisons>\n";


	$dir =~ /\/([\w\.\-\_]+)\/$/;
	my $newname = $1;
	my $newdir = $dir;
	$newdir =~ s/$newname\///; 
	$newdir =~ /\/([\w\.\-\_]+)\/$/;
	my $prefix = $1;
	my $outname = "GeneListVsXprsn-Table";
	
	my $printhash; #contains each file's name linked to contents to print
	my $genehash; #contains the names of each gene;
	my $spacer;
	
	opendir(DIR, $dir) or die "Can't open $dir";
	while (my $file = readdir (DIR))
	{
		if ($file =~ /\.txt$/)
		{
			
			open(FILE, $dir.$file) or print "Can't open $dir$file";
			while (my $row = <FILE>)
			{
				chomp ($row);
				my @line = split(/\t/, $row);
				$genehash->{$line[0]}=1;
				if(scalar(@line) == 3)
				{
					my $result = $line[1]."\t".$line[2]; #store Peak intensity and expression Level of gene as $result
					$printhash->{$file}->{GENE}->{$line[0]} = "$result";
					$printhash->{$file}->{COLCOUNT} = 4;				
				}
				elsif(scalar(@line) == 5)
				{
					$spacer = 1; 
					my $result = $line[1]."\t".$line[2]."\t".$line[3]."\t".$line[4];
					$printhash->{$file}->{GENE}->{$line[0]} = "$result";				
					$printhash->{$file}->{COLCOUNT} = 4;
				}
			}
			close FILE;
		}
		
	}
	close DIR;

	open (OUT, "> ".$newdir.$prefix."-".$outname."\.txt") or die "Can't open table file \n";
	print "Printing $newdir$prefix - $outname\n";
	
	print OUT "File\t";
	
	
	foreach my $fname(sort keys %$printhash)
	{
		if($spacer == 1)
		{	
			print OUT $fname;
			my $space = $printhash->{$fname}->{COLCOUNT};
			print OUT "\t" x $space;
		}
		else
		{
			print OUT $fname."\t\t";
		}
	}
	print OUT "\n";
	print OUT "Gene\t";
	
	foreach my $fname(sort keys %$printhash)
	{
		if($spacer == 1)
		{	
			print OUT $fname;
			my $space = $printhash->{$fname}->{COLCOUNT};
			print OUT "\t" x $space;
		}
		else
		{
			print OUT " Pk Intensity\tGen Xprsn\t";
		}
	}

	print OUT "\n";
	foreach my $geneid (keys %$genehash)
	{
		print OUT $geneid."\t";
		foreach my $fname(sort keys %$printhash)
		{
			if($spacer==1)
			{
				if($printhash->{$fname}->{GENE}->{$geneid})
				{
					if($printhash->{$fname}->{COLCOUNT}==5)
					{				
						print OUT $printhash->{$fname}->{GENE}->{$geneid};
						print OUT "\t\t\t";
					}
					elsif($printhash->{$fname}->{COLCOUNT}==3)
					{				
						print OUT $printhash->{$fname}->{GENE}->{$geneid};
						print OUT "\t";
					}
	
				}
				else
				{
					print OUT "\t\t\t";				
				}
			}
	
			else
			{		
				if($printhash->{$fname}->{GENE}->{$geneid})
				{
						print OUT $printhash->{$fname}->{GENE}->{$geneid};
					print OUT "\t";
				}
				else
				{
					print OUT "\t\t";
					
				}
			}	
		}
		print OUT "\n";
	}
	
	close OUT;
		
close OUTDIR;


print "Done done~~!\n";
exit;
