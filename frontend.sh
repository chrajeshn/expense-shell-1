#!/bin/bash

source ./common.sh

check_root 


dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Start Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing Exiting Content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading Frontend Code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extrating Fronted Code"

#check your repo and path

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf  &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restart Nginx"