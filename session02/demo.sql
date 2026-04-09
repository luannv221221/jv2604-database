-- Tao bảng danh mục
CREATE TABLE categories(
	id int,
	name varchar(100),
	description text
);

-- Thêm mới dữ liệu 
INSERT INTO categories(id,name,description) VALUES (1,'áo','áo đẹp');
INSERT INTO categories(id,name,description) VALUES (2,'quần','quần đẹp');
INSERT INTO categories(id,name,description) VALUES (3,'Mũ','mũ đẹp');

-- Lấy tất cả bản ghi trong bảng categries
SELECT * FROM categories;
-- RANG BUOC
-- 1.1 RANG BUOC KHOA CHINH 
DROP TABLE categories;
CREATE TABLE categories(
	id int PRIMARY KEY,
	name varchar(100),
	description text
);
-- 1.2 RANG BUOC NOTNULL
DROP TABLE categories;
CREATE TABLE categories(
	id int PRIMARY KEY,
	name varchar(100) NOT NULL,
	description text
);
INSERT INTO categories(id,description) VALUES (5,'mũ đẹp');
SELECT * FROM categories;

-- 1.3 RANG BUOC DUY NHAT
DROP TABLE categories;
CREATE TABLE categories(
	id int PRIMARY KEY,
	name varchar(100) NOT NULL UNIQUE,
	description text
);
INSERT INTO categories(id,name,description) VALUES (4,'Nón','nón đẹp');
-- 1.4 RANG BUOC KHOA NGOAI 
-- TẠO BẢNG PRODUCT
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	price float NOT NULL,
	category_id int
);

-- Theem du lieu
INSERT INTO products(name,price,category_id) VALUES ('SP1',100,1);
INSERT INTO products(name,price,category_id) VALUES ('SP2',10,2);
INSERT INTO products(name,price,category_id) VALUES ('SP3',10,1);
SELECT * FROM categories;
SELECT * FROM products;

-- RANG BUOC KHOA NGOAI 
INSERT INTO products(name,price,category_id) VALUES ('SP4',1000,10000);
DROP TABLE products;

CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	price float NOT NULL,
	category_id int NOT NULL REFERENCES categories(id)
);
SELECT * FROM products;
SELECT * FROM categories;
-- Xoa ban ghi 
DELETE FROM categories WHERE id = 1;
-- RANG BUOC CHECK 
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	price float NOT NULL CHECK(price > 0),
	category_id int NOT NULL REFERENCES categories(id)
);
INSERT INTO products(name,price,category_id) VALUES ('SP1',100,1);
INSERT INTO products(name,price,category_id) VALUES ('SP2',10,2);
-- INSERT INTO products(name,price,category_id) VALUES ('SP4',0,1);

-- RANG BUOC MAC DINH GIA TRI
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	price float NOT NULL,
	category_id int NOT NULL REFERENCES categories(id),
	status BOOLEAN DEFAULT TRUE
);
INSERT INTO products(name,price,category_id) VALUES ('SP1',100,1);
INSERT INTO products(name,price,category_id) VALUES ('SP2',10,2);
INSERT INTO products(name,price,category_id,status) VALUES ('SP100',10,2,false);
SELECT * FROM products;
-- CHỈNH SỬA BẢNG 
-- Them cột
ALTER TABLE products ADD COLUMN sale_price float;
-- XOA COT
ALTER TABLE products DROP COLUMN sale_price;
-- CHinh sua kieu du lieu
ALTER TABLE products ALTER COLUMN name TYPE VARCHAR(255);
-- CHinh sua rang buoc 
ALTER TABLE products ADD CONSTRAINT check_prod_sale1 check(sale_price >= 0);
ALTER TABLE products ALTER COLUMN sale_price SET DEFAULT 0;


