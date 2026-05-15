<?php
if (!isset($_SESSION)) {
    session_start();
}

if (!isset($_SESSION['userID']) || $_SESSION['userID'] == '') {
    header('Location: ../pages/index.php');
    exit();
}


?>