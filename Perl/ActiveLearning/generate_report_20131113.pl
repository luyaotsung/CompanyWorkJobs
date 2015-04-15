#!/usr/bin/perl -w 

use strict;

my ($input_file) = @ARGV;

my $Name = "";
my $Value_5 = 0;
my $Value_10 = 0;
my $Value_20 = 0;
my $Count = 1;

if ( -e $input_file )
{
    open READ, "<$input_file" or die "$!";
    my $line_num = 1;
    while (<READ>) 
    {
        chomp;

        my @Get_Value = split(/ /, $_);
        my @Get_FileName = split (/0/, $Get_Value[0]);
        
        my $New_Name = $Get_FileName[0];
        my $New_Value_5 = $Get_Value[6];
        my $New_Value_10 = $Get_Value[11];
        my $New_Value_20 = $Get_Value[21];

        #print " Original : $Name , New : $New_Name , Count : $Count \n";

        if ( $Name eq $New_Name ) 
        {
            $Value_5 += $New_Value_5;
            $Value_10 += $New_Value_10;
            $Value_20 += $New_Value_20;
            $Count++;
        }
        else 
        {
            if ( $Name eq "" )
            {
                $Name = $New_Name ;
                $Value_5 = $New_Value_5;
                $Value_10 = $New_Value_10;
                $Value_20 = $New_Value_20;            
            }
            else 
            {
                print " $Name $Value_5 $Value_10 $Value_20 $Count \n";

                $Value_5 = $Value_5 / $Count; 
                $Value_10 = $Value_10 / $Count; 
                $Value_20 = $Value_20 / $Count; 

                my $X05 = sprintf("%.3f",$Value_5);
                my $X10 = sprintf("%.3f",$Value_10);
                my $X20 = sprintf("%.3f",$Value_20);

                print " $Name $X05 $X10 $X20 \n" ;
        
                $Name = $New_Name ;
                $Value_5 = $New_Value_5;
                $Value_10 = $New_Value_10;
                $Value_20 = $New_Value_20;   
         
                $Count = 1;

            }
        }        
    }
}
