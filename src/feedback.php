<?php

$email = "omnisoftwarelocalization@gmail.com";
$subject = "[Feedback]";

$type = $_GET['type'];
$text = $_GET['text'];
$user_email = $_GET['email'];

$subject .= " "."[" + $type + "]";
$message = $text;

$mail_response = mail($email, $subject, $message);

echo $mail_response;

?>
