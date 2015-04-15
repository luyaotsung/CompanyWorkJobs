#!/usr/bin/perl -w 

use strict;


sub get_Result_Array 
{
    my ($Input_File) = @_;
    my $Switch_Key = 1;
    my $Array_Key = 0;
    my $Sub_Array_Key= 0;
    my @Result_Array=();
    my $TMP_String = "";

    if ( -e $Input_File ) {
        open LOG, "<$Input_File" or die "$!";
        my $line_num = 1;
        while (<LOG>) {
            chomp;
            #print "Origianl Line ==> $_ \n "; 
            if ( $Switch_Key eq 1 ) {
                #print "Swtich Key = 1 \n";
                my @array_line_value = split(/\./,$_);
                #print "$array_line_value[0]  $array_line_value[1] \n";
                if ( $array_line_value[1] eq "jpg" ) {
                    $TMP_String = $TMP_String . $_ ;
                    print "TMP String : $TMP_String \n";
                }
                $Switch_Key++;
            }
            elsif ( $Switch_Key eq 2 ) {
                #print "Swtich Key = 2 \n";
                $Sub_Array_Key = $_;
                #$TMP_String = $TMP_String . $_ . " " ;
                $Switch_Key++;
            } 
            elsif ( $Switch_Key eq 3 ) {
                print "Swtich Key = 3 \n";
                if ( $Sub_Array_Key ge 1 ) {
                    my @array_line_value = split(/\t/);
                    if ( ! defined $array_line_value[4] ){
                        $array_line_value[4] = "Empty";
                    }
                    #print "Sub Array Key = $Sub_Array_Key \n";
                    #print "xxx $array_line_value[0] $array_line_value[1] $array_line_value[2] $array_line_value[3] $array_line_value[4] \n";
                    ## $TMP_String = $TMP_String . "$array_line_value[0] $array_line_value[1] $array_line_value[2] $array_line_value[3] $array_line_value[4] ";
                    $Result_Array[$Array_Key] = $TMP_String . " " . $Sub_Array_Key . " " . "$array_line_value[0] $array_line_value[1] $array_line_value[2] $array_line_value[3] $array_line_value[4] ";
                    $Array_Key++;
                    $Sub_Array_Key--;

                    if ( $Sub_Array_Key eq 0 ) {
                        #$Result_Array[$Array_Key] = "$TMP_String" ;
                        #$Array_Key++;
                        $Switch_Key = 1;
                        $TMP_String = "" ;
                    }

                }

            
            }



            $line_num++;
        }
        close (LOG);
    } else {
        print "File not existed \n"
    }

    return @Result_Array ;
}
return 1;
