CREATE SCHEMA shop;

CREATE TABLE shop.users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	role VARCHAR(20) CHECK (role IN('CUSTOMER','ADMIN'))
);
CREATE TABLE shop.categories(
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE shop.products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	price NUMERIC(10,2) CHECK (price > 0),
	stock int CHECK (stock >= 0),
	category_id int not null REFERENCES shop.categories(category_id)
);
CREATE TABLE shop.orders(
 	order_id SERIAL PRIMARY KEY,
	user_id int NOT NULL REFERENCES shop.users(user_id),
	order_date DATE NOT NULL DEFAULT CURRENT_DATE,
	status VARCHAR(20) CHECK (status IN ('PENDING','SHEPPED','DIVLERED','CANCELLED'))
);
CREATE TABLE shop.order_detail(
 	order_detail_id SERIAL PRIMARY KEY,
	order_id int NOT NULL REFERENCES shop.orders(order_id),
	product_id int NOT NULL REFERENCES shop.products(product_id),
	quantity int check(quantity >0),
	price_each NUMERIC(10,2) CHECK (price_each > 0)
);
CREATE TABLE shop.payments (
 	payment_id SERIAL PRIMARY KEY,
	order_id int NOT NULL REFERENCES shop.orders(order_id),
	amount NUMERIC(10,2) CHECK (amount >= 0),
	payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
	method VARCHAR(30) CHECK (method IN ('Credit Card','Momo','Bank Transfer','Cash'))
);
INSERT INTO shop.users(username,password,email,role) VALUES('nguyen van a','1234%','a@gmail.com','CUSTOMER');