-- Create a write user for Aurora cluster
-- This user will have write permissions to the database

-- Create the user with the password from Terraform
CREATE USER 'bookshelf_w'@'%' IDENTIFIED BY '${write_user_password}';

-- Grant write privileges to the user
GRANT SELECT, INSERT, UPDATE, DELETE ON bookshelf.* TO 'bookshelf_w'@'%';

-- Flush privileges to apply changes
FLUSH PRIVILEGES; 
