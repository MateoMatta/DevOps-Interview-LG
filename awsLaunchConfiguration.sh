#!/bin/bash
mkdir /home/testing_this
sudo mkdir /home/testing_this_too
ls /home
sudo apt update --yes > /dev/null 2>&1 ; sudo apt install nginx --yes > /dev/null 2>&1 ; sudo su
echo '<!DOCTYPE html>
<html>
<head>
<title>Mateo Matta demo!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Mateo Matta interview demo!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. </p>

<p>This web site has been configured with a new VPC, Subnet, Internet gateway, Route table, Security Group, LB, Autoscaling group of just 1 instance and its proper personalized Launch configuration.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>' > /var/www/html/index.nginx-debian.html

sudo service nginx restart > /dev/null 2>&1
