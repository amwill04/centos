# Add schemas
DB=$1;

mysql -uvagrant -pvagrant -e "CREATE DATABASE IF NOT EXISTS $DB DEFAULT CHARACTER SET  = 'utf8mb4' DEFAULT COLLATE = 'utf8mb4_bin';";
