use strict;

my $dir = shift or die "Usage: <Dir with query data (-a) > <Dir with reference data (-b) > <outdir> <IntersectBed Preferences>\n";
my $dir2 = shift or die "Usage: <Dir with query data> <Dir with reference data> <outdir> <IntersectBed Preferences>\n";
my $outdir = shift or die "Usage: <Dir with query data> <Dir with reference data> <outdir> <IntersectBed Preferences>\n";
my $options = join(" ", @ARGV);

chomp($options);
my $optionsname = $options;
$optionsname =~ s/[\s]+/\_/g;
#print $options."\n";
#print $optionsname."\n";
print "Is there a prefix subset to limit the comparison against? (type none/no for no restriction)\n";
my $subset = <STDIN>;
chomp ($subset);

if ($subset =~ /^no/)
{
	$subset =~ s/[\w]+/./;
}


#print "$options\n";
opendir(DIR, $dir);

while (my $file = readdir (DIR))
{
	if ($file =~ /^$subset/ && $file =~ /\.bed$/)
	{
		my $firstfilename = $file;
		print $file."\n";
		$firstfilename =~ s/\.bed//;
		opendir(DIR2, $dir2);
		while (my $nextfile = readdir(DIR2))
		{
			if ($nextfile =~ /^$subset/ && $nextfile =~ /\.bed$/)
			{
				my $filename = $firstfilename."_".$optionsname."_".$nextfile;
				if ($filename =~ /_peaks_Rndmls\.bed_mm9_RefSeq\.bed\.bed/)
				{
					$filename =~ s/_peaks_Rndmls\.bed_mm9_RefSeq\.bed\.bed//g;
				}
				if($filename =~ /sorted_rmdup\.bamp_/)
				{
					$filename =~ s/sorted_rmdup\.bamp_//g;
				}
				if($filename =~ /sorted\.bamp_/)
				{
					$filename =~ s/sorted\.bamp_//g;
				}
				if($filename =~ /\.bed$/)
				{
					$filename =~ s///;
				}
				my $outfile = $filename.'.bed';
				print $outfile."\n";
				if (length($options) > 0)
				{
					print "Using overlap parameters of $options\n";
					my $cmd = 'bedtools intersect '.$options.' -a '.$dir.$file.' -b '.$dir2.$nextfile.' > '.$outdir.$outfile;
					print `$cmd`;
				}
				else
				{
					print "Using defaults\n";
					my $cmd = 'bedtools intersect -a '.$dir.$file.' -b '.$dir2.$nextfile.' > '.$outdir.$outfile;
					print `$cmd`;
				}
			}
		}

	}
}




print "Finished Run!!\n";




exit;
