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


-- cần tính tổng chi tiêu của một khách hàng dựa trên mã khách hàng 
-- SELECT SUM(total_amount) FROM orders WHERE customer_id = 1;

CREATE OR REPLACE FUNCTION get_total_amount_by_customer_id(customer_id_p INT)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
DECLARE
	total DECIMAL;
BEGIN
	SELECT SUM(total_amount) INTO total FROM orders WHERE customer_id = customer_id_p;
	RETURN COALESCE(total,0);
END
$$;

-- Gọi Ham 
SELECT get_total_amount_by_customer_id(11);


-- Trigger

CREATE TABLE trig.categories(
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL UNIQUE,
	descroption TEXT
);

CREATE TABLE trig.products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(150) NOT NULL,
	category_id INT REFERENCES trig.categories(category_id),
	price DECIMAL(15,2) CHECK (price > 0),
	stock_quantity INT CHECK (stock_quantity > 0)
);

CREATE TABLE trig.customers(
	customer_id  SERIAL PRIMARY KEY,
	customer_name VARCHAR(150) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	city VARCHAR(100),
	join_date DATE DEFAULT CURRENT_DATE
);


CREATE TABLE trig.suppliers(
	supplier_id  SERIAL PRIMARY KEY,
	supplier_name VARCHAR(150) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	city VARCHAR(100),
	join_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE trig.orders(
	order_id   SERIAL PRIMARY KEY,
	customer_id INT REFERENCES trig.customers(customer_id),
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	total_amount DECIMAL(15,2),
	status VARCHAR(50) DEFAULT 'PENDING'
);

CREATE TABLE trig.order_items(
	order_id INT REFERENCES trig.orders(order_id),
	product_id  INT REFERENCES trig.products(product_id),
	quantity INT,
	unit_price DECIMAL(15,2)
);


-- CHENF THEM DU LIEU 
INSERT INTO trig.categories(category_name,descroption) VALUES 
('Ao So Mi','Mo tar danh mucj'),
('Ao Mua He','Mo tar danh mucj'),
('Ao Mua Thu Dong','Mo tar danh mucj');


INSERT INTO trig.products(product_name,category_id,price,stock_quantity) VALUES 
('Ao so mi 01 CAO AP',1,100,10),
('Ao mua he 01 CAO AP',2,50,10),
('Ao mua he 02 CAO AP',1,150,10);


SELECT * FROM trig.products;

-- thêm trường sale price vào bảng trig.products
ALTER TABLE trig.products ADD COLUMN sale_price DECIMAL(15,2)

UPDATE trig.products SET sale_price = 150 WHERE product_id = 1;

-- Khi mà thực hiện update hoặc inserrt vào bảng products trên trường sale_price mà KM lớn hơn giá gốc Hoặc nhỏ hơn 0 thì báo lõi
CREATE OR REPLACE FUNCTION trig.check_sale_price()
RETURNS TRIGGER AS $$
BEGIN 
	IF NEW.sale_price > NEW.price THEN
		RAISE EXCEPTION 'Gia khuyen mai khong duoc lon hon gia goc';
	END IF;

	IF NEW.sale_price < 0 THEN
		RAISE EXCEPTION 'Gia khuyen mai khong duoc nho hon 0';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_valiadte_sale_pirce
BEFORE INSERT OR UPDATE ON trig.products
FOR EACH ROW
EXECUTE FUNCTION trig.check_sale_price()
-- test
UPDATE trig.products SET sale_price = -10 WHERE product_id = 1;

SELECT * FROM trig.products;


-- Thay doi lan truyen 
SELECT * FROM trig.categories;

SELECT * FROM trig.products;

-- Theem cot qty_product vafo bang categories
ALTER TABLE trig.categories ADD COLUMN qty_product INT;

UPDATE trig.categories SET qty_product = 2 WHERE category_id = 1;
UPDATE trig.categories SET qty_product = 1 WHERE category_id = 2;
UPDATE trig.categories SET qty_product = 0 WHERE category_id = 3;

-- Theem 1 san pham co danh muc id = 3 
INSERT INTO trig.products(product_name,category_id,price,stock_quantity) VALUES 
('Ao so mi 03 CAO AP',3,100,10);

-- Xay dung trigger de khi INSERT HOACJ UPDATE HOAC DELETE TREN BANG SAN PHAM THI du lieu cua bang danh muc tu dong cap nhat

CREATE OR REPLACE FUNCTION trig.fun_update_qty_product()
RETURNS TRIGGER AS $$
BEGIN
	IF(TG_OP = 'INSERT') THEN
	UPDATE trig.categories SET qty_product = qty_product + 1 WHERE category_id = NEW.category_id;
	RETURN NEW;

	ELSEIF(TG_OP = 'UPDATE') THEN
		IF(OLD.category_id != NEW.category_id) THEN
			UPDATE trig.categories SET qty_product  = qty_product - 1 WHERE category_id = OLD.category_id;

			UPDATE trig.categories SET qty_product  = qty_product + 1 WHERE category_id = NEW.category_id;
		END IF;
		RETURN NEW;
	ELSEIF(TG_OP = 'DELETE') THEN
		UPDATE trig.categories SET qty_product  = qty_product - 1 WHERE category_id = OLD.category_id;
		RETURN OLD;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_update_qty_product
AFTER INSERT OR UPDATE OR DELETE ON trig.products
FOR EACH ROW
EXECUTE FUNCTION trig.fun_update_qty_product();


INSERT INTO trig.products(product_name,category_id,price,stock_quantity) VALUES ('MOI MOI',3,100,10);

UPDATE trig.products SET product_name = 'hihi' WHERE product_id = 1;
UPDATE trig.products SET category_id = 2,product_name='KAHA'  WHERE product_id = 1;
DELETE FROM trig.products WHERE product_id = 3;
SELECT * FROM trig.products;
SELECT * FROM trig.categories;

CREATE TABLE trig.product_history(
	product_id INT,
	old_price decimal,
	new_price decimal,
	changed_at TIME,
);

CREATE OR REPLACE FUNCTION log_product()
RETURN TRIGGER AS $$
BEGIN
	IF NEW.price != OLD.price THEN
	INSERT INTO product_history(product_id,old_price,new_price,changed_at) VALUE(OLD.product_id,OLD.price,NEW.price,NOW());
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

