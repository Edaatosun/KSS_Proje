use kssapp;

/*------------------------------------------*/
CREATE TABLE queue_images(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) UNIQUE NOT NULL,
    queue_number INT NOT NULL
);
DELETE FROM queue_images WHERE name = "YesilAlan1";

INSERT INTO queue_images(name,queue_number) VALUES("YesilAlan1",175);
INSERT INTO queue_images(name,queue_number) VALUES("YesilAlan2",250);
INSERT INTO queue_images(name,queue_number) VALUES("YesilAlan3",61);
INSERT INTO queue_images(name,queue_number) VALUES("CocukAcil",399);

UPDATE kssapp.queue_images
SET queue_number = 1400, id=15
WHERE name= "YesilAlan1";

select * from kssapp.queue_images;
/*------------------------------------------*/
CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    date VARCHAR(50) NOT NULL,
    description TEXT,
    image_path VARCHAR(255),
    class ENUM('0', '1', '2') NOT NULL DEFAULT '0'
);

INSERT INTO announcements (title, date, description) VALUES
('Duyuru Başlık 1', '21 Mart 2024', 'Bu birinci duyurunun açıklaması.'),
('Duyuru Başlık 2', '22 Mart 2024', 'Bu ikinci duyurunun açıklaması.'),
('Duyuru Başlık 3', '23 Mart 2024', 'Bu üçüncü duyurunun açıklaması.');

SELECT * FROM kssapp.announcements;
/*------------------------------------------*/
CREATE TABLE doctors(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    email VARCHAR(250),
    phone_number VARCHAR(250),
    username VARCHAR(250) NOT NULL,
    password VARCHAR(250) NOT NULL,
    birth_date VARCHAR(50),
    department varchar(255),
    image_path VARCHAR(255)
);

INSERT INTO doctors(name,username,password,department) VALUES ("Doktor 1","doctor1","12345678","Kardiyoloji");
INSERT INTO doctors(name,username,password,image_path,department) VALUES ("Doktor 2","doctor2","12345678","https://i.pinimg.com/564x/f0/91/f1/f091f133223dce6abe77231f666c4648.jpg","Nöroloji");

DELETE FROM doctors WHERE username="doctor1";

SELECT * FROM kssapp.doctors;
/*------------------------------------------*/
CREATE TABLE nurses(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    email VARCHAR(250),
    phone VARCHAR(250),
    username VARCHAR(250) NOT NULL,
    password VARCHAR(250) NOT NULL,
    birth_date VARCHAR(50),
    department varchar(255),
    nurse_code INT NOT NULL UNIQUE,
    is_called BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO nurses(name,username,password,nurse_code) VALUES ("nurse1","nurse1","12345678",123456);

ALTER TABLE nurses
ADD COLUMN image VARCHAR(255) AFTER department;

DELETE FROM nurses WHERE name="nurse1";

SELECT * from kssapp.nurses;
/*------------------------------------------*/
CREATE TABLE celebrations(
id INT AUTO_INCREMENT PRIMARY KEY,
date varchar(50),
description Text
);

INSERT INTO celebrations(date,description) VALUES ("28 Mart 2024","This is a celebration.");
/*------------------------------------------*/
CREATE TABLE bt_devices(
	id INT AUTO_INCREMENT PRIMARY KEY,
    mac_address VARCHAR(250),
    room VARCHAR(250)
);

DELETE FROM bt_devices WHERE id=3; 

INSERT INTO bt_devices(mac_address,room) VALUES ("7C:B9:4C:1D:7A:8A","149");
INSERT INTO bt_devices(mac_address,room) VALUES ("7C:B9:4C:1D:7A:70","150");
INSERT INTO bt_devices(mac_address,room) VALUES ("7C:B9:4C:1D:EF:C2","151");
INSERT INTO bt_devices(mac_address,room) VALUES ("7C:B9:4C:8A:08:D0","999");
INSERT INTO bt_devices(mac_address,room) VALUES ("7C:B9:4C:1D:79:3C","199");

SELECT * FROM kssapp.bt_devices;

/*------------------------------------------*/ 
CREATE TABLE cities(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250),
    name_normalized VARCHAR(250)
);

INSERT INTO cities(name,name_normalized) VALUES ("İstanbul","Istanbul"),("Ankara","Ankara"),("İzmir","Izmir"),("Bursa","Bursa"),("Adana","Adana");

SELECT * FROM kssapp.cities;
/*------------------------------------------*/ 
CREATE TABLE districts(
	id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(250),
    district VARCHAR(250)
);

INSERT INTO districts (city, district)
VALUES
("İstanbul","Adalar"),
('İstanbul', 'Arnavutköy'),
('İstanbul', 'Ataşehir'),
('İstanbul', 'Avcılar'),
('İstanbul', 'Bağcılar'),
('İstanbul', 'Bahçelievler'),
('İstanbul', 'Bakırköy'),
('İstanbul', 'Başakşehir'),
('İstanbul', 'Bayrampaşa'),
('İstanbul', 'Beşiktaş'),
('İstanbul', 'Beykoz'),
('İstanbul', 'Beylikdüzü'),
('İstanbul', 'Beyoğlu'),
('İstanbul', 'Büyükçekmece'),
('İstanbul', 'Çatalca'),
('İstanbul', 'Çekmeköy'),
('İstanbul', 'Esenler'),
('İstanbul', 'Esenyurt'), 
('İstanbul', 'Eyüpsultan'),
('İstanbul', 'Fatih'),
('İstanbul', 'Gaziosmanpaşa'),
('İstanbul', 'Güngören'),
('İstanbul', 'Kadıköy'),
('İstanbul', 'Kağıthane'),
('İstanbul', 'Kartal'),
('İstanbul', 'Küçükçekmece'),
('İstanbul', 'Maltepe'),
('İstanbul', 'Pendik'),
('İstanbul', 'Sancaktepe'),
('İstanbul', 'Sarıyer'),
('İstanbul', 'Silivri'),
('İstanbul', 'Sultanbeyli'),
('İstanbul', 'Sultangazi'),
('İstanbul', 'Şile'),
('İstanbul', 'Şişli'),
('İstanbul', 'Tuzla'),
('İstanbul', 'Ümraniye'),
('İstanbul', 'Üsküdar'),
('İstanbul', 'Zeytinburnu');

INSERT INTO districts (city,district)
VALUES
('İzmir', 'Balçova'),
('İzmir', 'Bayraklı'),
('İzmir', 'Bornova'),
('İzmir', 'Buca'),
('İzmir', 'Çiğli'),
('İzmir', 'Gaziemir'),
('İzmir', 'Güzelbahçe'),
('İzmir', 'Karabağlar'),
('İzmir', 'Karşıyaka'),
('İzmir', 'Konak'),
('İzmir', 'Narlıdere'),
('İzmir', 'Aliağa'),
('İzmir', 'Bayındır'),
('İzmir', 'Bergama'),
('İzmir', 'Beydağ'),
('İzmir', 'Çeşme'),
('İzmir', 'Dikili'),
('İzmir', 'Foça'),
('İzmir', 'Karaburun'),
('İzmir', 'Kemalpaşa'),
('İzmir', 'Kınık'),
('İzmir', 'Kiraz'),
('İzmir', 'Menderes'),
('İzmir', 'Menemen'),
('İzmir', 'Ödemiş'),
('İzmir', 'Seferihisar'),
('İzmir', 'Selçuk'),
('İzmir', 'Tire'),
('İzmir', 'Torbalı'),
('İzmir', 'Urla');

INSERT INTO districts (city, district)
VALUES
('Ankara', 'Akyurt'),
('Ankara', 'Altındağ'),
('Ankara', 'Ayaş'),
('Ankara', 'Bala'),
('Ankara', 'Beypazarı'),
('Ankara', 'Çamlıdere'),
('Ankara', 'Çankaya'),
('Ankara', 'Çubuk'),
('Ankara', 'Elmadağ'),
('Ankara', 'Etimesgut'),
('Ankara', 'Evren'),
('Ankara', 'Gölbaşı'),
('Ankara', 'Güdül'),
('Ankara', 'Haymana'),
('Ankara', 'Kahramankazan'),
('Ankara', 'Kalecik'),
('Ankara', 'Keçiören'),
('Ankara', 'Kızılcahamam'),
('Ankara', 'Mamak'),
('Ankara', 'Nallıhan'),
('Ankara', 'Polatlı'),
('Ankara', 'Pursaklar'),
('Ankara', 'Sincan'),
('Ankara', 'Şereflikoçhisar'),
('Ankara', 'Yenimahalle');

INSERT INTO districts (city, district)
VALUES
('Bursa', 'Büyükorhan'),
('Bursa', 'Gemlik'),
('Bursa', 'Gürsu'),
('Bursa', 'Harmancık'),
('Bursa', 'İnegöl'),
('Bursa', 'İznik'),
('Bursa', 'Karacabey'),
('Bursa', 'Keles'),
('Bursa', 'Kestel'),
('Bursa', 'Mudanya'),
('Bursa', 'Mustafakemalpaşa'),
('Bursa', 'Nilüfer'),
('Bursa', 'Orhaneli'),
('Bursa', 'Orhangazi'),
('Bursa', 'Osmangazi'),
('Bursa', 'Yenişehir'),
('Bursa', 'Yıldırım');

INSERT INTO districts (city, district)
VALUES
('Adana', 'Aladağ'),
('Adana', 'Ceyhan'),
('Adana', 'Çukurova'),
('Adana', 'Feke'),
('Adana', 'İmamoğlu'),
('Adana', 'Karaisalı'),
('Adana', 'Karataş'),
('Adana', 'Kozan'),
('Adana', 'Pozantı'),
('Adana', 'Saimbeyli'),
('Adana', 'Sarıçam'),
('Adana', 'Seyhan'),
('Adana', 'Tufanbeyli'),
('Adana', 'Yumurtalık'),
('Adana', 'Yüreğir');

SELECT * FROM kssapp.districts;

UPDATE districts SET district = "Eyüp" WHERE id=19;
DELETE FROM districts WHERE id=84; #kahramankazan api'da hata çıkardığı için silindi

/*------------------------------------------*/ 
CREATE TABLE analysis(
id int primary key auto_increment,
code varchar(10) NOT NULL UNIQUE,
name text NOT NULL,
link text NOT NULL,
Date DATETIME DEFAULT CURRENT_TIMESTAMP
); 

SELECT * FROM kssapp.analysis;
/*------------------------------------------*/ 
CREATE TABLE fcm_tokens(
id INT PRIMARY KEY AUTO_INCREMENT,
token VARCHAR(255) NOT NULL UNIQUE,
last_activity_timestamp DATETIME NOT NULL,
user_type ENUM('patient', 'doctor', 'nurse', 'security', 'others') DEFAULT 'patient',
user_type_details VARCHAR(255)
); 

SELECT * FROM kssapp.fcm_tokens;
/*------------------------------------------*/ 
CREATE TABLE color_codes(
id INT PRIMARY KEY AUTO_INCREMENT,
color VARCHAR(255) NOT NULL,
activity_date DATETIME NOT NULL
);

SELECT * FROM color_codes;
/*------------------------------------------*/ 
CREATE TABLE pharmacies(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
city VARCHAR(255) NOT NULL,
district VARCHAR(255) NOT NULL,
address VARCHAR(255) NOT NULL,
sub_address VARCHAR(255),
phone VARCHAR(255) NOT NULL,
location_x VARCHAR(255),
location_y VARCHAR(255)
);

SELECT * FROM kssapp.pharmacies;
/*------------------------------------------*/ 

SELECT * FROM kssapp.admin;
SELECT * FROM kssapp.analysis;
SELECT * FROM kssapp.announcements;
SELECT * FROM kssapp.brochures;
SELECT * FROM kssapp.bt_devices;
SELECT * FROM kssapp.celebrations;
SELECT * FROM kssapp.cities;
SELECT * FROM kssapp.color_codes;
SELECT * FROM kssapp.districts;
SELECT * FROM kssapp.doctors;
SELECT * FROM kssapp.fcm_tokens;
SELECT * FROM kssapp.icon_object_hospital_intro;
SELECT * FROM kssapp.nurses;
SELECT * FROM kssapp.pharmacies;
SELECT * FROM kssapp.polyclinics;
SELECT * FROM kssapp.queue_images;
SELECT * FROM kssapp.texts_for_visit_rules;
