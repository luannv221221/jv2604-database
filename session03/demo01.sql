-- TAOJ MOOI QUAN HEJ 1 1 BANG KHOA NGOAI
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(150) NOT NULL
);

CREATE TABLE user_infors(
	user_infor_id  SERIAL PRIMARY KEY,
	bio TEXT,
	address VARCHAR(255),
	user_id INT NOT NULL UNIQUE,
	CONSTRAINT fk_user_user_infor FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
DROP Table users;
DROP Table user_infors;

-- CACH 2: 
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(150) NOT NULL
);
CREATE TABLE user_infors(
	user_id INT PRIMARY KEY,
	bio TEXT,
	address VARCHAR(255),
	CONSTRAINT fk_user_user_infor FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Câu lệnh INSERT
-- them moi 1 dong
INSERT INTO users(username,password) VALUES ('abc','123456');
-- them moi nhieu ban ghi
INSERT INTO users(username,password) VALUES 
('a1','123456'),
('b1','123456'),
('a2','123456'),
('b3','123456'),
('a3','123456'),
('b4','123456'),
('a5','123456'),
('b32','123456'),
('a12','123456'),
('b412','123456');
SELECT * FROM users;

-- Câu lệnh update 
-- chỉnh sửa bản trường password của bản ghi trong bảng users có id = 1

UPDATE users SET "password" = 'Password mới' WHERE user_id = 1;

-- CÂU LỆNH XÓA BẢN GHI 
DELETE FROM users WHERE user_id = 1;
DELETE FROM users WHERE user_id = 2 OR user_id = 3;
DELETE FROM users; -- xóa hết bản ghi 

-- CÂU LỆNH SELECT 
-- 1. Lấy tất cả bản ghi và thông tin của bản ghi trong bảng 
SELECT * FROM users;
--2. Lấy id, username của bảng users
SELECT user_id,username FROM users;

-- LIMIT VÀ OFFSET
-- LIMIT Gioi Han so ban ghi
SELECT * FROM users LIMIT 10;

-- Ung dung trong bai toan phan tran 
-- có 13 rows và muốn phân trang mỗi trang có 5 users ==> 3 Trang 
-- Trang 1
SELECT * FROM users LIMIT 5 OFFSET 0; -- Bỏ qua 0 dòng và lấy 5 dòng
-- Trang 2
SELECT * FROM users LIMIT 5 OFFSET 5;
-- TRANG 3 
SELECT * FROM users LIMIT 5 OFFSET 10;

-- DISTINCT 
SELECT DISTINCT password FROM users;

INSERT INTO user_infors(user_id,address) VALUES (7,'HA NOI');
INSERT INTO user_infors(user_id,bio,address) VALUES (8,'','HA NOI');

SELECT * FROM user_infors;
NULL = NULL => Unknown

-- ORDER BY
SELECT * FROM users ORDER BY user_id DESC;

-- SAP XEP THEO NHIEU COT 
SELECT * FROM users ORDER BY username DESC, user_id ASC -- SQL sẽ sắp sếp theo username trươc, nếu có 2 dòng username trùng nhau thì sẽ dùng đến user_id để phân dịnh thứ tự;

-- SELECT 
-- SELECT WHERE 
SELECT * FROM users WHERE username = 'b';

-- AND 
SELECT * FROM users WHERE username = 'b' AND user_id = 10;

-- OR 
SELECT * FROM users WHERE username = 'b' OR user_id = 10;
SELECT * FROM users WHERE  NOT password != '123456'

-- LIKE 
-- TÌM KIẾM bản ghi có username bắt đầu bawfg chữ a
SELECT * FROM users WHERE username LIKE 'a%';

-- TIM KIẾM BẢN GHI CÓ username kết thuc bằng chữ c
SELECT * FROM users WHERE username LIKE '%c';

-- TIM KIEM BAN GHI Co chua tu 1
SELECT * FROM users WHERE username LIKE '%1%'

-- Tìm BẢN GHI CÓ username có đôi là 12 và đằng trước là 1 ký tự bất kỳ
SELECT * FROM users WHERE username LIKE '_12';

-- BETWEEN AND 
SELECT * FROM users WHERE user_id >= 10 AND user_id <= 18;
SELECT * FROM users WHERE user_id BETWEEN 10 AND 18;
