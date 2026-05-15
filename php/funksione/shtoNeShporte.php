<?php
if (!isset($_SESSION)) {
  session_start();
}

if (isset($_POST['blej'])) {
  unset($_SESSION["shportaBlerjes"]);
}


if (isset($_SESSION["shportaBlerjes"])) {

  $IdProduktit = array_column($_SESSION["shportaBlerjes"], "produktiID");
  if (!in_array($_POST["produktiID"], $IdProduktit)) {
    $produktiID = (int) ($_POST["produktiID"] ?? 0);
    $qmimiProduktit = (float) ($_POST["qmimiProduktit"] ?? 0);
    $sasia = (int) ($_POST["sasia"] ?? 1);

    if ($produktiID <= 0 || $qmimiProduktit <= 0 || $sasia <= 0) {
      $_SESSION['error'] = 'Invalid product data';
      header('Location: ../pages/index.php');
      exit();
    }

    $Produkti = array(
      'produktiID' => $produktiID,
      'emriProduktit' => htmlspecialchars(trim($_POST["emriProduktit"]), ENT_QUOTES, 'UTF-8'),
      'qmimiProduktit' => $qmimiProduktit,
      'sasia' => $sasia,
    );
    array_push($_SESSION['shportaBlerjes'], $Produkti);
    if (isset($_POST['blej'])) {
      header('Location: ../pages/shporta.php');
      exit();
    } else {
      $_SESSION['uShtuaNeShport'] = true;
      header('Location: ../pages/produktet.php');
      exit();
    }
  } else {
    $_SESSION['ekzistonNeShport'] = true;
    header('Location: ../pages/produktet.php');
    exit();
  }
} else {

  $Produkti = array(
    'produktiID' => $_POST["produktiID"],
    'emriProduktit' => $_POST["emriProduktit"],
    'qmimiProduktit' => $_POST["qmimiProduktit"],
    'sasia' => 1,
  );
  $_SESSION["shportaBlerjes"][0] = $Produkti;
  if (isset($_POST['blej'])) {
    header('Location: ../pages/shporta.php');
    exit();
  } else {
    $_SESSION['uShtuaNeShport'] = true;
    header('Location: ../pages/produktet.php');
    exit();
  }
}

?>