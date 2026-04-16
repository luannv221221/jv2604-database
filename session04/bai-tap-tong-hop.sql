CREATE TABLE categories(
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL UNIQUE,
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


CREATE TABLE suppliers(
	supplier_id  SERIAL PRIMARY KEY,
	supplier_name VARCHAR(150) NOT NULL,
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
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Điện thoại Samsung Galaxy', 1, 8500000, 20),
('Laptop Dell Inspiron', 1, 16500000, 10),
('Tai nghe Bluetooth', 1, 1200000, 50),
('Nồi cơm điện Sharp', 2, 1800000, 15),
('Máy xay sinh tố Philips', 2, 950000, 25),
('Áo thun nam cổ tròn', 3, 250000, 100),
('Quần jean nữ', 3, 420000, 60),
('Giày thể thao', 3, 780000, 40);

-- 3. Dữ liệu cho bảng customers
INSERT INTO customers (customer_name, email, city, join_date) VALUES
('Nguyễn Văn An', 'an.nguyen@example.com', 'Hà Nội', '2024-01-15'),
('Trần Thị Bình', 'binh.tran@example.com', 'Đà Nẵng', '2024-03-10'),
('Lê Hoàng Minh', 'minh.le@example.com', 'Hồ Chí Minh', '2024-05-22'),
('Phạm Thu Trang', 'trang.pham@example.com', 'Cần Thơ', '2024-07-01'),
('Võ Quốc Bảo', 'bao.vo@example.com', 'Hải Phòng', '2024-09-18'),
('Nguyễn Thị Mai', 'mai.nguyen@example.com', 'Hà Nội', '2024-10-05'),
('Trần Văn Hùng', 'hung.tran@example.com', 'Hà Nội', '2024-11-12'),
('Phạm Văn Long', 'long.pham@example.com', 'Đà Nẵng', '2024-12-01'),
('Lê Thị Hoa', 'hoa.le@example.com', 'Đà Nẵng', '2025-01-08'),
('Nguyễn Quốc Khánh', 'khanh.nguyen@example.com', 'Hồ Chí Minh', '2025-02-14'),
('Trần Minh Tuấn', 'tuan.tran@example.com', 'Hồ Chí Minh', '2025-03-03'),
('Võ Thị Ngọc', 'ngoc.vo@example.com', 'Cần Thơ', '2025-01-20'),
('Đặng Văn Phúc', 'phuc.dang@example.com', 'Hải Phòng', '2025-02-25');


-- CREATE TABLE suppliers(
	supplier_id  SERIAL PRIMARY KEY,
	supplier_name VARCHAR(150) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	city VARCHAR(100),
	join_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO suppliers(supplier_name,email,city) VALUES ('Đặng Văn Phúc', 'phuc.dang@example.com', 'Hải Phòng');
INSERT INTO suppliers(supplier_name,email,city) VALUES ('Đặng Văn Phúc1', 'phuc1111111.dang@example.com', 'Hải Phòng');
SELECT * FROM customers;

-- 4. Dữ liệu cho bảng orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(27, '2025-01-05', 9700000, 'Đã giao'),
(27, '2025-01-10', 1800000, 'Đã giao'),
(30, '2025-01-15', 16950000, 'Đang xử lý'),
(27, '2025-02-02', 400000, 'Đã giao');
SELECT * FROM orders;
-- 5. Dữ liệu cho bảng order_items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(28, 1, 1, 8500000),
(28, 3, 1, 1200000),
(29, 4, 1, 1800000),
(29, 2, 1, 16500000),
(30, 1, 1, 120000);

-- Tìm khách hàng đã thực hiện đơn hàng có giá trị lớn nhất trong toàn bộ hệ thống.

SELECT * FROM customers WHERE customer_id = (SELECT customer_id FROM orders ORDER BY total_amount DESC LIMIT 1);

-- (UNION): Gộp danh sách Email của khách hàng và Email của các nhà cung cấp (giả sử có bảng suppliers) để làm danh sách gửi tin NewsLetter.

SELECT email FROM customers
UNION
SELECT email FROM suppliers;

-- (INTERSECT -- TIM DIEM CHUNG): Tìm danh sách customer_id vừa mua sản phẩm thuộc danh mục 'Electronics' vừa mua sản phẩm thuộc danh mục 'Books'.
SELECT * FROM categories;

SELECT o.customer_id FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id WHERE c.category_name = 'Electronics'
INTERSECT
SELECT o.customer_id FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id WHERE c.category_name = 'Books';

-- (EXCEPT - PHÉP ): Tìm danh sách các sản phẩm có trong kho (products) nhưng chưa từng xuất hiện trong bất kỳ đơn hàng nào (order_items).
SELECT product_id FROM products
EXCEPT
SELECT product_id FROM order_items;
-- Viết truy vấn cập nhật lại total_amount trong bảng orders dựa trên tổng tiền từ bảng order_items tương ứng.

UPDATE orders o SET total_amount = (SELECT SUM(oi.quantity*oi.unit_price) FROM order_items oi WHERE oi.order_id = o.order_id);
SELECT * FROM orders;
SELECT * FROM order_items;