<?php
function sendPushNotification($title, $body, $userId = null)
{
    // Lexojmë subscriptions nga file (në realitet do të ishin në DB)
    $subscriptions = file_get_contents('push_subscriptions.json');
    if (!$subscriptions)
        return;

    $subs = array_filter(explode(PHP_EOL, $subscriptions));
    $payload = json_encode([
        'title' => $title,
        'body' => $body,
        'icon' => '/img/web/favicon.ico'
    ]);

    foreach ($subs as $sub) {
        $subData = json_decode($sub, true);
        if (!$subData)
            continue;

        // Në realitet, do të përdorim Web Push library për të dërguar
        // Këtu simulojmë
        // Për shembull, përdorim curl për të dërguar në endpoint push
    }
}
?>