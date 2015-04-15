#!/bin/perl 

use strict;
use warnings;
use diagnostics;
use File::Find;
use File::Copy;
use File::Basename;
use List::MoreUtils qw{ any };

open (my $filehandle, '>' , "filelog.$ARGV[0]");
open (my $filehandle2, '>' , "NOTPASS.$ARGV[0]");
open (my $filehandle3, '>' , "NewTestCase.$ARGV[0]");

# $debug = "debug" open debug log
#my $debug = "debugfull";
#my $debug = "debugface";
#my $debug = "debugdate";
#my $debug = "debugORface";
my $debug = "off";
my $copyoption = "true"; 

my @Casearray;
#  read test case
sub readTestCase(){
    open(my $fh, "<", $ARGV[0])
        or die "Failed to open file: $!\n";
        while(<$fh>) { 
            chomp; 
            push @Casearray, $_;
        } 
    close $fh;
}

## read tree make filelist
my @FILEList=();

sub wanted() {
    if ($File::Find::name =~ /jpg/ ){
        push(@FILEList , $File::Find::name );
    }
}

sub treefilelist(){
    find( \&wanted, "$ARGV[1]");
}


sub main(){
    foreach (@Casearray) {
        my $lenFACE=0;
        my @CaseType=();
        my @querystring=();
        my @querystringkeyword=();
        my @querystringgps=();
        my @querystringdate=();
        my @querystringface=();
        my @querymode=(); 
        my @DATA=split(/ /,$_);
        s{^\s+|\s+$}{}g foreach @DATA;
        my $lenDATA=$#DATA + 1 ;
        print  "\n $DATA[0] " ;
        print  " $DATA[1] " ;
        my $tempType = $DATA[1];
        $tempType=~ s/\[//g;
        $tempType=~ s/\]//g;
        @CaseType=split(/_/,$tempType);

        if ($DATA[2] && $DATA[2] ne "[]" ){
            my $tempKeyword = $DATA[2];
            $tempKeyword=~ s/\[//g;
            $tempKeyword=~ s/\]//g;
            my @KEYWORD=split(/_/,$tempKeyword);
            my $lenKEYWORD=$#KEYWORD + 1 ;
            #print scalar(@KEYWORD);
            #print "KEYWORD type ".$KEYWORD[0]."\n" if $debug eq "debug" ;;
            $querymode[2]=$KEYWORD[0];
            for ( my $i=1; $i <= $lenKEYWORD ; $i++){
                #print "$KEYWORD[$i] ";
                push (@querystringkeyword , $KEYWORD[$i]);
                push (@querystring , $KEYWORD[$i]);
            }
        }
        if ($DATA[3] && $DATA[3] ne "[]" ){
            my $tempKeyword = $DATA[3];
            $tempKeyword=~ s/\[//g;
            $tempKeyword=~ s/\]//g;
            my @KEYWORD=split(/_/,$tempKeyword);
            my $lenKEYWORD=$#KEYWORD + 1 ;
            #print scalar(@KEYWORD);
            #print "KEYWORD type ".$KEYWORD[0]."\n" if $debug eq "debug" ;;
            $querymode[3]=$KEYWORD[0];
            for ( my $i=1; $i <= $lenKEYWORD ; $i++){
                #print "$KEYWORD[$i] ";
                push (@querystringgps , $KEYWORD[$i]);
                push (@querystring , $KEYWORD[$i]);
            }
        }

        if ($DATA[4] ne "[--------]" ){
            if ($DATA[4]){
                my $DATETIME=$DATA[4];
                $DATETIME =~ s/\[//g;
                $DATETIME =~ s/\]//g;
                $DATETIME =~ s/-/?/g;
                $DATETIME =~ s/\?\?\?\?\?\?\?/\\d{7}/g;
                $DATETIME =~ s/\?\?\?\?\?\?/\\d{6}/g;
                $DATETIME =~ s/\?\?\?\?\?/\\d{5}/g;
                $DATETIME =~ s/\?\?\?\?/\\d{4}/g;
                $DATETIME =~ s/\?\?\?/\\d{3}/g;
                $DATETIME =~ s/\?\?/\\d{2}/g;
                print  "$DATETIME  ";
                push (@querystringdate , $DATETIME);
                push (@querystring , $DATETIME);
            }
        }
        if ($DATA[5] && $DATA[5] ne "[]" ){
            my $tempKeyword = $DATA[5];
            $tempKeyword=~ s/\[//g;
            $tempKeyword=~ s/\]//g;
            my @KEYWORD=split(/_/,$tempKeyword);
            my $lenKEYWORD=$#KEYWORD + 1 ;
            #print scalar(@KEYWORD);
            #print "KEYWORD type ".$KEYWORD[0]."\n" if $debug eq "debug" ;;
            $querymode[5]=$KEYWORD[0];
            for ( my $i=1; $i <= $lenKEYWORD ; $i++){
                #print "FAAAAAAAAAAAAAAAAAAAAAACE  :  $KEYWORD[$i] \n";
                push (@querystringface , $KEYWORD[$i]);
                push (@querystring , $KEYWORD[$i]);
            }
            for my $i ( 0.. $#querystringface ){
                if ($querystringface[$i]){
                    if($querystringface[$i] eq /^$/ || $querystringface[$i] eq /\n/ ){
                        delete $querystringface[$i];
                    }
                }else{
                        delete $querystringface[$i];
                }
            }
            foreach (@querystringface) {
                #刪除空白行
                print "\nquery string Face!!!!!!!!:$_<==END \n" if $debug eq "debugface"  ;
            }

        }





=head
        for ( my $1key=2 ; $key <= 5 ; $key++ ){
            if ($DATA[$key] && $DATA[$key] ne "[]" && $key ne 4 ){
                my $tempKeyword = $DATA[$key];
                $tempKeyword=~ s/\[//g;
                $tempKeyword=~ s/\]//g;
                my @KEYWORD=split(/_/,$tempKeyword);
                my $lenKEYWORD=$#KEYWORD + 1 ;
                #print scalar(@KEYWORD);
                #print "KEYWORD type ".$KEYWORD[0]."\n";
                $querymode[$key]=$KEYWORD[0];
                for ( my $i=1; $i <= $lenKEYWORD ; $i++){
                    #print "$KEYWORD[$i] ";
                    push (@querystring , $KEYWORD[$i]);
                }
            }elsif ($key eq 4 ){
                if ($DATA[4] ne "[--------]" ){
                    if ($DATA[4]){
                        my $DATETIME=$DATA[4];
                        $DATETIME =~ s/\[//g;
                        $DATETIME =~ s/\]//g;
                        $DATETIME =~ s/-//g;
                        #print  "$DATETIME  ";
                        push (@querystring , $DATETIME);
                    }
                }
            }
        }
=cut     
        # QUERY MATCH FILE FROM FILELIST
        my @matches=();
        for my $i (0 .. $#querystring){
            if($querystring[$i]){
                print "Query String ==> " if $debug eq "debug" ;;
                print $querystring[$i] ." " if $debug eq "debug" ; ;
                print "Query String ==> end  \n" if $debug eq "debug" ;;
                if ( $i eq 0) {
                    @matches=FileFilter( $querystring[$i] ,@FILEList);
                }else{
                    @matches=FileFilter( $querystring[$i] ,@matches);
                }
            }
        }
        for my $i ( 0.. $#matches ){
            my ($firstpart,$gpspart,$datepart,$facepart) = FileSplit( $matches[$i]);
            #print $matches[$i]."\n";
            print "querypart ".$firstpart." ".$gpspart." ".$datepart." ".$facepart."\n" if $debug eq "debug" ;;
            
            my $keyword="";
            foreach (@querystringkeyword){
                if($_){
                    $keyword=$keyword."_".$_;
                }
            }
            $keyword=~s/^_//g;
            $keyword=~s/_$//g;
            my $gps="";
            foreach (@querystringgps){
                if($_){
                    $gps=$gps."_".$_;
                }
            }
            $gps=~s/^_//g;
            $gps=~s/_$//g;
            my $face="";
            foreach (@querystringface){
                if($_){
                    $face=$face."_".$_;
                }
            }
            $face=~s/^_//g;
            $face=~s/_$//g;

            my $date=$querystringdate[0];


            print "keyword : ".$keyword." <= end\n" if $debug eq "debug" ;;
            print "Gps : ".$gps." <= end\n" if $debug eq "debug" ;;
            print "Face : ".$face." <= end\n" if $debug eq "debug" ;;
            if ( $keyword ){
                if ( $querymode[2] eq "&" ) {
                    if ($keyword ne $firstpart ){
                        delete $matches[$i];
                        print "$keyword    $firstpart \n" if $debug eq "debug" ;;
                    }
                }
            }
            if ($gps){
                if ( $querymode[3] eq "&" ) {
                    if ($gpspart =~ /$gps/ ){
                        print "match gps \n" if $debug eq "debug" ;;
                    }else{
                        delete $matches[$i];
                        print "GPS : $gps    $gpspart \n" if $debug eq "debug" ;;
                    }
                }
            }
            
            if ($date){
                $datepart=substr($datepart,0,8);
                if ( $datepart =~ /$date/ ){
                    my $dateyear=substr($datepart,0,4);
                    my $datemon=substr($datepart,4,2);
                    my $dateday=substr($datepart,6,2);
                    my $queryyear=substr($date,0,4);
                    my $querymon=substr($date,4,2);
                    my $queryday=substr($date,6,2);

                    print "date match \n" if $debug eq "debugdate" ;;
                }else{
                    delete $matches[$i];
                    print "date : $date    $datepart \n" if $debug eq "debugdate" ;
                }
            }

            if ($face){
                if ( $querymode[5] eq "&" ) {
                    if ( $facepart ne $face ){
                        my @fileface=split(/_/,$facepart);
                        my $lenfileface=$#fileface+1;
                        my $lenqueryface=$#querystringface+1;
                        if ($lenqueryface eq $lenfileface){
                            my $Del_Flag=0;
                            for my $ff ( 0.. $#fileface ){
                                for my $qsf ( 0.. $#querystringface ){
                                    if($querystringface[$qsf]){
                                        if ($fileface[$ff] ne $querystringface[$qsf]){
                                            $Del_Flag++;
                                        }
                                    }
                                }
                            }
                            if ($Del_Flag > 0 ){
                                delete $matches[$i];
                            }
                            print "file part : $facepart  fileface : @fileface \n" if $debug eq "debugface"  ;
                            print "len qface : $lenqueryface len fileface : $lenfileface \n" if $debug eq "debugface"  ;
                            print "query : @querystringface file: @fileface \n" if $debug eq "debugface"  ;
                            print "match face \n" if $debug eq "debug" ;

                        }else{
                            delete $matches[$i];
                            print "FACE : $face  $facepart \n" if $debug eq "debug" ;
                        }
                    }else{
                        print "match face \n" if $debug eq "debug" ;
                    }
                }else{
                    my $del_flag=0;
                    my @fileface=split(/_/,$facepart);
                    my $lenfileface=$#fileface+1;
                    my $lenqueryface=$#querystringface+1;
                    foreach my $qs (@querystringface){
                        my $temp = "_".$qs."_";
                        #print "facepart =>$facepart<=\n";
                        $facepart = "_".$facepart."_";
                        if (grep /$temp/ , $matches[$i]){
                            $del_flag++; 
                        }else{
                            $del_flag=0;
                        }
                    }
                    if ($del_flag != $lenqueryface ){
                            delete $matches[$i];
                    }
=head                    
                    for my $ff ( 0.. $#fileface ){
                        if (any { $_ eq $fileface[$ff] } @querystring) {
                            $del_flag++; 
                            print "match face  $face  @fileface \n" if $debug eq "debugORface" ;
                            next ;
                        }else{
                            print "FACE : $face  @fileface \n" if $debug eq "debugORface" ;
                        }
                    }
=cut                    
                    if ($del_flag == 0 ){
                            delete $matches[$i];
                    }

                    print "file part : $facepart  fileface : @fileface \n" if $debug eq "debugface"  ;
                    print "len qface : $lenqueryface len fileface : $lenfileface \n" if $debug eq "debugface"  ;
                    print "query : @querystringface file: @fileface \n" if $debug eq "debugface"  ;
                    print "match face \n" if $debug eq "debug" ;


                }
            }
        }


    # print match file list 
        print "Match file list ==> "  if $debug eq "debugfull";;
        foreach (@matches){
            print " $_  \n" if $debug eq "debugfull";
        }
        print "<== End Match file list" if $debug eq "debugfull";;



        my @FileNumList=();
        my $directory = $ARGV[2].$DATA[0].$DATA[1];
        foreach (@matches){
            unless(-e $directory or mkdir $directory) {
                die "unable to create $directory";
            }
            if ($_){
                if ($copyoption eq "true" ){
                    copy($_, $directory) || die "copy: $!";
                }
                print $_ ."\n" if $debug eq "debugonly";;
            }
            my $filepath = $_;
            if($filepath){
                $filepath =~ s!^.*/([^/]*)$!$1!;
                #print $filepath."\n";
                my @FILENAME=split(/_/,$filepath);
                push (@FileNumList , $FILENAME[0]);
            }
            
        }

        my $lenmathes=$#FileNumList + 1 ;
        my $NumList="";
        for my $index (0 .. $#FileNumList){
            if ( $index eq 0) {
                $NumList=$FileNumList[$index];
            }else{
                if ( $FileNumList[$index] && $NumList ){
                    $NumList=$NumList." ".$FileNumList[$index];
                }
            }
        }
        my    $linetitle = $DATA[0];
        $linetitle =~ s!^\[!!;
        $linetitle =~ s!\]$!!;
        print "len matches ".$lenmathes."\n";
        if ( $lenmathes >= 3 ) {

            print $filehandle "$linetitle $lenmathes $NumList\n";


            print $filehandle3 "$DATA[0] $DATA[1] $DATA[2] $DATA[3] $DATA[4] $DATA[5]\n";
        }else {
            if ($NumList){
                print $filehandle2 "$linetitle $lenmathes $NumList\n";
            }
        }

    }
}
&readTestCase;
&treefilelist;
&main;

close $filehandle;
close $filehandle2;
close $filehandle3;

=head
    # ALL FILE LIST FROM SOURCE
    foreach my $i (@FILEList){
        print "$i \n" ;
    }
=cut


sub FileFilter(){
    #GREP QUERYITEM FROM INPUTARRAY
    my($queryitem,@inputarray) =@_;
    my @outputarray=();
    if ($queryitem eq "M1" ){
        $queryitem = ".*[^G]".$queryitem.".*";
    }
    #print $queryitem."\n";
    if ($queryitem){
        @outputarray = grep( /$queryitem/ , @inputarray) ; 
    }
    return (@outputarray);
}


sub FileSplit(){
    my($filefullname) =@_;
    #my $filefullname="../without_Face-single/Scenario/OutCity/OutCity5/L-23.971872N-121.593789E_D-201203230900/GM1_G1/06302_Scenario_OutCity_OutCity5_L-Taiwan_Ilan_D-201203230904_GM1_G1_1.jpg";
    #04504_Scenario_Abroad_Abroad1_L-Japan_Tokyo_D-201106171908_GM1_G1_G2_1.jpg";
    #
    my $queryitem= basename $filefullname ;
    $queryitem=~ s/^[0-9]{5}_//g;
    print $queryitem."\n" if $debug eq "debugFile";
    my $firstpart = $queryitem ;
    $firstpart =~ s/_L-.*//g;
    print $firstpart."\n" if $debug eq "debugFile";
    my $gpspart = $queryitem ;
    $gpspart =~ s/^.*_L-//g;
    $gpspart =~ s/_D-.*//g;
    print $gpspart."\n" if $debug eq "debugFile";
    my $datepart = $queryitem ;
    $datepart =~ s/^.*_D-//g;
    $datepart =~ s/_.*$//g;
    print "$datepart\n" if $debug eq "debugFile";
    my $facepart = $queryitem ;
    $facepart =~ s/_[0-9].*[.]jpg//g;
    $facepart =~ s!^.*D-$datepart[_]!!g;
    print $facepart."\n" if $debug eq "debugFile";

    return ($firstpart , $gpspart , $datepart , $facepart);
}


