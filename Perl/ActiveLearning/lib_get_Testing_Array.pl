#!/usr/bin/perl -w 

use strict;
sub get_Testing_Array
{
    my ($Input_File) = @_;
    my $Switch_Key = 1;
    my $Array_Key = 0;
    my $Sub_Array_Key= 0;
    my @Testing_Array=();
    my $TMP_String = "";

    if ( -e $Input_File ) {
        open LOG, "<$Input_File" or die "$!";
        my $line_num = 1;
        while (<LOG>) {
        chomp;
        if ( $_ =~ /\[filename\]|\[rec-num\]|\[rec\]/i ){ 
            #print "Origianl Line ==> $_ \n "; 
            my @Get_Value = split(/\t/);
            if ( $Switch_Key eq 1 ) {
                #print "Swtich Key = 1 \n";
                my @array_line_value = split(/\./);
                #print "$array_line_value[0]  $array_line_value[1] \n";
                if ( $array_line_value[1] eq "jpg" ) {
        
                $TMP_String = $TMP_String . $Get_Value[1];
                }
                $Switch_Key++;
            }
            elsif ( $Switch_Key eq 2 ) {
                #print "Swtich Key = 2 \n";
                $Sub_Array_Key = $Get_Value[1];
                #$TMP_String = $TMP_String . $Get_Value[1] . " " ;
                $Switch_Key++;
                if ( $Sub_Array_Key eq 0 ) {
                    $Testing_Array[$Array_Key] = "$TMP_String" . " " . $Sub_Array_Key ;
                    $Array_Key++;
                    $Switch_Key = 1;
                    $TMP_String = "" ;
                }
            } 
            elsif ( $Switch_Key eq 3 ) {
                #print "Swtich Key = 3 \n";
                if ( $Sub_Array_Key ge 1 ) {
                    my @array_line_value = @Get_Value ;
                    if ( ! defined $array_line_value[6] ){
                        $array_line_value[6] = "Empty";
                    }
                    if ( ! defined $array_line_value[7] ){
                        $array_line_value[7] = 0;
                    }
                    #print "Sub Array Key = $Sub_Array_Key \n";
                    #print "xxx $array_line_value[1] $array_line_value[2] $array_line_value[3] $array_line_value[4] $array_line_value[6] \n";
                    #$TMP_String = $TMP_String . "$array_line_value[1] $array_line_value[2] $array_line_value[3] $array_line_value[4] $array_line_value[6] $array_line_value[7] NO ";
                    $Testing_Array[$Array_Key] = $TMP_String . " " . $Sub_Array_Key . " " . "$array_line_value[1] $array_line_value[2] $array_line_value[3] $array_line_value[4] $array_line_value[6] $array_line_value[7]";
                    $Array_Key++;
                    $Sub_Array_Key--;
                    if ( $Sub_Array_Key eq 0 ) {
                        #$Testing_Array[$Array_Key] = "$TMP_String" ;
                        #$Array_Key++;
                        $Switch_Key = 1;
                        $TMP_String = "" ;
                    }
                }
            }
            $line_num++;
        }    
    }
        close (LOG);
    } else {
        print "File not exist \n";
    }
    return @Testing_Array;
}

return 1 ;

