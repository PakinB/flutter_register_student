<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') exit(0);

$conn = new mysqli("localhost","root","","shop");
if ($conn->connect_error) die(json_encode(["error"=>"db_error"]));

$result = $conn->query(
"SELECT id,student_id,name,email,phone,department,image 
 FROM students ORDER BY id DESC"
);

$data = [];
while($row = $result->fetch_assoc()){
    $data[] = $row;
}

echo json_encode($data);
$conn->close();
?>