#!/usr/bin/perl -w 

=head
[filename]  Aarif-Rahman_0001.jpg
[detection-time]    482.649000
[rec-num]   1
[rec]   183,164 264,173 174,245 255,254
[rec-pose]  0#
=cut

use strict;


my ($Position_File) = @ARGV;
my @Two_Name = () ;
my @Two_Key = () ;
my @Two_Value = () ;
my @Train1 = ();
my @Train2 = ();
my @Train3 = ();
my @Train4 = ();
my @Train5 = ();
my @Result_Array = ();
my $Train1_Key = 0;
my $Train2_Key = 0;
my $Train3_Key = 0;
my $Train4_Key = 0;
my $Train5_Key = 0;
my $Result_Key = 0;

open READTWO, "<Two_Check.txt" or die "$!";
my $two_key = 0 ;
while (<READTWO>) {
    chomp;
    
    my @tmp_two_array = split(/\t/, $_);
    
    $Two_Name[$two_key] = $tmp_two_array[0];
    $Two_Key[$two_key] = $tmp_two_array[1];
    $Two_Value[$two_key] = $tmp_two_array[2];
    $two_key++;
}
close (READTWO);

my @Target_Array=&get_Position_Array($Position_File);

open ORIG, ">Original.txt" or die "$!";
foreach my $i (@Target_Array) {
    print ORIG "$i \n";
}
close (ORIG);
open TRAIN1, ">Train_1.txt" or die "$!";
foreach my $i (@Train1) {
    print TRAIN1 "$i \n";
}
open TRAIN2, ">Train_2.txt" or die "$!";
foreach my $i (@Train2) {
    print TRAIN2 "$i \n";
}
open TRAIN3, ">Train_3.txt" or die "$!";
foreach my $i (@Train3) {
    print TRAIN3 "$i \n";
}
open TRAIN4, ">Train_4.txt" or die "$!";
foreach my $i (@Train4) {
    print TRAIN4 "$i \n";
}
open TRAIN5, ">Train_5.txt" or die "$!";
foreach my $i (@Train5) {
    print TRAIN5 "$i \n";
}
open RESULT, ">Result.txt" or die "$!";
foreach my $i (@Result_Array) {
    print RESULT "$i \n";
}

close (TRAIN1);
close (TRAIN2);
close (TRAIN3);
close (TRAIN4);
close (TRAIN5);
close (RESULT);

sub check_TWO_Status 
{
    ## Content of Two_Check.txt 
    ## [File_Name] [Key] [Value]
    ## Value has 1 , 2 ,3 
    ## 1 ==> Target Face 
    ## 2 ==> It is a face but it is not target.  Nobody 
    ## 3 ==> Wrong detect it is not a face

    my ($File_name, $Key) = @_;
    my $force_key = 0 ;
    foreach my $j (@Two_Name) {
        if ( $j eq $File_name and $Two_Key[$force_key] eq $Key  ) {
            print "File Name : $j , Key : $Two_Key[$force_key]  , Value ==> $Two_Value[$force_key] ";
            if ( $Two_Value[$force_key] eq "1" ) {
                return "Target";
            }
            elsif ( $Two_Value[$force_key] eq "2" ) {
                return "Face";
            }
            elsif ( $Two_Value[$force_key] eq "3" ) {
                return "Not_Face"
            }
            last ;
        }
        $force_key++;
    }
    return "Shit";
}

sub get_Position_Array
{
    my ($Input_File) = @_;
    my $Switch_Key = 1;
    my $Array_Key = 0;
    my $Sub_Array_Key= 0;
    my @Testing_Array=();
    my $Expected_Name = "";
    my $Limit_Key = 1 ;
    my $Count_Key = 1; 
    my $Switch_Result = "No";

    if ( -e $Input_File ) {
        open LOG, "<$Input_File" or die "$!";
        open TWOORMORE, ">Two_Or_More.txt" or die "$!";
        open ZERO, ">Zero.txt" or die "$!";
        my $line_num = 1;
        my $File_Name = "";
        my $Serial_Number = "";
        while (<LOG>) {
        chomp;
        if ( $_ =~ /\[filename\]|\[rec-num\]|\[rec\]|\[rec-pose\]/i ){ 
            print "Original : $_ \n";
            my @Get_Value = split(/\t/);
            if ( $Switch_Key eq 1 ) {
                #print "Expected 1 : Switch Key = $Switch_Key \n" ;
                my @array_line_value = split(/\./);
                my @array_line_value_tmp_1 = split(/_/, $Get_Value[1]);
                my @array_line_value_tmp_2 = split(/\./, $array_line_value_tmp_1[-1]);
                $Serial_Number = $array_line_value_tmp_2[0] ;
                #print "Serial Number $Serial_Number \n" ;
                
                if ( $array_line_value[-1] eq "jpg" ) {
                    $Testing_Array[$Array_Key] = $Get_Value[1]; 
                    $File_Name = $Get_Value[1];
                    $Array_Key++;

                    ## Input Train File 
                    if ( $Serial_Number eq "0005" ) { 
                        $Train5[$Train5_Key] = $Get_Value[1];
                        $Train5_Key++;
                    }
                    elsif ( $Serial_Number eq "0004" ) {
                        $Train4[$Train4_Key] = $Get_Value[1];
                        $Train4_Key++;
                        $Train5[$Train5_Key] = $Get_Value[1];
                        $Train5_Key++;

                    } 
                    elsif ( $Serial_Number eq "0003" ) {
                        $Train3[$Train3_Key] = $Get_Value[1];
                        $Train3_Key++;
                        $Train4[$Train4_Key] = $Get_Value[1];
                        $Train4_Key++;
                        $Train5[$Train5_Key] = $Get_Value[1];
                        $Train5_Key++;

                    } 
                    elsif ( $Serial_Number eq "0002" ) {
                        $Train2[$Train2_Key] = $Get_Value[1];
                        $Train2_Key++;
                        $Train3[$Train3_Key] = $Get_Value[1];
                        $Train3_Key++;
                        $Train4[$Train4_Key] = $Get_Value[1];
                        $Train4_Key++;
                        $Train5[$Train5_Key] = $Get_Value[1];
                        $Train5_Key++;
                    } 
                    elsif ( $Serial_Number eq "0001" ) {
                        $Train1[$Train1_Key] = $Get_Value[1];
                        $Train1_Key++;
                        $Train2[$Train2_Key] = $Get_Value[1];
                        $Train2_Key++;
                        $Train3[$Train3_Key] = $Get_Value[1];
                        $Train3_Key++;
                        $Train4[$Train4_Key] = $Get_Value[1];
                        $Train4_Key++;
                        $Train5[$Train5_Key] = $Get_Value[1];
                        $Train5_Key++;
                    } 
                    else {
                        $Result_Array[$Result_Key] = $Get_Value[1];
                        $Result_Key++;
                    }
                }
                $Switch_Key++;
                my @tmp_array = split(/_/, $Get_Value[1]);
                $Expected_Name = $tmp_array[0];
                
            }
            elsif ( $Switch_Key eq 2 ) {
                #print "Expected 2 : Switch Key = $Switch_Key \n" ;
                $Sub_Array_Key = $Get_Value[1] * 2 ;
                $Switch_Key++;
                if ( $Sub_Array_Key eq 0 ) {
                    $Testing_Array[$Array_Key] = $Get_Value[1]; 
                    $Array_Key++;
                    $Result_Array[$Result_Key] = $Get_Value[1];
                    $Result_Key++;
                    $Switch_Key = 1;
                    
                    print ZERO "$File_Name  $Get_Value[1] \n";
                }
                else {
                    $Testing_Array[$Array_Key] = $Get_Value[1]; 
                    $Array_Key++;

                    if ( $Serial_Number eq "0005" ) { 
                        $Train5[$Train5_Key] = 1;
                        $Train5_Key++;
                    }
                    elsif ( $Serial_Number eq "0004" ) {
                        $Train4[$Train4_Key] = 1;
                        $Train4_Key++;
                        $Train5[$Train5_Key] = 1;
                        $Train5_Key++;

                    } 
                    elsif ( $Serial_Number eq "0003" ) {
                        $Train3[$Train3_Key] = 1;
                        $Train3_Key++;
                        $Train4[$Train4_Key] = 1;
                        $Train4_Key++;
                        $Train5[$Train5_Key] = 1;
                        $Train5_Key++;
                    } 
                    elsif ( $Serial_Number eq "0002" ) {
                        $Train2[$Train2_Key] = 1;
                        $Train2_Key++;
                        $Train3[$Train3_Key] = 1;
                        $Train3_Key++;
                        $Train4[$Train4_Key] = 1;
                        $Train4_Key++;
                        $Train5[$Train5_Key] = 1;
                        $Train5_Key++;
                    } 
                    elsif ( $Serial_Number eq "0001" ) {
                        $Train1[$Train1_Key] = 1;
                        $Train1_Key++;
                        $Train2[$Train2_Key] = 1;
                        $Train2_Key++;
                        $Train3[$Train3_Key] = 1;
                        $Train3_Key++;
                        $Train4[$Train4_Key] = 1;
                        $Train4_Key++;
                        $Train5[$Train5_Key] = 1;
                        $Train5_Key++;
                    } 
                    else {
                        $Result_Array[$Result_Key] = $Get_Value[1];
                        $Result_Key++;
                    }

                    if ( $Sub_Array_Key gt 3 ) {
                        print TWOORMORE "$File_Name $Get_Value[1] \n";
                    }
                }
            } 
            elsif ( $Switch_Key eq 3 ) {
                #print "Expected 3 : Switch Key = $Switch_Key \n" ;
                if ( $Sub_Array_Key ge 1 ) {
                    if ( $Sub_Array_Key%2 == 0 ) {
                        $Testing_Array[$Array_Key] = "$Get_Value[1] $Get_Value[2] $Get_Value[3] $Get_Value[4] $Expected_Name" ;

#########################################################################################################################
                        my $Final_Result = "$Get_Value[1] $Get_Value[2] $Get_Value[3] $Get_Value[4] " ;
                        my $position_status="";
                        if ( &check_TWO_Status($File_Name , $Count_Key) eq "Face" and $Serial_Number > 5 ) {
                            $Final_Result=$Final_Result . "NoBody";
                            $Result_Array[$Result_Key] = $Final_Result;
                            $Result_Key++;
                            $position_status="Face";
                        }
                        elsif ( &check_TWO_Status($File_Name , $Count_Key) eq "Not_Face" and $Serial_Number > 5 ) {
                            $Result_Array[$Result_Key] = $Final_Result;
                            $Result_Key++;
                            $position_status="Not_Face";
                        }
                        else {
                            $position_status="Target_Face";
                            $Final_Result = $Final_Result . $Expected_Name ;
                            ## Input Train File 
                            if ( $Serial_Number eq "0005" ) { 
                                $Train5[$Train5_Key] = $Final_Result;
                                $Train5_Key++;
                            }
                            elsif ( $Serial_Number eq "0004" ) {
                                $Train5[$Train5_Key] = $Final_Result;
                                $Train5_Key++;
                                $Train4[$Train4_Key] = $Final_Result;
                                $Train4_Key++;
                            } 
                            elsif ( $Serial_Number eq "0003" ) {
                                $Train5[$Train5_Key] = $Final_Result;
                                $Train5_Key++;
                                $Train4[$Train4_Key] = $Final_Result;
                                $Train4_Key++;
                                $Train3[$Train3_Key] = $Final_Result;
                                $Train3_Key++;
                            } 
                            elsif ( $Serial_Number eq "0002" ) {
                                $Train2[$Train2_Key] = $Final_Result;
                                $Train2_Key++;
                                $Train3[$Train3_Key] = $Final_Result;
                                $Train3_Key++;
                                $Train4[$Train4_Key] = $Final_Result;
                                $Train4_Key++;
                                $Train5[$Train5_Key] = $Final_Result;
                                $Train5_Key++;
                            } 
                            elsif ( $Serial_Number eq "0001" ) {
                                $Train1[$Train1_Key] = $Final_Result;
                                $Train1_Key++;
                                $Train2[$Train2_Key] = $Final_Result;
                                $Train2_Key++;
                                $Train3[$Train3_Key] = $Final_Result;
                                $Train3_Key++;
                                $Train4[$Train4_Key] = $Final_Result;
                                $Train4_Key++;
                                $Train5[$Train5_Key] = $Final_Result;
                                $Train5_Key++;
                            } 
                            else {
                                $Result_Array[$Result_Key] = $Final_Result;
                                $Result_Key++;
                            }                
                            $Switch_Result = "Yes";
                        }

                        print "Name: $File_Name , Count : $Count_Key, Limit : $Limit_Key , $Get_Value[1] $Get_Value[2] $Get_Value[3] $Get_Value[4] \n ";
                        print "Position S: $position_status Result: $Final_Result \n";
                        $Count_Key++;
                    }
                    else {
                        $Testing_Array[$Array_Key] = $Get_Value[1];
                        if ( $Switch_Result eq "Yes" ){
                            print "Position $Get_Value[1] \n";
                            $Switch_Result = "No";
                        }
                    }
                    $Array_Key++;
                    $Sub_Array_Key--;
                    if ( $Sub_Array_Key eq 0 ) {
                        $Switch_Key = 1;
                        $Limit_Key = 1;
                        $Count_Key = 1;
                    }
                }
            }
            $line_num++;
            }    
        }

        close (LOG);
        close (ZERO);
        close (TWOORMORE);
    } else {
        print "File not exist \n";
    }
    return @Testing_Array;
}

