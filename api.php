<?php
date_default_timezone_set("Asia/Manila");

header("Content-Type: application/json");

// FILES
$voucher_file = "vouchers.json";
$current_file = "current.txt";
$config_file = "config.json";
$logs_file = "logs.json";

// SAFE LOAD
function load_json($file){
    if(!file_exists($file)){
        file_put_contents($file, json_encode([], JSON_PRETTY_PRINT));
    }
    $data = json_decode(file_get_contents($file), true);
    return is_array($data) ? $data : [];
}

// INPUT
$amount = $_GET['amount'] ?? 0;
$ip = $_SERVER['REMOTE_ADDR'];
$mac = $_GET['mac'] ?? "unknown";

// LOAD DATA
$data = load_json($voucher_file);
$config = load_json($config_file);
$logs = load_json($logs_file);

// CHECK STOCK
if(!isset($data[$amount]) || count($data[$amount]) == 0){
    echo json_encode([
        "status" => "error",
        "msg" => "No voucher available"
    ]);
    exit;
}

// GET VOUCHER (AUTO REMOVE)
$voucher = array_shift($data[$amount]);

// SAVE UPDATED VOUCHERS
file_put_contents($voucher_file, json_encode($data, JSON_PRETTY_PRINT));

// SAVE CURRENT
file_put_contents($current_file, $voucher);

// 💰 EARNINGS
if(!isset($config['earnings'])) $config['earnings'] = 0;
$config['earnings'] += intval($amount);
file_put_contents($config_file, json_encode($config, JSON_PRETTY_PRINT));

// 🧠 SAVE LOG (HISTORY, NOT OVERWRITE)
$logs[] = [
    "voucher" => $voucher,
    "amount" => $amount,
    "time" => date("Y-m-d H:i:s"),
    "ip" => $ip,
    "mac" => $mac
];

file_put_contents($logs_file, json_encode($logs, JSON_PRETTY_PRINT));

// RESPONSE
echo json_encode([
    "status" => "success",
    "voucher" => $voucher,
    "amount" => $amount
]);
