#!/bin/bash

echo "Please enter DB password:"
read mysql_root_password

source ./common.sh

check_root 

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling Default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enable nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE

if [ $? -ne 0 ]
 then
     useradd expense &>>$LOGFILE
     VALIDATE $? "Creating expense user"
 else
     echo -e "Expense user alreday created... $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading Backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? "Extracting backend code"

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencise"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon Reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Start Backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enable Backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Clien"

mysql -h db.crn503.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema Loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restart Backend"