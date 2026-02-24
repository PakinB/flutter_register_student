<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') exit(0);

$conn = new mysqli("localhost","root","","shop");
if ($conn->connect_error) die("db_error");

$student_id = $_POST['student_id'];
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$department = $_POST['department'];

$imageName = time().'_'.basename($_FILES['image']['name']);
move_uploaded_file($_FILES['image']['tmp_name'], __DIR__."/images/".$imageName);

$stmt = $conn->prepare(
"INSERT INTO users (student_id,name,email,phone,department,image)
 VALUES (?,?,?,?,?,?)"
);

$stmt->bind_param(
"ssssss",
$student_id,$name,$email,$phone,$department,$imageName
);

echo $stmt->execute() ? "success" : "error";

$stmt->close();
$conn->close();
?>