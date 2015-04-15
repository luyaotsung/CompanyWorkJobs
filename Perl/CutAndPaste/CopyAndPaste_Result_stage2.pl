#!/usr/bin/perl -w 

use strict;

=head
/sdcard/MattingEval/Image/153077.jpg
1 2976 40620 113781 8639 9888 3.16197 5.95181 9.20824
2 588 40620 113781 8639 9888 3.27276 1.15819 13.5617
3 454 40620 113781 8639 9888 3.53762 0.889394 17.9858
4 211 40620 113781 8639 9888 9.24294 0.468396 27.696
5 275 40620 113781 8639 9888 1.31344 0.31964 29.3286
6 228 40620 113781 8639 9888 1.16856 0.249809 30.751
7 160 40620 113781 8639 9888 1.12391 0.363742 32.2414
8 178 40620 113781 8639 9888 2.76017 0.25747 35.2564
9 138 40620 113781 8639 9888 2.67835 0.312437 38.2457
Done
=cut

my ($Result_File) = @ARGV;
my $File_Name = "";
my $R_Count=0;
my $R_Rate= "";
my $R_Idle=0;
my $R_Drawing=0;

open READ, "<$Result_File" or die "$!";

while (<READ>)
{
    chomp;
    
    my @Array = split(/\./,$_);

    if ( $_ eq "Done" ) 
    {
        my $AVG_Idle = $R_Idle/$R_Count ;
        my $AVG_Drawing = $R_Drawing/$R_Count;
        print " $File_Name $R_Count Idle: $AVG_Idle Drawing: $AVG_Drawing Rate: $R_Rate \n";

        $File_Name = "";
        $R_Count = 0;
        $R_Rate = "";
        $R_Idle = 0;
        $R_Drawing = 0;
        
    }
    elsif ( $Array[1] eq "jpg" )
    {
        my @Tmp_Array = split(/\//,$_);
 
        $File_Name = $Tmp_Array[4];
        print "File_Name ==> $File_Name \n";
    }
    else 
    {
        my @Tmp_Array = split(/ /,$_);
        $R_Count ++;
        my $Tmp = sprintf("%.2f",($Tmp_Array[4]/$Tmp_Array[2])*100);
        $R_Rate = $R_Rate . " " . $Tmp; 
        $R_Idle += $Tmp_Array[6];
        $R_Drawing += $Tmp_Array[7];
    }


}

close (READ);
