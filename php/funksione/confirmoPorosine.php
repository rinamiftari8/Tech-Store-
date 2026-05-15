<?php
if (!isset($_SESSION)) {
    session_start();
}

require_once('../CRUD/porosiaCRUD.php');
require_once('../CRUD/userCRUD.php');

$porosiaCRUD = new porosiaCRUD();
$userCRUD = new userCRUD();

$porosiaID = isset($_GET['porosiaID']) && ctype_digit($_GET['porosiaID']) ? (int) $_GET['porosiaID'] : 0;
if ($porosiaID === 0) {
    header('Location: ../userPages/porosit.php');
    exit();
}

$porosiaCRUD->setPorosiaID($porosiaID);
$porosiaCRUD->setStatusiPorosis('Pranuar Nga Bleresi');

$porosiaCRUD->perditesoStatusinPorosis();

// Send confirmation email
$orderDetails = $porosiaCRUD->shfaqPorosinSipasID();
if ($orderDetails) {
    $userCRUD->setUserID($orderDetails['userID']);
    $user = $userCRUD->shfaqSipasID();

    if ($user && isset($user['email'])) {
        $to = $user['email'];
        $subject = 'Order Confirmation - TechStore';
        $message = "Dear " . $user['emri'] . ",\n\nYour order #" . $porosiaID . " has been confirmed.\n\nOrder Details:\n";
        $message .= "Total: €" . $orderDetails['totali'] . "\n";
        $message .= "Status: Confirmed\n\nThank you for shopping with TechStore!\n\nBest regards,\nTechStore Team";

        $headers = 'From: no-reply@techstore.com' . "\r\n" . 'Reply-To: no-reply@techstore.com' . "\r\n" . 'X-Mailer: PHP/' . phpversion();

        mail($to, $subject, $message, $headers);
    }
}

$_SESSION['konfirmimiPorosis'] = true;
header('Location: ../userPages/porosit.php');
exit();
?>