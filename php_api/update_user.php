<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') exit(0);

$conn = new mysqli("localhost","root","","shop");
if ($conn->connect_error) die("db_error");

$id = $_POST['id'];
$student_id = $_POST['student_id'];
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$department = $_POST['department'];

if(isset($_FILES['image']) && $_FILES['image']['name']!=''){
    $imageName = time().'_'.basename($_FILES['image']['name']);
    move_uploaded_file($_FILES['image']['tmp_name'], __DIR__."/images/".$imageName);

    $stmt = $conn->prepare(
    "UPDATE students SET student_id=?,name=?,email=?,phone=?,department=?,image=? WHERE id=?"
    );
    $stmt->bind_param(
    "ssssssi",
    $student_id,$name,$email,$phone,$department,$imageName,$id
    );
}else{
    $stmt = $conn->prepare(
    "UPDATE students SET student_id=?,name=?,email=?,phone=?,department=? WHERE id=?"
    );
    $stmt->bind_param(
    "sssssi",
    $student_id,$name,$email,$phone,$department,$id
    );
}

echo $stmt->execute() ? "success" : "error";

$stmt->close();
$conn->close();
?>