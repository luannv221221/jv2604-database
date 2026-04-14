CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	phone VARCHAR(12) NOT NULL UNIQUE,
	city VARCHAR(50),
	join_date DATE DEFAULT CURRENT_DATE
);
CREATE TABLE products(
	product_id SERIAL PRIMARY KEY,
	product_name  VARCHAR(100) NOT NULL,
	category VARCHAR(100) NOT NULL,
	price DECIMAL(15,3) CHECK (price >0),
	stock_quantity INT DEFAULT 0
);
CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL REFERENCES customers(customer_id),
	order_date DATE DEFAULT CURRENT_DATE,
	total_amount DECIMAL(15,3),
	status VARCHAR(50) DEFAULT 'PENDING'
);
-- INSERT dữ liệu
INSERT INTO customers(full_name,email,phone,city) VALUES ('Trần Minh Khang','khangtm@gmail.com','0912345678','Hồ Chí Minh'),
('Lê Hoàng Nam','namlh@gmail.com','0987654321','Hà Nội'),
('Phạm Gia Huy','huypg@gmail.com','0901122334','Đà Nẵng'),
('Võ Quốc Bảo','baovq@gmail.com','0933445566','Cần Thơ'),
('Đặng Nhật Minh','minhdn@gmail.com','0977889900','Hải Phòng'),
('Bùi Anh Tuấn','tuanba@gmail.com','0966554433','Bình Dương'),
('Ngô Thanh Tâm','tamnt@gmail.com','0944221133','Đồng Nai'),
('Huỳnh Gia Bảo','baohg@gmail.com','0922113344','Nha Trang'),
('Đỗ Đức Mạnh','manhdd@gmail.com','0955667788','Huế'),
('Tesst','tesst@gmail.com','09556138','Huế'),
('Mai Quốc Hưng','hungmq@gmail.com','0911223344','Vũng Tàu');


INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('iPhone 13', 'Electronics', 20000000, 50),
('Samsung Galaxy S21', 'Electronics', 18000000, 40),
('Laptop Dell XPS', 'Electronics', 30000000, 20),
('Tai nghe Sony', 'Electronics', 2000000, 100),
('Smart Watch', 'Electronics', 5000000, 60),

('Ao thun nam', 'Clothing', 200000, 200),
('Quan jean nu', 'Clothing', 400000, 150),
('Ao khoac', 'Clothing', 800000, 80),
('Giay sneaker', 'Clothing', 1200000, 70),
('Non luoi trai', 'Clothing', 150000, 120),

('Banh mi', 'Food', 20000, 500),
('Sua tuoi', 'Food', 30000, 300),
('Ca phe', 'Food', 50000, 250),
('Mi goi', 'Food', 10000, 600),
('Tra sua', 'Food', 40000, 0);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2026-04-01', 25000000, 'PENDING'),
(2, '2026-04-02', 1200000, 'CONFIRMED'),
(3, '2026-04-03', 5000000, 'SHIPPING'),
(1, '2026-04-04', 500000, 'DELIVERED'),
(4, '2026-04-05', 35000000, 'PENDING'),
(5, '2026-04-06', 2500000, 'CANCELLED'),
(2, '2026-04-07', 8000000, 'PENDING'),
(6, '2026-04-08', 350000, 'CONFIRMED');

-- Cập nhật giá sản phẩm thuộc category 'Electronics' tăng 10%
UPDATE products SET price = price + (price  * 0.1) WHERE category = 'Electronics';

-- Cập nhật số điện thoại cho khách hàng có email cụ thể
SELECT * FROM customers;
UPDATE customers SET phone = '0339513657' WHERE email = 'khangtm@gmail.com';
-- Cập nhật trạng thái đơn hàng từ 'PENDING' sang 'CONFIRMED'
SELECT * FROM orders;
UPDATE orders SET status = 'CONFIRMED' WHERE status = 'PENDING';

-- Xóa các sản phẩm có số lượng tồn kho = 0
SELECT * FROM products;

DELETE FROM products WHERE stock_quantity = 0;



SELECT * FROM orders;
-- Khacsh hang khong co don hang 
SELECT DISTINCT customer_id FROM orders;
-- Xóa khách hàng không có đơn hàng nào
DELETE FROM customers WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- Tìm khách hàng theo tên (sử dụng ILIKE)
-- tim khach hang co minh trong ten
SELECT * FROM customers WHERE full_name ILIKE '%minh%'

-- Lọc sản phẩm theo khoảng giá (sử dụng BETWEEN) 50000.000 , 22000000.000

SELECT * FROM products WHERE price BETWEEN 50000 AND 22000000;

-- Tìm khách hàng chưa có số điện thoại (IS NULL)

SELECT * FROM customers WHERE phone IS NULL;

-- Top 5 sản phẩm có giá cao nhất (ORDER BY + LIMIT)
SELECT * FROM products ORDER BY price DESC LIMIT 5;

-- Đếm số khách hàng theo thành phố (DISTINCT + COUNT)
SELECT city,COUNT(customer_id) FROM customers GROUP BY city;

--Tìm đơn hàng trong khoảng thời gian (BETWEEN với DATE)
SELECT * FROM orders WHERE order_date BETWEEN '2026-04-01' AND '2026-04-07';

-- Sản phẩm chưa được bán (NOT EXISTS)
