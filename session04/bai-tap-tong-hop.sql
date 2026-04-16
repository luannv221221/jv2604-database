CREATE TABLE categories(
	category_id SERIAL PRIMARY KEY,
	category_name, VARCHAR(100) NOT NULL UNIQUE,
	descroption TEXT
);

CREATE TABLE products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(150) NOT NULL,
	category_id INT REFERENCES categories(category_id),
	price DECIMAL(15,2) CHECK (price > 0),
	stock_quantity INT CHECK (stock_quantity > 0)
);

CREATE TABLE customers(
	customer_id  SERIAL PRIMARY KEY,
	customer_name VARCHAR(150) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	city VARCHAR(100),
	join_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE orders(
	order_id   SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	total_amount DECIMAL(15,2),
	status VARCHAR(50) DEFAULT 'PENDING'
);

CREATE TABLE order_items(
	order_id INT REFERENCES orders(order_id),
	product_id  INT REFERENCES products(product_id),
	quantity INT,
	unit_price DECIMAL(15,2)
);

-- CHENF THEM DU LIEU 
INSERT INTO categories(category_name,descroption) VALUES 
('Ao So Mi','Mo tar danh mucj'),
('Ao Mua He','Mo tar danh mucj'),
('Ao Mua Thu Dong','Mo tar danh mucj');

SELECT category_id AS "ID" ,category_name AS "DANH MUC", descroption AS "MO TA" FROM categories;

INSERT INTO products(product_name,category_id,price,stock_quantity) VALUES 
('Ao so mi 01 CAO AP',1,100,10),
('Ao mua he 01 CAO AP',2,50,10),
('Ao mua he 02 CAO AP',1,150,10);

INSERT INTO products(product_name,price,stock_quantity) VALUES 
('Ao so mi 01 CAO AP1111',100,10);
SELECT * FROM categories;
SELECT * FROM products;

-- INNER JOIN
SELECT p.product_id,p.product_name,p.price,p.stock_quantity,c.category_name
FROM products p
JOIN categories c
ON p.category_id = c.category_id;
-- LEFT JOIN
--  Liệt kê tất cả danh mục (Categories) và số lượng sản phẩm thuộc danh mục đó (Kể cả danh mục chưa có sản phẩm).
SELECT c.category_id,c.category_name,c.descroption, COUNT(p.product_id) 
FROM categories c
LEFT JOIN products p 
ON p.category_id = c.category_id 
GROUP BY c.category_id,c.category_name,c.descroption;

SELECT c.category_id,c.category_name,c.descroption, COUNT(p.product_id) 
FROM products p
RIGHT JOIN categories c
ON p.category_id = c.category_id 
GROUP BY c.category_id,c.category_name,c.descroption;

SELECT * FROM products;
-- FULL OUTER JOIN
SELECT p.product_id,p.product_name,p.price,p.stock_quantity,c.category_name
FROM products p
FULL OUTER JOIN categories c
ON p.category_id = c.category_id;

-- LAY RA NHUNG SAN PHAM CO GIA LON HON 60
SELECT * FROM products WHERE price > 60;

-- TINH GIA TRUNG BINH CUA SAN PHAM 
SELECT AVG(price) AS "avg_price" FROM products; 

-- TIM CAC DANH MUC CO SAN PHAM mà  GIA TB của các sản phẩm trong danh mục lớn hơn 100

SELECT c.category_id,c.category_name, AVG(p.price) AS "avg_price"
FROM categories c
LEFT JOIN products p 
ON c.category_id = p.category_id
GROUP BY c.category_id,c.category_name 
HAVING AVG(p.price) > 100;


-- TÌM DANH SÁCH SẢN PHẨM CÓ GIÁ CAO HƠN GIÁ TRUNG BÌNH CỦA TẤT CẢ SẢN PHẨM 
SELECT * FROM products WHERE price > (SELECT AVG(price) FROM products);

-- Tính xem mỗi danh mục có bao nhiêu sản phẩm, sau đó lấy ra những danh mục có 2 sản phẩm trở lên 
-- CACH 1: DUNG HAVINg
SELECT c.category_id,c.category_name, COUNT(p.product_id)  AS "total_product"
FROM categories c
LEFT JOIN products p 
ON p.category_id = c.category_id 
GROUP BY c.category_id,c.category_name,c.descroption HAVING COUNT(p.product_id)  > 0;
-- CACH 2: DUNG TRUY VAN LONG
SELECT table_v.category_id,table_v.category_name FROM
(SELECT c.category_id,c.category_name,c.descroption, COUNT(p.product_id)  AS "total_product"
FROM categories c
LEFT JOIN products p 
ON p.category_id = c.category_id 
GROUP BY c.category_id,c.category_name) AS table_v WHERE table_v.total_product > 0;
