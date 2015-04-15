#!/usr/bin/php


<?php

require_once( "phpFlickr.php" );

$filepath = $argv[1];

function photo_list ($tags , $page, $per_page){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $d = $o->photos_search( array(
                'tags' => $tags ,
                'content_type' => 1 ,
                'sort' => 'date-posted-asc' ,
                'extras' => 'url_o,url_l',
                'page' => $page ,
                'per_page' =>  $per_page 
                )   
            );
    for($index = 0 ; $index <= $per_page ; $index++){
        if(!empty( $d['photo'][$index]['url_o'] )){
            print_r( $d['photo'][$index]['url_o'] ."\n");
            $downfile =  $d['photo'][$index]['url_o'] ;
	    $dir = str_replace(" ","_",$tags);
            system( "wget $downfile -P $dir");
        }elseif(!empty( $d['photo'][$index]['url_l'] )){
            print_r( $d['photo'][$index]['url_l'] ."\n");
            $downfile =  $d['photo'][$index]['url_l'] ;
            $path = `pwd`;
	    $dir = str_replace(" ","_",$tags);
            system( "wget  $downfile -P $dir");
            #system( "wget $downfile ");
        }else{
            print ("orignal and large size is not available \n");
        }
    }
}


function total_photo ($tags  ){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $d = $o->photos_search( array(
                'tags' => $tags ,
                'content_type' => 1 ,
                'sort' => 'date-posted-asc' ,
                'extras' => 'url_o,url_l',
                'page' => 1 ,
                'per_page' => 500 
                )   
            );
    print_r ( "total page :".$d['pages'] );
    $total_page = $d['pages'] ;
    print_r ( "total photo :".$d['total'] );
    $total_photo = $d['total'] ;
    $dir = str_replace(" ","_",$tags);
    system (" mkdir $dir");

    photo_list ($tags , 1, 500) ;
}


$handle = fopen($filepath, "r");
if ($handle) {
    while (($line = fgets($handle)) !== false) {
        // process the line read.
        total_photo ($line  ) ;
    }
} else {
    // error opening the file.
    print "error openfile";
}




?>
