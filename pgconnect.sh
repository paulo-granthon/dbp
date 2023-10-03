#!/bin/bash
. .env
db_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dbp_postgres_db)
echo "Connecting to ip $db_ip with pgcli..."
pgcli -h $db_ip -u $DATABASE_USERNAME -d $DATABASE_NAME
