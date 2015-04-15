#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use LWP::Simple;
use JSON;

my ($Target_List) = @ARGV;
my @Links = ();
my $Links_Count = 0;
my @Size = ("","xlarge","xxlarge","huge");

foreach my $size (@Size){
    open READ, "<$Target_List" or die "$!";
    while (<READ>){
        chomp;
        my $Query = $_;
        for (my $start=0;$start<=64;$start+=8){
            sleep(1);
            my $url = "https://ajax.googleapis.com/ajax/services/search/images?".
                "v=1.0&q=$Query&userip=122.116.68.168&rsz=8".
                "&imgsz=$size&start=$start";

            my $ua = LWP::UserAgent->new();
            $ua->default_header("HTTP_REFERER" => "blog.min-jo.idv.tw" );
            my $body = $ua->get($url);

            # process the json string
            my $json = from_json($body->decoded_content);
            #my $json = decode_json($body->decoded_content);

            # have some fun with the results
            my $count = 0;
            foreach my $result (@{$json->{responseData}->{results}}){
                $Links[$Links_Count] = $result->{url} ;    
                $count++;
                $Links_Count++;
                #print $i.". " . $result->{titleNoFormatting} . "(" . $result->{url} . ")\n";
                # etc....
            }
            if(!$count){
             print "Sorry, but there were no results.\n";
            }

        }
    }
    close(READ);
}

my $p_count = 0;
foreach my $link (@Links){
    my $path = "Images/".sprintf("%.5d",$p_count).".jpg";
    print "$path $link \n";
    getstore($link,$path);
    $p_count++;

} 
