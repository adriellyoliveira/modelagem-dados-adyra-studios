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

ALTER TABLE users
ADD COLUMN coins INT NOT NULL DEFAULT 0,
ADD COLUMN dimas INT NOT NULL DEFAULT 0,
ADD COLUMN xp INT NOT NULL DEFAULT 0,
ADD COLUMN level INT NOT NULL DEFAULT 1;

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

CREATE TABLE user_favorite_artists (
user_id INT NOT NULL,
artist_id INT NOT NULL,
PRIMARY KEY (user_id, artist_id),
FOREIGN KEY (user_id) REFERENCES users(id),
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

CREATE TABLE missions (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
description VARCHAR(255) NOT NULL,
mission_type ENUM('daily', 'weekly', 'monthly') NOT NULL,
goal INT NOT NULL,
reward_xp INT NOT NULL,
reward_coins INT NOT NULL,
reward_dimas INT NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE user_missions (
user_id INT NOT NULL,
mission_id INT NOT NULL,
progress INT NOT NULL,
completed BOOLEAN NOT NULL,
PRIMARY KEY (user_id, mission_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (mission_id) REFERENCES missions(id)
);

CREATE TABLE achievements (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
description VARCHAR(255) NOT NULL,
goal INT NOT NULL,
reward_xp INT NOT NULL,
reward_coins INT NOT NULL,
reward_dimas INT NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE user_achievements (
user_id INT NOT NULL,
achievement_id INT NOT NULL,
unlocked BOOLEAN NOT NULL,
unlocked_at DATETIME,
PRIMARY KEY (user_id, achievement_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (achievement_id) REFERENCES achievements(id)
);

CREATE TABLE packs (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
price_coins INT NOT NULL,
card_quantity INT NOT NULL,
PRIMARY KEY (id),
CHECK (price_coins >= 0),
CHECK (card_quantity > 0)
);

CREATE TABLE pack_rarities (
pack_id INT NOT NULL,
rarity ENUM('common', 'uncommon', 'rare', 'ultra rare', 'special') NOT NULL,
drop_chance DECIMAL(5,2) NOT NULL,
PRIMARY KEY (pack_id, rarity),
FOREIGN KEY (pack_id) REFERENCES packs(id),
CHECK (drop_chance >= 0 AND drop_chance <= 100)
);

CREATE TABLE pack_collections (
pack_id INT NOT NULL,
collection_id INT NOT NULL,
PRIMARY KEY (pack_id, collection_id),
FOREIGN KEY (pack_id) REFERENCES packs(id),
FOREIGN KEY (collection_id) REFERENCES collections(id)
);