<?php
if (!isset($_SESSION)) {
    session_start();
}

require_once('../adminFunksione/kontrolloAksesAdmin.php');
require_once('../CRUD/porosiaCRUD.php');

$porosiaCRUD = new porosiaCRUD();
$orders = $porosiaCRUD->shfaqTeGjithaPorosite();

// Set headers for CSV download
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=orders_' . date('Y-m-d') . '.csv');

// Create output stream
$output = fopen('php://output', 'w');

// Write CSV headers
fputcsv($output, ['Order ID', 'User Name', 'Email', 'Product Name', 'Quantity', 'Total', 'Status', 'Order Date']);

// Write order data
foreach ($orders as $order) {
    fputcsv($output, [
        $order['porosiaID'],
        $order['emri'] . ' ' . $order['mbiemri'],
        $order['email'],
        $order['emriProduktit'],
        $order['sasia'],
        $order['totali'],
        $order['statusi'],
        $order['dataPorosis']
    ]);
}

fclose($output);
exit();
?>
