#!/usr/bin/env bash

# This script installs dependencies and runs the project
# Run this with root user on Linux Machines(Rocky Linux)


# Start apache
service apache2 start
service apache2 enable

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Replace 'hostname', 'username', and 'password' with the actual RDS credentials.
# mysql -h '' -u '' -p'' < ./bluebirdhotel.sql
mysql -h "$DB_HOST" -u "$DB_USERNAME" -p"$DB_PASS" < ./bluebirdhotel.sql

# Copy project to /var/www/html
rm -r /var/www/html/index.html
cp -r ./ /var/www/html/

# restart apache
service apache2 start

#echo "View project at: http://localhost:80/"
