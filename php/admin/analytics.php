<?php
if (!isset($_SESSION)) {
    session_start();
}

require_once('../adminFunksione/kontrolloAksesAdmin.php');
require_once('../CRUD/produktiCRUD.php');
require_once('../CRUD/userCRUD.php');
require_once('../CRUD/porosiaCRUD.php');

$produktiCRUD = new produktiCRUD();
$userCRUD = new userCRUD();
$porosiaCRUD = new porosiaCRUD();

// Get statistics
$totalProducts = count($produktiCRUD->shfaqTeGjithaProduktet());
$totalUsers = count($userCRUD->shfaqTeGjithePerdoruesit());
$totalOrders = count($porosiaCRUD->shfaqTeGjithaPorosite());

// Recent orders
$allOrders = $porosiaCRUD->shfaqTeGjithaPorosite();
$recentOrders = array_slice($allOrders, 0, 5); // Last 5 orders

// Top products (simplified)
$topProducts = $produktiCRUD->shfaq15ProduktetEFundit(); // Using latest as proxy
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Analytics | Tech Store Admin</title>
    <link rel="shortcut icon" href="../../img/web/favicon.ico" />
    <link rel="stylesheet" href="../../css/adminDashboard.css" />
    <style>
        .analytics-container {
            padding: 20px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #007bff;
        }

        .stat-label {
            color: #666;
            margin-top: 10px;
        }

        .recent-orders,
        .top-products {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .order-item,
        .product-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>

<body>
    <?php include '../design/header.php'; ?>
    <div class="analytics-container">
        <h1>Analytics Dashboard</h1>

        <div style="margin-bottom: 20px;">
            <a href="export_orders.php" class="button"
                style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Export
                Orders to CSV</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><?php echo $totalProducts; ?></div>
                <div class="stat-label">Total Products</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><?php echo $totalUsers; ?></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><?php echo $totalOrders; ?></div>
                <div class="stat-label">Total Orders</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">€<?php
                $totalRevenue = 0;
                foreach ($recentOrders as $order) {
                    $totalRevenue += $order['totali'];
                }
                echo number_format($totalRevenue, 2);
                ?></div>
                <div class="stat-label">Recent Revenue</div>
            </div>
        </div>

        <div class="recent-orders">
            <h2>Recent Orders</h2>
            <?php if (empty($recentOrders)) { ?>
                <p>No orders found.</p>
            <?php } else { ?>
                <?php foreach ($recentOrders as $order) { ?>
                    <div class="order-item">
                        <div>
                            <strong>Order #<?php echo $order['porosiaID']; ?></strong><br>
                            <span><?php echo htmlspecialchars($order['emri'], ENT_QUOTES, 'UTF-8'); ?> -
                                <?php echo htmlspecialchars($order['dataPorosis'], ENT_QUOTES, 'UTF-8'); ?></span>
                        </div>
                        <div>€<?php echo number_format($order['totali'], 2); ?></div>
                    </div>
                <?php } ?>
            <?php } ?>
        </div>

        <div class="top-products">
            <h2>Latest Products</h2>
            <?php if (empty($topProducts)) { ?>
                <p>No products found.</p>
            <?php } else { ?>
                <?php foreach ($topProducts as $product) { ?>
                    <div class="product-item">
                        <div>
                            <strong><?php echo htmlspecialchars($product['emriProduktit'], ENT_QUOTES, 'UTF-8'); ?></strong><br>
                            <span><?php echo htmlspecialchars($product['pershkrimiProduktit'], ENT_QUOTES, 'UTF-8'); ?></span>
                        </div>
                        <div>€<?php echo number_format($product['qmimiProduktit'], 2); ?></div>
                    </div>
                <?php } ?>
            <?php } ?>
        </div>
    </div>
    <?php include '../design/footer.php'; ?>
</body>

</html>
