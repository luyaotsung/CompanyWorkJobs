#!/usr/bin/php
<?php

require_once( "phpFlickr.php" );

$filepath = $argv[1];

function photo_list ($tags , $page, $per_page){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $d = $o->photos_search( array(
                'user_id' => "$tags" ,
                'content_type' => 1 ,
                'sort' => 'date-posted-asc' ,
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
    $tags = trim( preg_replace('/\s\s+/',' ' , $tags ));	
    $d = $o->photos_search( array(
                'user_id' => $tags ,
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
    for( $page = 1 ; $total_page >= $page ; $page++ ){
        print ("page $page \n");
        if ($total_photo >= 500 ){
            $total_photo -= 500 ;
            photo_list ($tags , $page, 500) ;
        }else{
            photo_list ($tags , $page, $total_photo) ;
        }
    }
}

function UserID_sets_List($user_id){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $d = $o->photosets_getList ( $user_id) ;
    #print_r($d);
    print_r ( "total Sets :".$d['total']."\n" );
    $total_sets = $d['total'] ;
    for( $set = 0 ; $total_sets > $set ; $set++ ){
        print ("Set : $set ");
        print ($d['photoset'][$set]['id'] ) ;
        $dir_name =  $d['photoset'][$set]['title'] ;
        print ($dir_name ."\n" ) ;
        $dir_name = str_replace(" ","\ ",$dir_name);
        $dir_name = str_replace("'","\'",$dir_name);
        $dir_name = str_replace("/","\/",$dir_name);
        $dir_name = str_replace("(","-",$dir_name);
        $dir_name = str_replace(")","-",$dir_name);
        $dir_name = str_replace("|","-",$dir_name);
        $dir_name = str_replace("&","-",$dir_name);
        $dir_name = trim($dir_name);
        system( "mkdir -p $user_id/$dir_name");
        
        system( "touch $user_id/log");
        $path = $user_id."/".$dir_name ;
        system ( "echo  '$path'  >>  $user_id/log "); 
        UserSets_Get_Photos ($d['photoset'][$set]['id'] ,$path) ;
    }

}

function UserSets_Get_Photos ($photosets_id  , $path){
    $o = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
    $extras='url_o,url_l';
    $d = $o->photosets_getPhotos ( $photosets_id , $extras );
    $total_pages = $d['photoset']['pages'];
    $total_photos = $d['photoset']['total'];
    print ("total photos : $total_photos \ntotal_pages : $total_pages \n");
    #print_r($d);
    for($index_page = 1 ; $index_page <= $total_pages ; $index_page++ ){
        print ( "page : $index_page \n");
        $key = new phpFlickr( '6791ccf468e1c2276c1ba1e0c41683a4' );
        $extras='url_o,url_l';
        $set_data = $key->photosets_getPhotos( $photosets_id, $extras,NULL,NULL,$index_page);
        for($index = 0 ; $index <= 500 ; $index++){
            if(!empty( $set_data['photoset']['photo'][$index]['url_o'] )){
                #print_r( "photo $index : ". $set_data['photoset']['photo'][$index]['url_o'] ."\n");
                $downfile =  $set_data['photoset']['photo'][$index]['url_o'] ;
                system( "wget -nc $downfile -P $path");
            }elseif(!empty( $set_data['photoset']['photo'][$index]['url_l'] )){
                #print_r( "photo $index : ".$set_data['photoset']['photo'][$index]['url_l'] ."\n");
                $downfile =  $set_data['photoset']['photo'][$index]['url_l'] ;
                system( "wget -nc $downfile -P $path");
            }
           # else{
           #     print ("orignal and large size is not available \n");
           # }
        }
    }

}


$handle = fopen($filepath, "r");
if ($handle) {
    while (($line = fgets($handle)) !== false) {
        // process the line read.
        $line = trim(preg_replace('/\s\s+/', ' ', $line));
	    #total_photo ($line) ;

	    UserID_sets_List ($line);
    }
} else {
    // error opening the file.
    print "error openfile";
}



?>
