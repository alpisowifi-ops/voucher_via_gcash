<?php
$config = json_decode(file_get_contents("config.json"), true);
?>

<!DOCTYPE html>
<html>
<head>
<title>Buy WiFi Voucher</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
body {
    font-family: Arial;
    text-align: center;
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    color:white;
    margin:0;
}

.box {
    background:white;
    color:black;
    margin:20px;
    padding:20px;
    border-radius:15px;
}

button {
    padding:15px;
    margin:10px;
    width:90%;
    border:none;
    border-radius:10px;
    font-size:16px;
    font-weight:bold;
}

.btn-price { background:#2196F3; color:white; }
.btn-paid { background:#00c853; color:white; }
.btn-download { background:#607d8b; color:white; }

img {
    width:220px;
    border-radius:10px;
}
</style>
</head>

<body>

<h2>📶 Buy WiFi Voucher</h2>

<!-- PRICE (DYNAMIC WITH LABEL) -->
<div class="box">
    <h3>💸 Select Amount</h3>

    <?php foreach($config['rates'] as $r): ?>
        <button class="btn-price" onclick="selectAmount(<?= $r['amount'] ?>)">
            ₱<?= $r['amount'] ?> - <?= $r['label'] ?>
        </button>
    <?php endforeach; ?>

</div>

<!-- QR (DYNAMIC) -->
<div class="box">
    <h3>📷 Scan QR to Pay</h3>

    <img src="<?= $config['qr'] ?>"><br><br>

    <a href="<?= $config['qr'] ?>" download>
        <button class="btn-download">⬇ Download QR</button>
    </a>

    <button class="btn-paid" onclick="paidClick()">✅ I HAVE PAID</button>
</div>

<!-- INSTRUCTIONS -->
<div class="box">
    <h3>📌 How to Use</h3>
    <ul style="text-align:left; font-size:14px; line-height:1.8; padding-left:20px;">
        <li>Scan QR or download it</li>
        <li>Open GCash / banking app</li>
        <li>Upload or scan QR</li>
        <li>Enter exact amount</li>
        <li>Complete payment</li>
        <li>Tap <b>I HAVE PAID</b></li>
        <li>Wait for voucher</li>
        <li>Auto connect to WiFi</li>
    </ul>
</div>

<script>

// SAVE AMOUNT
function selectAmount(amount){
    localStorage.setItem("selected_amount", amount);
    alert("👉 Please pay ₱" + amount);
}

// REDIRECT
function paidClick(){
    let amount = localStorage.getItem("selected_amount");

    if(!amount){
        alert("⚠️ Please select amount first");
        return;
    }

    window.location.href = "wait.php?amount=" + amount;
}

</script>

</body>
</html>