# Bài 1: Tạo CSDL[20 điểm]:
-- drop database QUANLYBANHANG2;
CREATE DATABASE QUANLYBANHANG2;
USE QUANLYBANHANG2;
CREATE TABLE CUSTOMERS
(
    customer_id VARCHAR(4)   NOT NULL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    phone       VARCHAR(25)  NOT NULL,
    address     VARCHAR(255) NOT NULL
);
CREATE TABLE ORDERS
(
    order_id     VARCHAR(4) NOT NULL PRIMARY KEY,
    customer_id  VARCHAR(4) NOT NULL,
    total_amount DOUBLE     NOT NULL,
        order_date   DATE       NOT NULL

);
ALTER TABLE ORDERS
    ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES CUSTOMERS (customer_id);
CREATE TABLE PRODUCTS
(
    product_id  VARCHAR(4)   NOT NULL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    price       DOUBLE       NOT NULL,
    status      BIT(1)
);
CREATE TABLE ORDER_DETAIL
(
    order_id   VARCHAR(4) NOT NULL,
    product_id VARCHAR(4) NOT NULL,
    price      DOUBLE     NOT NULL,
     quantity   INT        NOT NULL
);
ALTER TABLE ORDER_DETAIL
    ADD CONSTRAINT pk_com PRIMARY KEY (order_id, product_id);
ALTER TABLE ORDER_DETAIL
    ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES ORDERS (order_id);
ALTER TABLE ORDER_DETAIL
    ADD CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES PRODUCTS (product_id);
    
    
    
-- Bài 2: Thêm dữ liệu [20 điểm]:
INSERT INTO CUSTOMERS VALUES
('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');


INSERT INTO PRODUCTS  VALUES
('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999, 1),
('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999, 1),
('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000, 1);

INSERT INTO ORDERS  VALUES
('H001', 'C001', 52999997, '2023-02-22'),
('H002', 'C001', 80999997, '2023-03-11'),
('H003', 'C002', 54359998, '2023-01-22'),
('H004', 'C003', 102999995, '2023-03-14'),
('H005', 'C003', 80999997, '2022-03-12'),
('H006', 'C003', 110449994, '2023-02-01'),
('H007', 'C004', 79999996, '2023-03-29'),
('H008', 'C004', 29999998, '2023-02-14'),
('H009', 'C005', 29999999, '2023-01-10'),
('H010', 'C005', 149999994, '2023-04-01');
INSERT INTO ORDER_DETAIL VALUES 
('H001','P002',14999999,1),
('H001','P004',18999999,2),
('H002','P001',22999999,1),
('H002','P003',28999999,2),
('H003','P004',18999999,2),
('H003','P005',4090000,4),
('H004','P002',14999999,3),
('H004','P003',28999999,2),
('H005','P001',22999999,1),
('H005','P003',28999999,2),
('H006','P005',4090000,5),
('H006','P002',14999999,6),
('H007','P004',18999999,3),
('H007','P001',22999999,1),
('H008','P002',14999999,2),
('H009','P003',28999999,1),
('H010','P003',28999999,2),
('H010','P001',22999999,4);

-- Bài 3: Truy vấn dữ liệu

-- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers
SELECT name,email,phone,address FROM CUSTOMERS;

-- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
SELECT C.name, C.phone, C.address
FROM CUSTOMERS C
JOIN (
    SELECT O.customer_id
    FROM ORDERS O
    WHERE MONTH(O.order_date) = 3
    GROUP BY O.customer_id
) AS SubQ
ON C.customer_id = SubQ.customer_id;


-- Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ).

SELECT 
    MONTH(order_date) AS Thang, 
    SUM(total_amount) AS TongDoanhThu
FROM ORDERS
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(order_date)
ORDER BY Thang;


-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
SELECT name, phone, address
FROM CUSTOMERS
WHERE customer_id IN (
    SELECT customer_id
    FROM ORDERS
    WHERE MONTH(order_date) = 3 AND YEAR(order_date) = 2023
);

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).

SELECT P.product_id, P.name, SUM(OD.quantity) AS soluong_ban_thang_3_2023
FROM PRODUCTS P
JOIN ORDER_DETAIL OD ON P.product_id = OD.product_id
JOIN ORDERS O ON OD.order_id = O.order_id
WHERE MONTH(O.order_date) = 3 AND YEAR(O.order_date) = 2023
GROUP BY P.product_id, P.name;


-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).

SELECT C.name, C.phone, SUM(O.total_amount) AS tong_chi_tieu
FROM CUSTOMERS C
JOIN ORDERS O ON C.customer_id = O.customer_id
WHERE YEAR(O.order_date) = 2023
GROUP BY C.name, C.phone
ORDER BY tong_chi_tieu DESC;

-- Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)


SELECT 
c.name AS "Tên",
o.order_date AS "Ngày tạo đơn ",
SUM(od.quantity) AS "Tổng số lượng",
SUM(o.total_amount) AS "Tổng tiền"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_detail od ON o.order_id = od.order_id
GROUP BY c.name, o.order_id, o.order_date
HAVING SUM(od.quantity) >= 5;

-- Bài 4:

-- 1
-- Tạo view lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn .
CREATE VIEW TTHD AS
SELECT C.name AS 'Tên khách hàng',
       C.phone AS 'Số điện thoại',
       C.address AS 'Địa chỉ',
       O.total_amount AS 'Tổng tiền',
       O.order_date AS 'Ngày tạo hoá đơn'
FROM CUSTOMERS C
JOIN ORDERS O ON C.customer_id = O.customer_id;
SELECT * FROM TTHD;



-- 2
-- Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt.

CREATE VIEW TTKH AS
SELECT C.name AS 'Tên khách hàng',
       C.phone AS 'Số điện thoại',
       C.address AS 'Địa chỉ',
       COUNT(O.order_id) AS 'Tổng số đơn đã đặt'
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.customer_id = O.customer_id
GROUP BY C.name, C.phone, C.address;
SELECT * FROM TTKH;
-- 3
-- Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.

CREATE VIEW TTSP AS
SELECT P.name AS 'Tên sản phẩm',
       P.description AS 'Mô tả',
       P.price AS 'Giá',
       SUM(OD.quantity) AS 'Tổng số lượng đã bán ra'
FROM PRODUCTS P
LEFT JOIN ORDER_DETAIL OD ON P.product_id = OD.product_id
GROUP BY P.name, P.description, P.price;
SELECT * FROM TTSP;

-- 4
-- Đánh Index cho trường `phone` và `email` của bảng Customer.
CREATE INDEX idx_phone ON CUSTOMERS (phone);
CREATE INDEX idx_email ON CUSTOMERS (email);

-- 5 
DELIMITER &&
CREATE PROCEDURE GetCustomerInfo(IN customer_id VARCHAR(4))
BEGIN
    SELECT * FROM CUSTOMERS WHERE customer_id = customer_id;
END&& DELIMITER ;



-- 6
DELIMITER &&
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM PRODUCTS;
END && DELIMITER ;



-- 7
DELIMITER &&
CREATE PROCEDURE GetOrdersByCustomerId(IN customer_id VARCHAR(4))
BEGIN
    SELECT * FROM ORDERS WHERE customer_id = customer_id;
END && DELIMITER ;

-- 9
DELIMITER &&
CREATE PROCEDURE GetProductSalesBetweenDates(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT p.name AS 'Tên sản phẩm',
           p.product_id AS 'Mã sản phẩm',
           p.description AS 'Mô tả',
           COUNT(od.product_id) AS 'Số lượng đã bán'
    FROM PRODUCTS p
	JOIN ORDER_DETAIL od ON p.product_id = od.product_id
	JOIN ORDERS o ON od.order_id = o.order_id
    WHERE o.order_date BETWEEN start_date AND end_date
    GROUP BY p.product_id;
END && DELIMITER ;

CALL GetProductSalesBetweenDates('2023-01-22','2023-03-22');
