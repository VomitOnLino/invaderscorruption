<?php
	/*
		=============================================================
		Highscores mit BMax austauschen
		=============================================================
	*/
	extract($_REQUEST);
	extract($_POST);
	extract($_REQUEST);
	extract($_SERVER);
	
	include "mysql.php";
	
	define("ACTION_GETSCORE"		,  1);
	define("ACTION_SETSCORE"		,  2);
	define("ACTION_KILLSCORE"		,  3);
	define("ACTION_RESETTABLE"		,  4);
	define("ACTION_COUNTSCORES"		,  5);
	
	$ip		= getenv("REMOTE_ADDR");
	$datum	= date("Y-m-d H:i:s");
	
	if(!$action)
	{
		$action		= $_POST["action"];
		$v			= $_POST["v"];
		$user		= $_POST["user"];
		$score		= $_POST["score"];
		$sc			= $_POST["sc"];
	}
	
	switch($action)
	{
		/*
			---------------------------------------------------------
			Highscore ausgeben
			---------------------------------------------------------
		*/
		case ACTION_GETSCORE :
			$query	= "SELECT 
						id,
						datum,						
						user, 
						score, 
						version 
						FROM ".$tblp."scores 
						WHERE version='$v' 
						ORDER BY score DESC";
			
			if($l > 0) $query.= " LIMIT $f, $l";
			
			$result	= MYSQL_QUERY($query);
			while($row = MYSQL_FETCH_OBJECT($result))
			{
				echo $row->id."\n";
				echo $row->user."\n";
				echo $row->score."\n";
				echo $row->datum."\n";
			}
			
			break;
		
		
		
		/*
			---------------------------------------------------------
			Neuen Score eintragen
			---------------------------------------------------------
		*/
		case ACTION_SETSCORE :
			$query	= "INSERT INTO ".$tblp."scores (
						datum,
						user,
						ip,
						score,
						version
						) VALUES (
						'$datum',
						'$user',
						'$ip',
						'$score',
						'$v')";
			$result	= MYSQL_QUERY($query);
			if($result){ echo "success\n"; }else{ echo "failed\n"; }
			
			break;
		
		
		
		/*
			---------------------------------------------------------
			Score löschen
			---------------------------------------------------------
		*/
		case ACTION_KILLSCORE :
			$query	= "DELETE FROM ".$tblp."scores WHERE id=$sc";
			$result = MYSQL_QUERY($query);
			if($result){ echo "success\n"; }else{ echo "failed\n"; }
			
			break;
			
			
			
		/*
			---------------------------------------------------------
			Tabelle zurücksetzen
			---------------------------------------------------------
		*/
		case ACTION_RESETTABLE :
			$query	= "TRUNCATE TABLE `".$tblp."scores`";
			$result = MYSQL_QUERY($query);
			if($result){ echo "success\n"; }else{ echo "failed\n"; }
			
			break;
			
		
		/*
			---------------------------------------------------------
			Anzahl der Scores zurückgeben
			---------------------------------------------------------
		*/
		case ACTION_COUNTSCORES :
			$query	= "SELECT id FROM ".$tblp."scores WHERE version=$v"; 
			$result	= MYSQL_QUERY($query);
			
			echo MYSQL_NUM_ROWS($result);
			
			break;
	}
?>