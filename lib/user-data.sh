#!/bin/bash
yum update -y

yum install -y amazon-cloudwatch-agent curl

echo "getting cw agent config file"
curl -L https://gist.githubusercontent.com/teemal/813c753630c61cb6864a69278991b173/raw/a8094a687af76b904ccd9dc60bf7bcb6c9afb405/CloudWatchAgentConfig.json > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
echo "openging cw agent config perms"
chmod 666 /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo "loading cw agent config file"
amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
echo "starting cw agent"
amazon-cloudwatch-agent-ctl -a start

sudo su

amazon-linux-extras install -y nginx1
systemctl start nginx
systemctl enable nginx

chmod 2775 /usr/share/nginx/html
find /usr/share/nginx/html -type d -exec chmod 2775 {} \;
find /usr/share/nginx/html -type f -exec chmod 0664 {} \;

echo "<h1>This server <b>DOES</b> use the cloudwatch agent</h1>" > /usr/share/nginx/html/index.html
echo "Done with user data"
