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


INSERT INTO users (username, email, password_hash)
VALUES
('siyeonie', 'insomnia@bside.com', 'insomni@07'),
('moa4ever', 'moa@bside.com', 'mo@tomorrow5'),
('martina', 'coer@bside.com', 'coerblue05'),
('he_evan', 'ever@bside.com', 'everdom07'),
('dahyunie', 'once@bside.com', 'oncesos09'),
('jungwona', 'engene@bside.com', 'engene07'),
('makima', 'lune@bside.com', 'lunewolf09'),
('jenjen', 'blink@bside.com', 'blink004'),
('sualelbora', 'insomnia02@bside.com', 'insomni@@@07');

SELECT * FROM users;


ALTER TABLE users
ADD COLUMN coins INT NOT NULL DEFAULT 0,
ADD COLUMN dimas INT NOT NULL DEFAULT 0,
ADD COLUMN xp INT NOT NULL DEFAULT 0,
ADD COLUMN level INT NOT NULL DEFAULT 1,
ADD COLUMN role ENUM('user', 'admin')
NOT NULL DEFAULT 'user',
ADD CONSTRAINT chk_users_coins
CHECK (coins >= 0),
ADD CONSTRAINT chk_users_dimas
CHECK (dimas >= 0),
ADD CONSTRAINT chk_users_xp
CHECK (xp >= 0),
ADD CONSTRAINT chk_users_level
CHECK (level >= 1);


CREATE TABLE friend_requests (
id INT AUTO_INCREMENT,
sender_id INT NOT NULL,
receiver_id INT NOT NULL,
status ENUM ('pending', 'accepted', 'rejected') NOT NULL DEFAULT 'pending',
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id),
FOREIGN KEY (sender_id) REFERENCES users(id),
FOREIGN KEY (receiver_id) REFERENCES users(id),
CHECK (sender_id <> receiver_id)
);

CREATE TABLE artists (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
artist_type ENUM('group', 'solo') NOT NULL,
PRIMARY KEY (id)
);


INSERT INTO artists (name, artist_type)
VALUES
('Dreamcatcher', 'group'),
('UAU', 'group'),
('BLACKPINK', 'group'),
('TWICE', 'group'),
('ENHYPEN', 'group'),
('TXT', 'group'),
('EVAN', 'solo'),
('CORTIS', 'group'),
('&TEAM', 'group');

SELECT * FROM artists;


CREATE TABLE members (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
artist_id INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (artist_id) REFERENCES artists(id)
);


INSERT INTO members (name, artist_id)
VALUES
-- Dreamcatcher
('JiU', 1), ('SuA', 1), ('Siyeon', 1),
('Handong', 1), ('Yoohyeon', 1), ('Dami', 1), ('Gahyun', 1),

-- UAU
('JiU', 2), ('SuA', 2), ('Yoohyeon', 2),

-- BLACKPINK
('Jisoo', 3), ('Jennie', 3), ('Rosé', 3), ('Lisa', 3),

-- TWICE
('Nayeon', 4), ('Jeongyeon', 4), ('Momo', 4),
('Sana', 4), ('Jihyo', 4), ('Mina', 4),
('Dahyun', 4), ('Chaeyoung', 4), ('Tzuyu', 4),

-- ENHYPEN
('Jungwon', 5), ('Jay', 5), ('Jake', 5),
('Sunghoon', 5), ('Sunoo', 5), ('Ni-ki', 5),

-- TXT
('Soobin', 6), ('Yeonjun', 6), ('Beomgyu', 6),
('Taehyun', 6), ('Hueningkai', 6),

-- EVAN
('Evan', 7),

-- CORTIS
('Martin', 8), ('James', 8), ('Juhoon', 8),
('Seonghyeon', 8), ('Keonho', 8),

-- &TEAM
('EJ', 9), ('K', 9), ('Fuma', 9), ('Nicholas', 9),
('Yuma', 9), ('JO', 9), ('Harua', 9), ('Taki', 9), ('Maki', 9);


CREATE TABLE user_favorite_artists (
user_id INT NOT NULL,
artist_id INT NOT NULL,
PRIMARY KEY (user_id, artist_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (artist_id) REFERENCES artists(id)
);


INSERT INTO user_favorite_artists (user_id, artist_id)
VALUES
(1, 1),
(2, 6),
(3, 8),
(4, 7),
(5, 4);

SELECT users.username, artists.name AS favorite_artist
FROM user_favorite_artists
INNER JOIN users
ON user_favorite_artists.user_id = users.id
INNER JOIN artists
ON user_favorite_artists.artist_id = artists.id
ORDER BY users.username;


CREATE TABLE collections (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
collection_type ENUM ('album' , 'theme') NOT NULL,
PRIMARY KEY (id)
);


INSERT INTO collections (name, collection_type)
VALUES
('Dreamcatcher - VillainS', 'album'),
('UAU - Playlist #You Are You', 'album'),
('UAU - Playlist #Your Youth', 'album'),
('BLACKPINK - DEADLINE', 'album'),
('TWICE - TEN: The Story Goes On', 'album'),
('ENHYPEN - THE SIN : BLISS', 'album'),
('TXT - 7TH YEAR', 'album'),
('EVAN - RIDE OR DIE', 'album'),
('EVAN - DEATH OF ME', 'album'),
('CORTIS - GREENGREEN', 'album'),
('&TEAM - We on Fire', 'album'),
('&TEAM - First Howling: WE', 'album');

SELECT * FROM collections;


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


INSERT INTO photocards (collection_id, member_id, rarity)
VALUES (1, 1, 'special'),
(2, 9, 'special'),
(3, 8, 'rare'),
(4, 12, 'uncommon'),
(5, 21, 'rare'),
(6, 29, 'special'),
(7, 32, 'ultra rare'),
(8, 35, 'special'),
(9, 35, 'special'),
(10, 40, 'rare'),
(11, 48, 'common'),
(12, 44, 'rare');

SELECT photocards.id, collections.name
AS collection, members.name
AS member, photocards.rarity, photocards.image_path
FROM photocards
INNER JOIN collections
ON photocards.collection_id = collections.id
INNER JOIN members
ON photocards.member_id = members.id
ORDER BY collections.id;


CREATE TABLE user_photocards (
user_id INT NOT NULL,
photocard_id  INT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY (user_id, photocard_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (photocard_id) REFERENCES photocards(id),
CHECK (quantity > 0)
);


INSERT INTO user_photocards (user_id, photocard_id, quantity)
VALUES
(1, 1, 2),
(2, 7, 1),
(3, 10, 3),
(4, 8, 1),
(9, 2, 2);

SELECT users.username, members.name AS member,
collections.name AS collection, user_photocards.quantity
FROM user_photocards
INNER JOIN users
ON user_photocards.user_id = users.id
INNER JOIN photocards
ON user_photocards.photocard_id = photocards.id
INNER JOIN members
ON photocards.member_id = members.id
INNER JOIN collections
ON photocards.collection_id = collections.id
ORDER BY users.username;


CREATE TABLE user_wishlist (
user_id INT NOT NULL,
photocard_id INT NOT NULL,
PRIMARY KEY (user_id, photocard_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (photocard_id) REFERENCES photocards(id)
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
PRIMARY KEY (id),
CONSTRAINT chk_missions_goal
CHECK (goal > 0),
CONSTRAINT chk_missions_xp
CHECK (reward_xp >= 0),
CONSTRAINT chk_missions_coins
CHECK (reward_coins >= 0),
CONSTRAINT chk_missions_dimas
CHECK (reward_dimas >= 0)
);


INSERT INTO missions
(name, description, mission_type, goal,
reward_xp, reward_coins, reward_dimas)
VALUES
('Primeira coleção', 'Obtenha uma photocard', 'daily', 1, 50, 100, 0),
('Caçador de cartas', 'Obtenha 5 photocards', 'weekly', 5, 150, 300, 0),
('Colecionador dedicado', 'Obtenha 10 photocards', 'monthly', 10, 300, 500, 5);

SELECT * FROM missions;


CREATE TABLE user_missions (
user_id INT NOT NULL,
mission_id INT NOT NULL,
progress INT NOT NULL,
completed BOOLEAN NOT NULL,
PRIMARY KEY (user_id, mission_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (mission_id) REFERENCES missions(id),
CONSTRAINT chk_user_missions_progress
CHECK (progress >= 0)
);


INSERT INTO user_missions (user_id, mission_id, progress, completed)
VALUES
(1, 1, 0, FALSE),
(1, 2, 2, FALSE);

SELECT users.username, missions.name AS mission,
user_missions.progress, missions.goal, user_missions.completed
FROM user_missions
INNER JOIN users
ON user_missions.user_id = users.id
INNER JOIN missions
ON user_missions.mission_id = missions.id;


CREATE TABLE achievements (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
description VARCHAR(255) NOT NULL,
goal INT NOT NULL,
reward_xp INT NOT NULL,
reward_coins INT NOT NULL,
reward_dimas INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT chk_achievements_goal
CHECK (goal > 0),
CONSTRAINT chk_achievements_xp
CHECK (reward_xp >= 0),
CONSTRAINT chk_achievements_coins
CHECK (reward_coins >= 0),
CONSTRAINT chk_achievements_dimas
CHECK (reward_dimas >= 0)
);


INSERT INTO achievements (name, description, goal, reward_xp, reward_coins, reward_dimas)
VALUES
('Primeira photocard', 'Obtenha sua primeira photocard', 1, 100, 150, 0),
('Colecionador iniciante', 'Obtenha 10 photocards', 10, 250, 300, 0),
('Grande colecionador', 'Obtenha 50 photocards', 50, 1000, 1000, 10);

SELECT id, name, goal
FROM achievements;


CREATE TABLE user_achievements (
user_id INT NOT NULL,
achievement_id INT NOT NULL,
unlocked BOOLEAN NOT NULL,
unlocked_at DATETIME,
PRIMARY KEY (user_id, achievement_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (achievement_id) REFERENCES achievements(id)
);


INSERT INTO user_achievements (user_id, achievement_id, unlocked, unlocked_at)
VALUES
(1, 1, TRUE, CURRENT_TIMESTAMP),
(1, 2, FALSE, NULL),
(1, 3, FALSE, NULL);

SELECT users.username, achievements.name AS achievement,
achievements.goal, user_achievements.unlocked,
user_achievements.unlocked_at
FROM user_achievements
INNER JOIN users
ON user_achievements.user_id = users.id
INNER JOIN achievements
ON user_achievements.achievement_id = achievements.id;


CREATE TABLE packs (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
price_coins INT NOT NULL,
card_quantity INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT chk_packs_name
CHECK (CHAR_LENGTH(TRIM(name)) > 0),
CONSTRAINT chk_packs_price
CHECK (price_coins >= 0),
CONSTRAINT chk_packs_quantity
CHECK (card_quantity > 0)
);


INSERT INTO packs (name, price_coins, card_quantity)
VALUES
('Normal Pack', 100, 3),
('Premium Pack', 250, 5),
('Special Pack', 500, 5);

SELECT * FROM packs;


CREATE TABLE pack_rarities (
pack_id INT NOT NULL,
rarity ENUM('common', 'uncommon', 'rare', 'ultra rare', 'special') NOT NULL,
drop_chance DECIMAL(5,2) NOT NULL,
PRIMARY KEY (pack_id, rarity),
FOREIGN KEY (pack_id) REFERENCES packs(id),
CONSTRAINT chk_pack_rarities_chance
CHECK (drop_chance >= 0 AND drop_chance <= 100)
);


INSERT INTO pack_rarities (pack_id, rarity, drop_chance)
VALUES
-- Normal Pack
(1, 'common', 60.00),
(1, 'uncommon', 30.00),
(1, 'rare', 10.00),

-- Premium Pack
(2, 'common', 35.00),
(2, 'uncommon', 35.00),
(2, 'rare', 20.00),
(2, 'ultra rare', 10.00),

-- Special Pack
(3, 'common', 20.00),
(3, 'uncommon', 25.00),
(3, 'rare', 25.00),
(3, 'ultra rare', 20.00),
(3, 'special', 10.00);


SELECT packs.name AS pack, pack_rarities.rarity,
pack_rarities.drop_chance
FROM pack_rarities
INNER JOIN packs
ON pack_rarities.pack_id = packs.id
ORDER BY packs.id, pack_rarities.drop_chance DESC;


CREATE TABLE pack_collections (
pack_id INT NOT NULL,
collection_id INT NOT NULL,
PRIMARY KEY (pack_id, collection_id),
FOREIGN KEY (pack_id) REFERENCES packs(id),
FOREIGN KEY (collection_id) REFERENCES collections(id)
);


INSERT INTO pack_collections (pack_id, collection_id)
VALUES
-- Normal Pack
(1, 1), (1, 2), (1, 3), (1, 4),

-- Premium Pack
(2, 3), (2, 4), (2, 5), (2, 6),
(2, 7), (2, 8),

-- Special Pack
(3, 1), (3, 5), (3, 7), (3, 9),
(3, 10), (3, 11), (3, 12);

SELECT packs.name AS pack, collections.name AS collection
FROM pack_collections
INNER JOIN packs
ON pack_collections.pack_id = packs.id
INNER JOIN collections
ON pack_collections.collection_id = collections.id
ORDER BY packs.id, collections.id;


CREATE TABLE shop_collections (
id INT AUTO_INCREMENT,
collection_id INT NOT NULL UNIQUE,
price_dimas INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (collection_id) REFERENCES collections(id),
CONSTRAINT chk_shop_collections_price
CHECK (price_dimas >= 0)
);


INSERT INTO shop_collections (collection_id, price_dimas)
VALUES
(1, 500),
(4, 600),
(7, 550);

SELECT shop_collections.id, collections.name AS collection,
shop_collections.price_dimas
FROM shop_collections
INNER JOIN collections
ON shop_collections.collection_id = collections.id;


CREATE TABLE user_purchases (
id INT AUTO_INCREMENT,
user_id INT NOT NULL,
shop_collection_id INT NOT NULL,
purchased_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id),
UNIQUE (user_id, shop_collection_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (shop_collection_id) REFERENCES shop_collections(id)
);


INSERT INTO user_purchases (user_id, shop_collection_id)
VALUES (1, 1),
(2, 1),
(3, 3),
(4, 1),
(5, 2),
(6, 1);


SELECT users.username, collections.name AS collection,
user_purchases.purchased_at
FROM user_purchases
INNER JOIN users
ON user_purchases.user_id = users.id
INNER JOIN shop_collections
ON user_purchases.shop_collection_id = shop_collections.id
INNER JOIN collections
ON shop_collections.collection_id = collections.id;


CREATE TABLE shop_currency_packs (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
coins_amount INT NOT NULL,
price_dimas INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT chk_currency_name
CHECK (CHAR_LENGTH(TRIM(name)) > 0),
CONSTRAINT chk_currency_coins
CHECK (coins_amount > 0),
CONSTRAINT chk_currency_price
CHECK (price_dimas >= 0)
);


INSERT INTO shop_currency_packs (name, coins_amount, price_dimas)
VALUES
('Bolsa de Coins', 500, 50),
('Cofre de Coins', 1500, 120),
('Tesouro de Coins', 5000, 350);


CREATE TABLE shop_dimas_packs (
id INT AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
dimas_amount INT NOT NULL,
price_brl DECIMAL(6,2) NOT NULL,
PRIMARY KEY (id),
CONSTRAINT chk_dimas_name
CHECK (CHAR_LENGTH(TRIM(name)) > 0),
CONSTRAINT chk_dimas_amount
CHECK (dimas_amount > 0),
CONSTRAINT chk_dimas_price
CHECK (price_brl >= 0)
);


INSERT INTO shop_dimas_packs (name, dimas_amount, price_brl)
VALUES
('Punhado de Dimas', 100, 4.90),
('Bolsa de Dimas', 500, 19.90),
('Cofre de Dimas', 1200, 39.90);

SELECT * FROM shop_currency_packs;
SELECT * FROM shop_dimas_packs;