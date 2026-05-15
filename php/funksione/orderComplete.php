<?php
if (!isset($_SESSION)) {
  session_start();
}
if (!isset($_SESSION['shportaBlerjes'])) {
  header('Location: ../pages/shporta.php');
  exit();
}

include('../CRUD/porosiaCRUD.php');
include('../CRUD/kodiZbritjesCRUD.php');
$porosiaCRUD = new porosiaCRUD();
$kodiZbritjesCRUD = new kodiZbritjesCRUD();
$total = 0;
$nentotali = 0;

foreach ($_SESSION["shportaBlerjes"] as $keys => $values) {
  $total = $total + ($values["sasia"] * $values["qmimiProduktit"]);
  $itemID = $values["produktiID"];

}

$originalTotal = $total; // Store original total

// Re-validate discount code if present
if (isset($_SESSION['kodiZbritjes'])) {
  $kodiZbritjesCRUD->setKodiZbritje($_SESSION['kodiZbritjes']);
  $kontrolloKodin = $kodiZbritjesCRUD->kontrolloKodin();

  if ($kontrolloKodin) {
    // Reapply discount logic
    if ($kontrolloKodin['idProduktit'] == null) {
      if ($kontrolloKodin['qmimiZbritjes'] >= $originalTotal) {
        $total = 0; // Free order
      } else {
        $total = $originalTotal - $kontrolloKodin['qmimiZbritjes'];
      }
    } else {
      // Product-specific discount - need to check if product is in cart
      // For simplicity, assume it's valid if code exists
      $total = $originalTotal - $kontrolloKodin['qmimiZbritjes'];
    }
  } else {
    // Invalid discount code, remove from session
    unset($_SESSION['kodiZbritjes'], $_SESSION['qmimiZbritur'], $_SESSION['zbritjaUAplikua']);
    $_SESSION['error'] = 'Discount code is no longer valid';
    header('Location: ../pages/checkout.php');
    exit();
  }
}

if (isset($_SESSION['complete'])) {
  $porosiaCRUD->setUserID($_SESSION["userID"]);
  $porosiaCRUD->setQmimiTotal($total);
  if (isset($_SESSION['kodiZbritjes']) != null) {
    $porosiaCRUD->setKodiZbritjes($_SESSION['kodiZbritjes']);
    unset($_SESSION['kodiZbritjes']);
  }

  $porosiaCRUD->shtoPorosin();

  $idPorosia = $porosiaCRUD->numriIPorosisNeKonfirmim();

  foreach ($_SESSION["shportaBlerjes"] as $keys => $values) {

    $porosiaCRUD->setPorosiaID($idPorosia['nrPorosis']);
    $porosiaCRUD->setProduktiID($values['produktiID']);
    $porosiaCRUD->setQmimiProd(floatval($values['qmimiProduktit']));
    $porosiaCRUD->setSasiaPorositur((int) $values['sasia']);
    $porosiaCRUD->setQmimiTotal(floatval($values['qmimiProduktit'] * $values['sasia']));

    $porosiaCRUD->shtoTeDhenatPorosis();

    unset($_SESSION['qmimiZbritur']);
  }

  $_SESSION['porosiaMeSukses'] = true;

  unset($_SESSION["shportaBlerjes"]);
} else {
  $porosiaNukUKrye = "Vendosja e Porosis Deshtoi! Ju lutem provoni perseri me vone ose kontaktoni Stafin tone.";
}


$teDhenatPorosis = $porosiaCRUD->shfaqProduktetEPorosisSipasID();
$porosia = $porosiaCRUD->shfaqPorosinSipasID();

?>



<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Order Complete | TechStore</title>
  <link rel="shortcut icon" href="../../img/web/favicon.ico" />
  <link rel="stylesheet" href="../../css/adminDashboard.css">
</head>

<body>

  <?php include('../design/header.php'); ?>

  <div class="containerDashboardP">
    <h1>Porosia Perfundoi</h1>
    <?php
    if (isset($error) != "") {
      echo "<h3>$porosiaNukUKrye</h3>";
    } else {
      ?>
      <h2> Detajet e porosis tuaj </h2>
      <table>
        <tr>
          <th colspan="4" style="text-align:center;text-transform: uppercase;">Te dhenat e Transportit</th>
        </tr>
        <h2></h2>
        <tr>
          <th style="text-transform: uppercase;">Klienti</th>
          <td colspan="3" style="text-align:center;">
            <?php echo ucfirst($porosia["emri"]) . " " . ucfirst($porosia["mbiemri"]); ?>
          </td>
        </tr>
        <tr>
          <th style="text-transform: uppercase;">Adresa</th>
          <td id='adresa' colspan="3" style="text-align:center;">
            <?php echo $porosia["adresa"] . ', ' . $porosia["qyteti"] . ' ' . $porosia["zipKodi"]; ?>
          </td>
        </tr>
        <tr>
          <th style="text-transform: uppercase;">Numri Kontaktues</th>
          <td id='nrKontaktit' colspan="3" style="text-align:center;">
            <?php echo $porosia["nrKontaktit"]; ?>
          </td>
        </tr>
        <tr>
          <th style="text-transform: uppercase;">Numri Porosis</th>
          <td id='nrKontaktit' colspan="3" style="text-align:center;">
            <?php echo '#' . $porosia["nrPorosis"]; ?>
          </td>
        </tr>
        <tr>
          <th style="text-transform: uppercase;">Emri Produktit</th>
          <th style="text-transform: uppercase;">Qmimi Produktit</th>
          <th style="text-transform: uppercase;">Sasia e Porositur</th>
          <th style="text-transform: uppercase;">Qmimi total</th>
        </tr>
        <?php

        foreach ($teDhenatPorosis as $porosit) {
          ?>
          <tr>
            <td>
              <a href="../pages/produkti.php?produktiID=<?php echo $porosit['idProdukti'] ?> ">
                <p class=" artikulliLabel">
                  <?php echo $porosit['emriProduktit'] ?>
                </p>
              </a>
            </td>
            <td>
              <?php echo number_format($porosit['qmimiProd'], 2) ?> €
            </td>
            <td>
              <?php echo $porosit['sasiaPorositur'] ?>
            </td>
            <td>
              <?php echo $porosit['qmimiTotal'] ?> €
            </td>
          </tr>
          <?php

          $nentotali = $nentotali + $porosit['qmimiTotal'];
        }
        ?>
        <?php if ($nentotali != $porosia['TotaliPorosis']) {
          ?>
          <tr>
            <td colspan="3" align="right">
              <strong>Nentotali: </strong>
            </td>
            <td>
              <?php echo number_format($nentotali, 2) . ' €' ?>
            </td>
          </tr>
          <tr>
            <td colspan="3" align="right">
              <strong>Zbritja: </strong>
            </td>
            <td>
              <?php echo number_format($porosia['TotaliPorosis'] - $nentotali, 2) . ' €' ?>
            </td>
          </tr>
          <?php
        }
        ?>
        <tr>
          <td colspan="3" align="right">
            <strong>Totali Pa TVSH: </strong>
          </td>
          <td>
            <strong>
              <?php echo number_format($porosia['TotaliPorosis'] - ($porosia['TotaliPorosis'] * 0.18), 2) . ' €' ?>
            </strong>
          </td>
        </tr>
        <tr>
          <td colspan="3" align="right">
            <strong>TVSH 18%: </strong>
          </td>
          <td>
            <strong>
              <?php echo number_format($porosia['TotaliPorosis'] * 0.18, 2) . ' €' ?>
            </strong>
          </td>
        </tr>
        <tr>
          <td colspan="3" align="right" style="font-size: 20pt">
            <strong>Qmimi Total: </strong>
          </td>
          <td style="font-size: 20pt">
            <strong>
              <?php echo number_format($porosia['TotaliPorosis'], 2) . ' €' ?>
            </strong>
          </td>
        </tr>
      </table>
      <div>
        <a href="./fatura.php?nrPorosis=<?php echo $idPorosia['nrPorosis'] ?>" target="_blank">
          <button class="button">Fatura <i class="fa-solid">&#xf56d;</i></button>
        </a>
        <a href="../userPages/porosit.php">
          <button class="button">Perfundo <i class="fa-solid">&#xf105;</i></button>
        </a>
      </div>
    </div>
    <?php
    }
    ?>

  </div>


  <?php include('../design/footer.php'); ?>

</body>

</html>