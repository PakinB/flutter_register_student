<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') exit(0);

$conn = new mysqli("localhost","root","","shop");
if ($conn->connect_error) die("db_error");

$id = $_POST['id'];

$stmt = $conn->prepare("DELETE FROM users WHERE id=?");
$stmt->bind_param("i",$id);

echo $stmt->execute() ? "success" : "error";

$stmt->close();
$conn->close();
?>