<?php
if (!isset($_SESSION)) {
    session_start();
}

$userID = isset($_GET['userID']) && ctype_digit($_GET['userID']) ? (int) $_GET['userID'] : 0;
if ($userID === 0) {
    header('Location: ../userPages/userDashboard.php');
    exit();
}

if ($_SESSION['aksesi'] == 0 && $userID !== (int) $_SESSION['userID']) {
    header('Location: ../userPages/userDashboard.php');
    exit();
}

require_once('../CRUD/userCRUD.php');
$userCRUD = new userCRUD();

$userCRUD->setUserID($userID);
$perdoruesi = $userCRUD->shfaqSipasID();

if (isset($_POST['perditPass'])) {
    if (password_verify($_POST['passVjeter'], $perdoruesi['password'])) {
        $userCRUD->setPassword(password_hash($_POST['passIRi'], PASSWORD_DEFAULT));

        $userCRUD->perditesoFjalekalimin();

        $_SESSION['teDhenatUPerditesuan'] = true;
        if ($_SESSION['aksesi'] != 0) {
            header('Location: ../admin/adminDashboard.php');
            exit();
        } else {
            header('Location: ../userPages/userDashboard.php');
            exit();
        }
    } else {
        $_SESSION['passGabim'] = true;
    }
}
if (isset($_POST['anulo'])) {
    $_SESSION['perditesimiUAnulua'] = false;
    header('Location: ../userPages/userDashboard.php');
    exit();
}
$perdoruesi = $userCRUD->shfaqSipasID();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Perditesimi i Password | Tech Store</title>
    <link rel="shortcut icon" href="../../img/web/favicon.ico" />
    <link rel="stylesheet" href="../../css/forms.css" />
    <link rel="stylesheet" href="../../css/mesazhetStyle.css" />
</head>

<body>
    <?php include '../design/header.php'; ?>
    <div class="forms">
        <form name="ndryshoPass" onsubmit="" action='' method="POST" enctype="multipart/form-data">
            <?php
            if (isset($_SESSION['passGabim'])) {
                ?>
                <div class="mesazhiStyle mesazhiGabimStyle">
                    <p>Passwordi juaj aktual eshte Gabim!</p>
                    <button id="mbyllMesazhin">
                        <i class="fa-solid">&#xf00d;</i>
                    </button>
                </div>
                <?php
            }

            ?>
            <h1 class="form-title">Perditesimi i Password </h1>
            <label for="">
                <strong>ID Juaj: </strong>
                <?php echo htmlspecialchars($perdoruesi['userID'], ENT_QUOTES, 'UTF-8') ?>
            </label>
            <label for="">
                <strong>Username: </strong>
                <?php echo htmlspecialchars($perdoruesi['username'], ENT_QUOTES, 'UTF-8') ?>
            </label>
            <label for="">
                <strong>Password i Ri: </strong>
                <input type="password" placeholder="Shkruani passwordin!" name="passIRi">
            </label>
            <label for="">
                <strong>Password Aktual: </strong>
                <input type="password" placeholder="Shkruani passwordin!" name="passVjeter">
            </label>
            <div>
                <button class="button" type="submit" name='perditPass'>Perditesoni Password <i class="fa-solid">&#xf044;</i></button>
                <button class="button" type="submit" name='anulo'>Anulo <i class="fa-solid">&#xf00d;</i></button>
            </div>

        </form>
    </div>
    <script src="../../js/validimiFormave.js"></script>
    <script src="../../js/mbyllMesazhin.js"></script>
</body>

</html>
<?php
unset($_SESSION['passGabim']);
?>