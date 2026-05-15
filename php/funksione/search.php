<?php
if (isset($_POST['kerkimi'])) {
    header('Location: ../pages/produktet.php?kerko=' . urlencode($_POST['kerkimi']));
    exit();
}
?>