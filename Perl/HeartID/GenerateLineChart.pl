#!/bin/perl

use strict;
use warnings;
use GD::Graph::lines;
use Getopt::Std;

my ($Image_Folder,$Target_Folder,$Tag)  = @ARGV;

foreach my $fp (glob("$Image_Folder/*.lvm")){
	#chomp;
	print " Original Path ==>  $fp  \n";
	my @tmp_file_name = split(/\//, $fp);
	my $File_Name = $tmp_file_name[1];
	print " File Name ==> $File_Name \n";

	my @X_Key = ();
	my @Data = ();
	my $Key = 0;

	open READ, "<$fp" or die "$!";
	while (<READ>){
		chomp;
		
		#if ( $_ eq '' ) {
			push (@Data, $_);
			push (@X_Key, $Key);
			$Key++;
		#}
	}
	
	my $chart = GD::Graph::lines->new(960,640);
	$chart->set(x_label => "Data Sequence",
		    y_label => "Value",
		    transparent  => 0 ,
		    bgclr => "lgray" ,
		    title   => $File_Name );
	my $plot = $chart->plot(
		[ 	[ @X_Key ],
			[ @Data ],
		]);
	
	my $Output_N = $Target_Folder . "/" .$File_Name . "_" . $Tag . ".png";

	open(F, "> $Output_N")
	  or die "Can't open $Output_N for writing: $!\n";
	print F $plot->png;
	close F;

}
