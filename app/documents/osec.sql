CREATE DATABASE IF NOT EXISTS osecbd CHARACTER SET utf8 COLLATE utf8_general_ci;
USE osecbd;

DROP TABLE IF EXISTS CityWaterZone;
DROP TABLE IF EXISTS UserHome;
DROP TABLE IF EXISTS Home;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS WaterZone;
DROP TABLE IF EXISTS Form;
DROP TABLE IF EXISTS Weather;
DROP TABLE IF EXISTS Flood;
DROP TABLE IF EXISTS BillboardPost;
DROP TABLE IF EXISTS `User`;

SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE IF NOT EXISTS `User` (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(80) NOT NULL,
    lastName VARCHAR(80) NOT NULL,
    role enum('resident', 'admin') NOT NULL DEFAULT 'resident',
    birthDate DATE,
    homePhoneNumber VARCHAR(15),
    cellPhoneNumber VARCHAR(15),
    workPhoneNumber VARCHAR(15),
    email VARCHAR(254),
    password TEXT
);

CREATE TABLE IF NOT EXISTS BillboardPost (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    userId INTEGER NOT NULL,
    content VARCHAR(255) NOT NULL,
    title VARCHAR(64) NOT NULL,
    datetime TIMESTAMP NOT NULL,
    FOREIGN KEY (userId) REFERENCES `User` (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Form (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Flood (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    waterLevel DECIMAL
);

CREATE TABLE IF NOT EXISTS Weather (
    `timestamp` TIMESTAMP PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS WaterZone (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(80) NOT NULL,
    waterLevel DECIMAL
);

CREATe TABLE IF NOT EXISTS City (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(80) NOT NULL,
    province VARCHAR(5) NOT NULL,
    weatherTimestamp TIMESTAMP,
    FOREIGN KEY (weatherTimestamp) REFERENCES Weather (`timestamp`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Home (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    address VARCHAR(250) NOT NULL,
    floodId INTEGER,
    cityId INTEGER NOT NULL,
    postalCode VARCHAR(6) NOT NULL,
    postOfficeBox VARCHAR(20),
    FOREIGN KEY (floodId) REFERENCES Flood (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cityId) REFERENCES City (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS UserHome (
    userId INTEGER,
    homeId INTEGER,
    PRIMARY KEY (userId, homeId),
    FOREIGN KEY (userId) REFERENCES `User` (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (homeId) REFERENCES Home (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS CityWaterZone (
    cityId INTEGER,
    waterZoneId INTEGER,
    PRIMARY KEY (cityId, waterZoneId),
    FOREIGN KEY (cityId) REFERENCES City (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (waterZoneId) REFERENCES WaterZone (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Weather (`timestamp`) VALUES (DEFAULT);
INSERT INTO City (id, `name`, province, weatherTimestamp) VALUES (DEFAULT, 'Sorel-Tracy', 'QC', NULL);
INSERT INTO WaterZone (id, `name`, waterLevel) VALUES (DEFAULT, 'Bas-Richelieu', 0);
INSERT INTO User (id, firstname, lastname, role, birthDate, homePhoneNumber, cellPhoneNumber, workPhoneNumber, email, password) VALUES (
    DEFAULT , 'Martin', 'Sandwich', 'resident', null, '450-746-0000', '450-808-0000', '450-743-0000', 'martin@sandwich.io', '$2y$10$GbYAYXlpDvGHqYw2hLcXwuR87egdAF7vDyHqX92Nuab8Z7YhGCgxW' /* Omega123*/
);
INSERT INTO BillboardPost (id, userId, title, content, datetime) VALUES (DEFAULT, 1, 'Allo', 'Ceci est une description!', CURRENT_TIMESTAMP);
INSERT INTO BillboardPost (id, userId, title, content, datetime) VALUES (DEFAULT, 1, 'Allo 2', 'Ceci est une description! Ceci est une description! Ceci est une description! Ceci est une description! Ceci est une description!', CURRENT_TIMESTAMP);
INSERT INTO BillboardPost (id, userId, title, content, datetime) VALUES (DEFAULT, 1, 'Allo 3', 'Ceci est une description! Ceci est une description! Ceci est une description!', CURRENT_TIMESTAMP);
INSERT INTO BillboardPost (id, userId, title, content, datetime) VALUES (DEFAULT, 1, 'Allo 4', 'Ceci est une description! Ceci est une description!', CURRENT_TIMESTAMP);
