#!/bin/bash

source ./common.sh

check_root 

echo "Please enter DB password:"
read mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"
systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enableing MySQL Server"
systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQl Server"



#  mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#  VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.crn503.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root Password setup"
else
    echo -e "MYSQL Root Paasword is alreday setup..$Y SKIPPING $N"
fi 