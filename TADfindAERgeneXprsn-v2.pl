use strict;


my $dir = shift or die "Usage: <GeneListdir/> <expressionfile.txt>\n";
#my $outdir = shift or die "Usage: <GeneListdir/> <output dir> <expressionfile.txt>\n";
my $xprsn = shift or die "Usage: <GeneListdir/> <expressionfile.txt> \n";

chomp ($xprsn);

my $filetype;


open(TEMP, $xprsn) or die "Can't open\n";
while (my $row = <TEMP>)
{
	chomp($row);
	my @array = split(/\t/, $row);
	if(scalar(@array) == 4)
	{
		$filetype = 4;
	}
	elsif(scalar(@array) == 2)
	{
		$filetype = 2;
	}
	else
	{
		die "I don't know what to do with an expression file that contains $filetype columns. \nExiting.\n";
	}
	
}
close TEMP;

#print "Does expression file have 2 columns or 4?\n";
#my $filetype = <STDIN>;
#chomp ($filetype);
#
print "Is there a prefix subset to limit the comparison against? (type none/no for no restriction)\n";
my $subset = <STDIN>;
chomp ($subset);

if ($subset =~ /^n/)
{
	$subset =~ s/[\w]+/./;
}


my $xprsnhash;
my $outfilehash;

##ReadInExpressionData

if($filetype == 2)
{
	open(IN, $xprsn) or die "Can not open expression file\n";
	opendir(DIR, $dir);

	while (my $row = <IN>)
	{
		my @field = split (/\t+/, $row);
		if ($field[1] == 0)
		{
			$field[1]= "0";
		}
		
		$xprsnhash->{$field[0]}->{$field[1]} = 1; 
	}

	##ReadInChIPData

	while (my $file = readdir(DIR))
	{
		if($file =~ /.bed$/ && $dir.$file ne $xprsn && $file !~ /VsXprsn\.bed$/ && $file =~ /^$subset/)
		{
#			print "$file\n";
			my $chiphash;
			my $list;
			my $hash;
			my $listname = $file;
#			print "$listname\n";
			$listname =~ s/\.txt$//;
#			print "$listname\n";

			##list of files containing gene IDs to be compared = $dirlist
		
			open(FILE, $dir.$file) or die "Cannot open $file";
			{
				my $tad;
				my $tadcount;
				my $aer;
				my $aercount;
				my $gene;
				my $genecount;
				while (my $row = <FILE>)
				{
					chomp ($row);
					my@line = split(/\t/, $row);
#					my $tadset= join(/\t/, $line[0..11], $line[13]);
					if($line[12] =~ /\;/)
					{
						$line[12]=~/(\w+)\;/; #things between diff sets of () get assigned to a diff $number
						$chiphash->{$1} = $row;
					}
					else
					{
						$chiphash->{$line[12]} = $row;
					}
				}
			}
			
			$xprsn =~ /\/([\w\.\-]+\.txt)/;
			my $xprsnname = $1;
			$xprsnname =~ s/\.bed$//;
			my $newfile = $xprsnname."-".$listname."VsXprsn\.txt";

			print "Creating ".$newfile."\n";
			$outfilehash->{$newfile} = 1;

			open (OUT, "> ".$dir.$newfile) or die "Can not open export file\n";
			print OUT "$newfile\tTAD_chr\tTAD_start\tTAD_stop\tAER_chr\tAER_start\tAER_stop\tAER_intensity\tTAD:AER_ovlp\tGene_chr\tGene_start\tGene_stop\tGene_strand\tGene_IDs;\tTAD:Gene_ovlp\tXprsn\n";
			foreach my $gene (keys %$xprsnhash)
			{
				foreach my $id (keys %$chiphash)
				{		
					if ($id eq $gene)
					{
						foreach my $exp1 (keys %{$xprsnhash->{$gene}})
						{
							chomp ($exp1);
							print OUT $id."\t".$chiphash->{$id}."\t".$exp1."\n";
						}
					}
				}
			}
			close OUT;
			close FILE;
		}

	}
}
else
{
	die "I don't know what to do with an expression file that contains $filetype columns. \nExiting.\n";
	
}


#cleanup

my $mkcmd = "mkdir ".$dir."GeneListVsXprsn";
print `$mkcmd`;

opendir(OUTDIR, $dir);

while (my $file = readdir(OUTDIR))
{
	foreach my $id(keys %$outfilehash)
	{
		if ($file eq $id)
		{
			my $mvcmd = "mv ".$dir.$file." ".$dir."GeneListVsXprsn/";
			print `$mvcmd`;
		}
	}
}


print "Done done~~!\n";
exit;
