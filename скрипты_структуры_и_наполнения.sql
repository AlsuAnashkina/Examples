БД мультибрендового интернет-магазина одежды, обуви, аксессуаров и др (пример farfetch.com). 
БД включает в себя информацию о товарах, запасах на складе, пользователях и их заказах. 


drop database if exists shop2;
create database shop2;
use shop2;


drop table if exists designers;
create table designers (
	designer_id SMALLINT unsigned not null  primary key,
	name VARCHAR(255) not null,
	#pid BIGINT unsigned not null, 
	
	#foreign key pid_fk (pid) references designers(designer_id),
	index(name)
	);


drop table if exists categories; 
create table categories (
	category_id TINYINT unsigned not null auto_increment primary key,
	category VARCHAR(255),
	
	INDEX(category)
	);


drop table if exists colours;
create table colours(
	colours_id TINYINT unsigned not null auto_increment unique,
	colour VARCHAR(255),
	
	INDEX(colour)
);


drop table if exists sizes;
create table sizes(
	sizes_id TINYINT unsigned not null auto_increment unique,
	product_size VARCHAR(255),
	
	INDEX(product_size)
	);



drop table if exists products; 
create table products (
	product_id INT unsigned not null auto_increment primary key,
	name VARCHAR(255),
	price DECIMAL not null,
	description TEXT,
	pr_colour_id TINYINT unsigned not null,
	pr_designer_id SMALLINT unsigned not null,
	pr_category_id TINYINT unsigned not null,
		
	foreign key (pr_colour_id) references colours(colours_id),
	foreign key (pr_designer_id) references designers(designer_id),
	foreign key (pr_category_id) references categories(category_id)
	);


drop table if exists users; 
create table users (
	users_id INT unsigned not null auto_increment primary key,
	email VARCHAR(255) unique,
	phone BIGINT unsigned unique,
	password_hash VARCHAR(255),
	user_type ENUM ('обычный', 'ВИП') default 'обычный'
);


drop table if exists orders;
create table orders (
	id INT unsigned not null auto_increment unique,
	user_id INT unsigned not null,
	created_at DATETIME default NOW(),
	updated_at DATETIME default NOW() on update NOW(),
	
	foreign key (user_id) references users(users_id)
	);


drop table if exists orders_products;
create table orders_products (
	id SERIAL,
	order_id INT unsigned not null,
	product_id INT unsigned not null,
 	pr_size_id TINYINT unsigned not null ,
 	total SMALLINT unsigned not null default 1 COMMENT 'Количество заказанных товарных позиций',
 	
 	foreign key (order_id) references orders(id),
 	foreign key (pr_size_id) references sizes(sizes_id),
 	foreign key (product_id) references products(product_id)
	);


drop table if exists discounts;
create table discounts (
	id INT unsigned not null auto_increment unique,
	product_id INT unsigned,
	discount FLOAT unsigned COMMENT 'Величина скидки от 0.0 до 1.0',
	started_at DATETIME,
	finished_at DATETIME,
	foreign key (product_id) references products(product_id)
	);


drop table if exists storehouses_products;
create table storehouses_products (
  id INT unsigned not null auto_increment unique,
  product_id INT unsigned not null,
  value INT unsigned COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (product_id) references products(product_id)
);






insert into designers values(1, 'Prada'), (2,'Alexander McQueen'), (3,'Anita Ko'),(4,'Armani Exchange'),(5,'BALENCIAGA'),(6,'Balmain'),
(7,'Chloé'),(8,'Cult Gaia'),(9,'Dolce & Gabbana'),(10,'Fendi'),(11,'Jacquemus'),(12,'Maison Margiela'),(13,'Nike'),(14,'Ray-Ban'),(15,'Ruban');

insert into colours values (1,'белый'),(2,'синий'),(3,'красный'),(4,'желтый'),(5,'бежевый'),
(6,'зеленый'),(7,'розовый'),(8,'черный'), (9,'серый'),(10,'нейтральные цвета');

insert into categories values (1,'одежда'),(2,'обувь'),(3,'сумки'),(4,'аксессуары'),(5,'спортивная одежда'),
(6,'нижнее белье'),(7,'ювелирные изделия');

INSERT INTO `sizes` VALUES (1,'xs'),(2,'s'),(3,'m'),(4,'l'),(5,'xl'),
(6,'35'),(7,'36'),(8,'37'), (9,'38'),(10,'39'),(11,'40'),(12,'one size');


insert into products values (1, 'Приталенный блейзер Lydia', 62753, 'зазубренные лацканы, застежка на пуговицах спереди, длинные рукава', 4, 1, 1),
 (2,'сумка-тоут с тиснением под кожу крокодила', 211408,'черный, кожа, тиснение под кожу крокодила, две закругленные ручки', 8, 5, 3),
 (3, 'фактурные серьги-кольца',35939 ,'золотистый, кожа, плетеная отделка, застежка с французским замком ', 4, 3, 7),
 (4, 'платье на одно плечо с цветочным принтом', 219018,'красный, шелк, сплошной цветочный принт, модель на одном плече', 3, 4, 1),
 (5, 'сандалии с узелком', 41859, 'черный, кожа, декор в виде узла, открытый носок', 8, 2, 2),
 (6, 'босоножки на блочном каблуке', 63422,'черный, кожа, модель без застежки, открытый носок',8 , 12, 2),
 (7, 'сумка-тоут Puzzle со вставками', 233657, 'зеленый, кожа, верхняя ручка, контрастная строчка',6 ,10, 3),
 (8, 'сумка-тоут Jada со змеиным принтом', 34857, 'черный, кожа, змеиный принт, две закругленные ручки', 8, 8, 3),
 (9, 'купальник Panarea с V-образным вырезом', 24086, 'розовый, полиамид, детали с оборками,глубокий V-образный вырез', 7, 11, 1),
 (10, 'кружевная рубашка оверсайз', 109823,'розовый, хлопковая смесь, рукава три четверти' , 7, 9, 1),
 (11, 'брюки Tristan', 109892, 'черный, кожа наппа, завышенная талия, широкий крой', 8, 6, 1);
 

INSERT INTO `users` VALUES (1,'khoeger@example.com',89408709510,'2769b8d6b5aa32e31c96add8beffc804b7a399b7','обычный'),
(2,'pacocha.charlene@example.com',89465289715,'aa5ebe5cf84f8cac10a0a4c0a2d55a70b468fb5f','обычный'),
(3,'joshua.barrows@example.com',89717672576,'39544761bb13d6c5dfe8c13774efa1b6a51af4a9','обычный'),
(4,'dickinson.belle@example.net',89939329741,'88f71c63fd52246b6f2463b38a101d232cbbc1a1','ВИП'),
(5,'maia.lang@example.org',89186806917,'2206044af7ae87190d595759b1995b8293077483','ВИП'),
(6,'corwin.ellie@example.org',89887019519,'c97456b599b1aac1b88127c11316be224adaea05','обычный'),
(7,'christiansen.monte@example.net',89072147770,'4befaed3ab8cc5409918b41e1afaaf3cceb2d2e1','обычный'),
(8,'allan67@example.org',89494828624,'0e291558b0bd69ff4fcfaddfc19ffeb6ee3064f5','обычный'),
(9,'zcrist@example.org',89432684640,'ea776091b674721777464d1fd6d6028c00dc255b','обычный'),
(10,'dfeil@example.net',89765853276,'cac30186975968d702c3a26cb7ec7fa407fba77f','обычный'),
(11,'weissnat.ciara@example.com',89945866061,'b0218ca42cba69be68f7fb484ba96da4c9b47719','обычный'),
(12,'ronny.hyatt@example.org',89435644366,'b168032fe534a2b6538949bffcc2a1d069e19186','ВИП'),
(13,'casper.sibyl@example.com',89843818819,'b866c0a03d5c7e32be01032ad7d425663fda3fe0','ВИП'),
(14,'smitham.orin@example.org',89708161473,'d67e0ac27c068e329091775afa734f8d89f51472','ВИП'),
(15,'hagenes.fiona@example.com',89501703444,'065e453c2dbaf1845055d98a8bb8e4421a9aabed','ВИП'),
(16,'leopoldo.blanda@example.com',89860655506,'994fb6d36d5a7b7831c964b08bea4efe1d45ea6c','ВИП'),
(17,'clark15@example.org',89554767911,'de6b54ede72b7d8b643e7271cf72b67ebd9928a9','обычный'),
(18,'milton03@example.com',89944935977,'9ddeac188eb2c869ef70ca570b8a7aee12c94c19','ВИП'),
(19,'macejkovic.brock@example.net',89279138038,'0362ae82821e686504689655338c0dc8d8b87186','ВИП'),
(20,'swaniawski.jerad@example.net',89384578959,'f9692835739c7c071e8ebc39ae703a98865ae516','ВИП'),
(21,'reinhold.padberg@example.net',89162790445,'912250aa3c5510373863c5691678a6346fda269c','ВИП'),
(22,'river.jacobi@example.org',89498681024,'cb4074922fa06bb5b4044dab83f60b376aac623d','ВИП'),
(23,'trantow.whitney@example.com',89416079114,'db5ad25fd2ab71676c9bbc56b19fa10b4d8e0f41','ВИП'),
(24,'austen13@example.com',89747979194,'6715ee6926f187e1a80bb08d09b4e3781cfd1bf6','ВИП'),
(25,'dbaumbach@example.org',89240008132,'c32189be73c3a99c31afc4a881f4d66eb18bc9a2','ВИП'),
(26,'freddie.wolf@example.net',89704985920,'1d9e2c30cdf513bc5b3604267413cc38598bb434','ВИП'),
(27,'shaina.stroman@example.org',89832952877,'bff806141d63d239e5ba0780113be1c6c965a72a','обычный'),
(28,'uconnelly@example.com',89195510939,'b8d4d4c717e142ee59f1fcec29220190394bba2f','обычный'),
(29,'zechariah.gerlach@example.com',89899225969,'f0a86152925ab41147a777df20f87ca7e27b8669','обычный'),
(30,'elsa94@example.net',89487453117,'671b875d82b9fd216ff183ac9948d257842b9115','обычный'),
(31,'aabshire@example.com',89908391777,'d1a9ec2b294b656adb7717e3fe35f860e26a8876','ВИП'),
(32,'ewald88@example.org',89097413030,'eee7f2490b782626d1ba0aa0a86c0911569f3bbf','ВИП'),
(33,'lelia31@example.net',89975264976,'c4db6d632bfacaf0e5d054990510e7a5e6369943','обычный'),
(34,'hadley.daugherty@example.org',89924964923,'9af12d1918b6ffced5eec9f7442539def3a0b1d0','обычный'),
(35,'zpagac@example.net',89679822719,'64f678eea8cffaf786790380e3776cf4d3a275c7','ВИП'),
(36,'katelyn.beier@example.org',89972248989,'83b8fd99554af2c931e32b7be1b98399f7123aaf','ВИП'),
(37,'nayeli11@example.net',89092280358,'ae1a2afeb586814e8da3987382f4661828957aab','ВИП'),
(38,'schinner.connor@example.com',89119904402,'7367c8b4b6cb1d93c218c86693b55d9e404edaf1','обычный'),
(39,'qabbott@example.net',89174467800,'385029bb4e6a23c135ba3e2886ba1b383c8c9dca','обычный'),
(40,'bayer.novella@example.com',89081118169,'72ef5878da03d33ad13b09dc6123ae328c9b0f0e','ВИП');


insert into orders(id, user_id) values (1,2), (2,12),(3,6),(4,7),(5,33),(6,4),(7,10),(8,11),(9,24),(10,27),(11,2);

insert into orders_products values (1,1,2,12,1), (2,1,4,2,1), (3,2,2,12,1), (4,2,4,2,2), (5,2,6,9,1), (6,3,4,3,2),
(7,4,5,8,1), (8,4,4,4,1), (9,5,7,12,1), (10,5,2,12,2), (11,6,8,12,1), (12,7,9,4,1);

insert into discounts(id, product_id, discount) values (1,1,0.7), (2,4,0.7), (3,5,0.7), (4,6,0.7), (5,7,0.7), (6,8,0.65), 
(7,9,0.65), (8,10,0.6), (9,2,0.5), (10,3,0.5);

insert into  storehouses_products(product_id, value) values (1,20), (2,10),(3,2),(4,25),(5,0),(6,7),(7,3),(8,5),(9,5),(10,7),(11,7);



