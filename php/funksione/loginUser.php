<?php
require('../funksione/security.php');
require('../CRUD/userCRUD.php');

if (!isset($_SESSION)) {
    session_start();
}

if (isset($_POST['login'])) {
    if (!validateCSRFToken($_POST['csrf_token'] ?? '')) {
        $_SESSION['error'] = 'Invalid request';
        header('Location: ../pages/login.php');
        exit();
    }
    $userCRUD = new userCRUD();
    $username = trim($_POST['username'] ?? '');
    $userCRUD->setUsername($username);
    $kontrolloUser = $userCRUD->kontrolloLlogarin();

    if (!$kontrolloUser) {
        $userCRUD->setEmail($username);
        $kontrolloUser = $userCRUD->findUserByEmail();
    }

    if ($kontrolloUser == true) {
        if ($kontrolloUser['verified'] == 0) {
            $_SESSION['notVerified'] = true;
            header('Location: ../pages/login.php');
            exit();
        }
        $kontrolloPass = password_verify($_POST['password'] ?? '', $kontrolloUser['password']);

        if ($kontrolloPass == true) {
            session_regenerate_id(true);
            $_SESSION['aksesi'] = $kontrolloUser['aksesi'];
            $_SESSION['userID'] = $kontrolloUser['userID'];
            $_SESSION['name'] = $kontrolloUser['emri'];
            $_SESSION['mbiemri'] = $kontrolloUser['mbiemri'];
            $_SESSION['email'] = $kontrolloUser['email'];
            $_SESSION['loginSuccess'] = true;
            header('Location: ../pages/index.php');
            exit();
        } else {
            $_SESSION['passGabim'] = true;
            header('Location: ../pages/login.php');
            exit();
        }
    } else {
        $_SESSION['uNameGabim'] = true;
        header('Location: ../pages/login.php');
        exit();
    }
}
?>