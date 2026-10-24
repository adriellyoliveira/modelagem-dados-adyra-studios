CREATE DATABASE bside_db
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE bside_db;

CREATE TABLE users (
id INT AUTO_INCREMENT,
username VARCHAR(50) NOT NULL UNIQUE,
email VARCHAR(100) NOT NULL UNIQUE,
password_hash VARCHAR(255) NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
);

CREATE TABLE artists (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
artist_type ENUM('group', 'solo') NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE members (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
artist_id INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (artist_id) REFERENCES artists(id)
);

CREATE TABLE collections (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
collection_type ENUM ('album' , 'theme') NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE photocards (
id INT AUTO_INCREMENT,
collection_id INT NOT NULL,
member_id INT NOT NULL,
rarity ENUM('common', 'uncommon', 'rare', 'ultra rare', 'special') NOT NULL,
image_path VARCHAR(255),
PRIMARY KEY (id),
FOREIGN KEY (collection_id) REFERENCES collections(id),
FOREIGN KEY (member_id) REFERENCES members(id)
);

CREATE TABLE user_photocards (
user_id INT NOT NULL,
photocard_id  INT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY (user_id, photocard_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (photocard_id) REFERENCES photocards(id),
CHECK (quantity > 0)
);