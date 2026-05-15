<?php
require_once('../config.php');
require_once('../CRUD/userCRUD.php');

if (!isset($_SESSION)) {
    session_start();
}

if (empty($_GET['state']) || empty($_SESSION['oauth2state']) || $_GET['state'] !== $_SESSION['oauth2state']) {
    unset($_SESSION['oauth2state']);
    header('Location: ../pages/login.php');
    exit();
}

if (isset($_GET['code'])) {
    $tokenUrl = 'https://oauth2.googleapis.com/token';
    $postData = [
        'code' => $_GET['code'],
        'client_id' => GOOGLE_CLIENT_ID,
        'client_secret' => GOOGLE_CLIENT_SECRET,
        'redirect_uri' => GOOGLE_REDIRECT_URI,
        'grant_type' => 'authorization_code'
    ];

    $ch = curl_init($tokenUrl);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/x-www-form-urlencoded']);
    $tokenResponse = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    if ($httpCode !== 200 || !$tokenResponse) {
        header('Location: ../pages/login.php');
        exit();
    }

    $tokenData = json_decode($tokenResponse, true);
    $accessToken = $tokenData['access_token'] ?? null;
    if (!$accessToken) {
        header('Location: ../pages/login.php');
        exit();
    }

    $userInfoUrl = 'https://www.googleapis.com/oauth2/v3/userinfo?access_token=' . urlencode($accessToken);
    $userInfoResponse = file_get_contents($userInfoUrl);
    $userInfo = json_decode($userInfoResponse, true);

    if (empty($userInfo['sub']) || empty($userInfo['email'])) {
        header('Location: ../pages/login.php');
        exit();
    }

    $googleId = $userInfo['sub'];
    $email = $userInfo['email'];
    $firstName = $userInfo['given_name'] ?? '';
    $lastName = $userInfo['family_name'] ?? '';

    $userCRUD = new userCRUD();
    $user = $userCRUD->findOrCreateGoogleUser($googleId, $email, $firstName, $lastName);

    if ($user) {
        session_regenerate_id(true);
        $_SESSION['aksesi'] = $user['aksesi'];
        $_SESSION['userID'] = $user['userID'];
        $_SESSION['name'] = $user['emri'];
        $_SESSION['mbiemri'] = $user['mbiemri'];
        $_SESSION['email'] = $user['email'];
        header('Location: ../pages/index.php');
        exit();
    }
}

header('Location: ../pages/login.php');
exit();
