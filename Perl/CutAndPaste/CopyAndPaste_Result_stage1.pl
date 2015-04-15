#!/usr/bin/perl -w 

use strict;

=head
Level-1_853x480_01799.jpg   2548.576    1132.946    1379.52
Level-1_853x480_01800.jpg   3116.077    2037.26 1144.961
Level-1_853x480_01801.jpg   3048.83 2308.696    1696.817
Level-1_1280x720_01799.jpg  5084.006    2237.968    2703.915
Level-1_1280x720_01800.jpg  5292.987    2839.132    4048.482
Level-1_1280x720_01801.jpg  7657.236    2689.306    2707.104
Level-1_1920x1080_01799.jpg 13428.176   6858.824    7288.148
Level-1_1920x1080_01800.jpg 19429.402   6719.574    5494.78
Level-1_1920x1080_01801.jpg 18891.784   5852.657    6746.661
=cut 


my ($Result_File) = @ARGV;
my @Resolution = ("1920x1080","1440x1080","1280x720","960x720","853x480","640x480","640x360","480x360");
my $Value_1 = 0;
my $Value_2 = 0;
my $Value_3 = 0;
my $Count = 0;
my @All_Value = ();
my @Final = ();

foreach my $i (@Resolution)
{
    #print "Resolution ==> $i \n";

    open READ, "<$Result_File" or die "$!";
    while (<READ>)
    {
        chomp;
        
        if ( $_ =~ /$i/i )
        {
            my @Get_Value = split(/\t/);
            $All_Value[$Count] = $Get_Value[0] . " " . $Get_Value[1] . " " . $Get_Value[2] . " " . $Get_Value[3];
            $Count++;
            $Value_1 += $Get_Value[1];
            $Value_2 += $Get_Value[2];
            $Value_3 += $Get_Value[3];
        }
    }
    close (READ);
    
    #print "$Count $Value_1 $Value_2 $Value_3 \n";

    my $tmp_1 = sprintf("%.2f",($Value_1/$Count));
    my $tmp_2 = sprintf("%.2f",($Value_2/$Count));
    my $tmp_3 = sprintf("%.2f",($Value_3/$Count));
    
    print "$i $tmp_1 $tmp_2 $tmp_3 \n";

    #my @all_value = sort(@All_Value);
    
    push(@Final, sort(@All_Value));
    
=head
    foreach my $j (@all_value)
    {
        print " => $j \n";
    } 
=cut

    @All_Value = ();
    $Count = 0;
    $Value_1 = 0;
    $Value_2 = 0;
    $Value_3 = 0;         
}
foreach my$j (@Final)
{
    print "$j \n";
}
