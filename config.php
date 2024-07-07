<?php

$server = getenv('DB_HOST');;
$username = getenv('DB_USERNAME');
$password = getenv('DB_PASS');
$database = getenv('DB_NAME');

$conn = mysqli_connect($server,$username,$password,$database);

if(!$conn){
    die("<script>alert('connection Failed.')</script>");
}
// else{
//     echo "<script>alert('connection successfully.')</script>";
// }
?>