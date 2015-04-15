#!/usr/bin/php


<?php

require_once( "phpFlickr.php" );

$tags = $argv[1];
$camera = $argv[2];

function photo_list ($tags , $camera, $page, $per_page){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $d = $o->photos_search( array(
                'tags' => $tags ,
                'content_type' => 1 ,
                'sort' => 'date-posted-asc' ,
                'camera' => $camera ,
                'extras' => 'url_o,url_l',
                'page' => $page ,
                'per_page' =>  $per_page 
                )   
            );
    if($per_page >= 500 ){
        $per_page = 499;
    }else{
        $per_page -= 1 ;
    }
    for($index = 0 ; $index <= $per_page ; $index++){
        if(!empty( $d['photo'][$index]['url_o'] )){
            print_r( $d['photo'][$index]['url_o'] ."\n");
        }elseif(!empty( $d['photo'][$index]['url_l'] )){
            print_r( $d['photo'][$index]['url_l'] ."\n");
        }else{
            print ("orignal and large size is not available \n");
        }
    }
}


function total_photo ($tags , $camera ){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $d = $o->photos_search( array(
                'tags' => $tags ,
                'content_type' => 1 ,
                'sort' => 'date-posted-asc' ,
                'camera' => $camera ,
                'extras' => 'url_o,url_l',
                'page' => 1 ,
                'per_page' => 500 
                )   
            );
    print_r ( "total page :".$d['pages'] );
    $total_page = $d['pages'] ;
    print_r ( "total photo :".$d['total'] );
    $total_photo = $d['total'] ;
    for( $page = 1 ; $total_page >= $page ; $page++ ){
        print ("page $page \n");
        if ($total_photo >= 500 ){
            $total_photo -= 500 ;
            photo_list ($tags , $camera, $page, 500) ;
        }else{
            photo_list ($tags , $camera, $page, $total_photo) ;
        }
    }
}


 total_photo ($tags , $camera ) ;
?>
