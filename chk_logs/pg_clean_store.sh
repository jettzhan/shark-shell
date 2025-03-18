#!/bin/bash

# author：zhanzhihu
# mail: noodzhan@163.com
# description: backup postgresql ts_kv_* tables to local disk

# Define database username and database name variables
DB_USER="postgres"
DB_NAME="thingsboard"

store_months=3

sql="SELECT table_name
                   FROM information_schema.tables
                   WHERE table_name LIKE 'ts_kv_%'
                     AND table_name < 'ts_kv_' || to_char(now() - interval '$store_months months', 'YYYY_MM')";

# Execute the SQL statement using psql and store the result in a variable
result=$(psql -U $DB_USER -d $DB_NAME -t -A -c "$sql")


# Iterate over each result
while IFS= read -r table_name; do
    echo "Processing table: $table_name"
    # Add your processing logic here
    # For example, you can drop the table
    # psql -U $DB_USER -d $DB_NAME -c "DROP TABLE $table_name;"
    pg_dump -d "$DB_NAME" -U "$DB_USER" -t "$table_name"  -f  "$table_name.sql"
    du -sh "$table_name.sql"

done <<< "$result"

