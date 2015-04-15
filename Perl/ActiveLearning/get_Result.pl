#!/usr/bin/perl -w 

use strict;

require "lib_get_Result_Array.pl" ;
require "lib_get_Testing_Array.pl" ;

=head
 # Input Arguments information is below
 # $1 : Training File 
 # $2 : Result File 
 # $3 : Testing Log File 
 # $4 : Threshold Value 
=cut

my ($Training_File, $Result_File, $Testing_File, $Threshold) = @ARGV;
my @Result_Array=&get_Result_Array($Result_File);
my @Testing_Array=&get_Testing_Array($Testing_File);
my @Training_Array=&get_Training_Array($Training_File); 

sub get_Training_Array 
{
    my ($Input_File) = @_;
    my @Tmp_Array = () ;
    my $Array_Key = 0 ; 

    if ( -e $Input_File ) 
    {
        open LOG, "$Input_File" or die "$!";
        
        while (<LOG>) 
        {
            chomp; 
            my @value = split(/\t/);
            ##if ( $_ =~ /FAM/i )
            #if ( define $value[4] )
            #{
                if ( defined $value[4] )
                {
                    $Tmp_Array[$Array_Key] = $value[4] ;
                    $Array_Key++;    
                }
            #} 
        }
        my %hash;
        my @Training_Array = grep (!$hash{$_}++, @Tmp_Array);
        close (LOG);
        return @Training_Array;
    }
    else 
    {
        print "File not existed \n";
    }
    return 1;
}

sub compare_position 
{
    ## Input Value is 8 
    ## Result x,y x,y x,y x,y 
    ## Testing x,y x,y x,y x,y

    my (@Array) = @_;
    my $Key = 0;
    my $Result = 0 ;
    my $offset = 1 ;     
    for (my $i=0; $i<=3; $i++) 
    {
        my @r_tmp = split(/,/,$Array[$i]);
        my @t_tmp = split(/,/,$Array[$i+4]);
        
        my $offset_0 = $r_tmp[0]-$t_tmp[0];
        my $offset_1 = $r_tmp[1]-$t_tmp[1];

        if ( $offset_0 < 0 )
        {
            $offset_0 = $offset_0 * -1 ;
        }
        if ( $offset_1 < 0 )
        {
            $offset_1 = $offset_1 * -1 ;
        }
        if ( ($offset_0 <= $offset ) && ($offset_1 <= $offset) )
        {
            $Key++;
        } 
    }
    if ( $Key eq 4 )
    {
        return 1;
    } 
    else 
    {
        return ; 
    }
}

sub compare_trained 
{
    my ($Target) = @_;
    foreach my $i (@Training_Array)
    {
        if ( $i eq $Target )
        {
            return 1;
        }
    }    
    return ;
}

## Main Start 
my $Total_Face = 0 ;
my $Expected_True = 0 ;
my $Expected_False = 0 ;
my $Recognition_True = 0 ;
my $Recognition_False = 0 ;
my $Recognition_False_Expected_False = 0 ;
my $Total_Not_Face = 0 ;
my $Not_Face_True = 0 ;
my $Not_Face_False = 0 ;

=head
if ( &compare_position("10,10", "20,20", "30,30", "40,40", "10,11", "60,60", "70,70", "80,80") )
{
    print "Same \n";
}
else
{
    print "Not Same \n";
}
=cut

foreach my $i (@Result_Array)
{
    print "Result Value : $i \n";
}

=head
my $match = "Family-006_Testing_Data_006-F1-M1-G1-G2-G3-B1_0001.jpg";
my @temp_array = grep(/$match/, @Result_Array) ; 
foreach my $i (@temp_array)
{
    print "Array Value : $i \n";
}
=cut

foreach my $Result_Value (@Result_Array)
{
    ## Result Sample : Family-006_Testing_Data_006-F1-M1-G1-G2-G3-B1_0001.jpg 2 392,75 430,75 392,113 430,113 FAM6_FG1  
    ## Testing Sample : Family-006_Testing_Data_006-F1-M1-G1-G2-G3-B1_0002.jpg 2 145,162 183,166 141,200 179,204 Empty 0  

    my @Sub_Result_Array = split(/ /,$Result_Value);
    my @First_Testing_Array = grep(/$Sub_Result_Array[0]/, @Testing_Array);
    
    print "Result String ==> $Result_Value \n";

    foreach my $Value_First_Testing_Array (@First_Testing_Array)
    {   

        print "Testing Array ==> $Value_First_Testing_Array \n";

        my @Sub_Testing_Array = split(/ /,$Value_First_Testing_Array);
        #if ( $Sub_Result_Array[0] eq $Sub_Testing_Array[0] and &compare_position($Sub_Result_Array[2], $Sub_Result_Array[3], $Sub_Result_Array[4], $Sub_Result_Array[5], $Sub_Testing_Array[2], $Sub_Testing_Array[3], $Sub_Testing_Array[4], $Sub_Testing_Array[5]) )
        if ( &compare_position($Sub_Result_Array[2], $Sub_Result_Array[3], $Sub_Result_Array[4], $Sub_Result_Array[5], $Sub_Testing_Array[2], $Sub_Testing_Array[3], $Sub_Testing_Array[4], $Sub_Testing_Array[5]) )
        {
            #print "RV: $Result_Value   \n";
            my $Check_Status = "" ;

            $Total_Face++;
            print "E: $Sub_Result_Array[6] A: $Sub_Testing_Array[6] T: $Sub_Testing_Array[7] $Sub_Result_Array[2] $Sub_Result_Array[3] $Sub_Result_Array[4] $Sub_Result_Array[5] \n";
            if ( $Sub_Testing_Array[7] < $Threshold )
            {
                print "$Sub_Testing_Array[7] Threshold ==> $Threshold \n";
                $Sub_Testing_Array[6] = "Empty";
                $Sub_Testing_Array[7] = 0;
            }
            
            # print "Result : $Sub_Result_Array[0]  Testing $Sub_Testing_Array[0] ";
            # print "E: $Sub_Result_Array[6] A: $Sub_Testing_Array[6] T: $Sub_Testing_Array[7] $Sub_Result_Array[2] $Sub_Result_Array[3] $Sub_Result_Array[4] $Sub_Result_Array[5] ";

            if ( &compare_trained($Sub_Result_Array[6]) )
            {
                $Expected_True++;
                $Check_Status = $Check_Status . "Expected_True ";
            }        
            elsif ( $Sub_Result_Array[6] eq "Empty" )
            {
                $Total_Not_Face++;
                $Check_Status = $Check_Status . "Total_Not_Face ";
            }
            else
            {
                $Expected_False++;
                $Check_Status = $Check_Status . "Expected_False ";
            }

            if ($Sub_Result_Array[6] eq $Sub_Testing_Array[6])
            {
                if ($Sub_Result_Array[6] eq "Empty")
                {
                    $Not_Face_True++;
                    $Check_Status = $Check_Status . "Not_Face_True "; 
                }
                else
                {
                    $Recognition_True++;
                    $Check_Status = $Check_Status . "Recognition_True "; 
                }
            }
            else 
            {
                if ($Sub_Result_Array[6] eq "Empty")
                {
                    $Not_Face_False++;
                    $Check_Status = $Check_Status . "Not_Face_False ";
                }
                else
                {
                    if ((( &compare_trained($Sub_Result_Array[6])) and ($Sub_Testing_Array[6] ne "Empty") ) or (&compare_trained($Sub_Result_Array[6]) and ($Sub_Testing_Array[6] eq "Empty" )))
                    {
                        $Recognition_False++;
                        $Check_Status = $Check_Status . "Recognition_False ";
                    }
                    
                    if ( ($Sub_Testing_Array[6] ne "Empty") and ( ! &compare_trained($Sub_Result_Array[6]) ) )
                    {
                        $Recognition_False++;
                        $Check_Status = $Check_Status . "Recognition_False ";
                        $Recognition_False_Expected_False++;
                        $Check_Status = $Check_Status . "Recognition_False_Expected_False ";
                    }
                    


                }
            }

            print "Status = $Check_Status \n";
        }    
    }
}

print " Total Face : $Total_Face \n";
print " Expected True : $Expected_True \n";
print " Expected False : $Expected_False \n";
print " Recognition True : $Recognition_True \n";
print " Recognition False : $Recognition_False \n";
print " Recognition False (Expected False) : $Recognition_False_Expected_False \n";
print " Total Not Face : $Total_Not_Face \n";
print " Not Face True : $Not_Face_True \n";
print " Not Face False : $Not_Face_False \n";
