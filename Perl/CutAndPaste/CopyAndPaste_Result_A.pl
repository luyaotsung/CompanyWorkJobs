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
my $R_Elpased="";
## 90%
my $Done_0="";
## 95%
my $Done_1="";
## 98%
my $Done_2="";

open READ, "<$Result_File" or die "$!";

while (<READ>)
{
    chomp;
    
    my @Array = split(/\./,$_);


    if ( $_ eq "Done" ) 
    {
        my $AVG_Idle = $R_Idle/$R_Count ;
        my $AVG_Drawing = $R_Drawing/$R_Count;

        print "$File_Name RAW $R_Count Idle: $AVG_Idle Drawing: $AVG_Drawing Rate: $R_Rate \n";
        print "$File_Name Rate    $R_Rate \n";
        print "$File_Name Elpased $R_Elpased \n"; 


        my @tmp_rate = split(/ /,$R_Rate);
        
        my @tmp_90 = split(/ /,$Done_0);
        my @tmp_95 = split(/ /,$Done_1);
        my @tmp_98 = split(/ /,$Done_2);

        my $first = "None" ;
        my $second = "None" ;
        my $third = "None" ;        

        if ( $tmp_90[1] )
        {
            $first = $tmp_90[1];
        }

        if ( $tmp_95[1] )
        {
            $second = $tmp_95[1];
        }

        if ( $tmp_98[1] )
        {
            $third = $tmp_98[1];
        }

        print "$File_Name Stage-2 $tmp_rate[1] \n";
        print "$File_Name Stage-3 $R_Count $AVG_Idle $AVG_Drawing $first $second $third $tmp_rate[-1] \n"; 

    

        $File_Name = "";
        $R_Count = 0;
        $R_Rate = "";
        $R_Idle = 0;
        $R_Drawing = 0;
        $R_Elpased = "";
        $Done_0 = "";
        $Done_1 = "";
        $Done_2 = "";
    }
    elsif ( $Array[-1] eq "jpg" )
    {
        my @Tmp_Array = split(/\//,$_);

        $File_Name = $Tmp_Array[4];
    }
    else 
    {
        my @Tmp_Array = split(/ /,$_);
        $R_Count ++;
        my $Tmp = sprintf("%.2f",(($Tmp_Array[4]+($Tmp_Array[3]-$Tmp_Array[5]))/($Tmp_Array[2]+$Tmp_Array[3]))*100);
        #my $Tmp = sprintf("%.2f",(($Tmp_Array[4]-$Tmp_Array[5])/$Tmp_Array[2])*100);

        if ( $Tmp >= 90 )
        {
            $Done_0 = $Done_0 . " " . $R_Count . " " . $Tmp;
            if ( $Tmp >= 95 ) 
            {
                $Done_1 = $Done_1 . " " . $R_Count . " " . $Tmp;
                if ( $Tmp >= 98 ) 
                {
                    $Done_2 = $Done_2 . " " . $R_Count . " " .  $Tmp;
                }
            }
        }
        $R_Rate = $R_Rate . " " . $Tmp;
        $R_Elpased = $R_Elpased . " " . $Tmp_Array[8]; 
        $R_Idle += $Tmp_Array[6];
        $R_Drawing += $Tmp_Array[7];
    }


}

close (READ);
