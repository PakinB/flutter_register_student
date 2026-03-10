<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

$conn = new mysqli("localhost","root","","shop");

if ($conn->connect_error) {
    die(json_encode(["status"=>"db_error"]));
}

/* รับค่าจาก Flutter */
$student_id = $_POST['student_id'] ?? '';
$name       = $_POST['name'] ?? '';
$email      = $_POST['email'] ?? '';
$phone      = $_POST['phone'] ?? '';
$department = $_POST['department'] ?? '';

$imageName = "";

/* ตรวจสอบว่ามีไฟล์ภาพ */
if(isset($_FILES['image']) && $_FILES['image']['error'] == 0){

    $imageName = time().'_'.basename($_FILES['image']['name']);

    $targetDir = __DIR__."/images/";

    if(!is_dir($targetDir)){
        mkdir($targetDir,0777,true);
    }

    $targetPath = $targetDir.$imageName;

    move_uploaded_file($_FILES['image']['tmp_name'],$targetPath);
}

/* บันทึกข้อมูล */
$stmt = $conn->prepare(
"INSERT INTO students (student_id,name,email,phone,department,image)
 VALUES (?,?,?,?,?,?)"
);

$stmt->bind_param(
"ssssss",
$student_id,
$name,
$email,
$phone,
$department,
$imageName
);

if($stmt->execute()){
    echo json_encode([
        "status"=>"success"
    ]);
}else{
    echo json_encode([
        "status"=>"error"
    ]);
}

$stmt->close();
$conn->close();
?>