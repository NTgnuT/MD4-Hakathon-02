create database quanlybanhang;
use quanlybanhang;

create table customers(
	customer_id varchar(4) primary key not null,
    name varchar(100) not null,
    email varchar(100) not null,
    phone varchar(25) not null,
    address varchar(255) not null
);

INSERT INTO customers(customer_id,name,email,phone,address)VALUES
('C001','Nguyễn Trung Mạnh','manhnt@gmail.com','984756322','Cầu Giấy, Hà Nội'),
('C002','Hồ Hải Nam','namhh@gmail.com','984875926','Ba Vì, Hà Nội'),
('C003','Tô Ngọc Vũ','vutn@gmail.com','904725784','Mộc Châu, Sơn La'),
('C004','Phạm Ngọc Anh','anhpn@gmail.com','984635365','Vinh, Nghệ An'),
('C005','Trương Minh Cường','cuongtm@gmail.com','989735624','Hai Bà Trưng, Hà Nội');

create table orders (
	order_id varchar(4) primary key not null ,
    customer_id varchar(4) not null,
    foreign key (customer_id) references customers (customer_id),
    order_date date not null,
    total_amount double not null 
);

INSERT INTO ORDERS(order_id, customer_id, total_amount, order_date)VALUES
('H001','C001',52999997,'2023-02-22'),
('H002','C001',80999997,'2023-03-11'),
('H003','C002',54359998,'2023-01-22'),
('H004','C003',102999995,'2023-03-14'),
('H005','C003',80999997,'2022-03-12'),
('H006','C004',110449994,'2023-02-01'),
('H007','C004',79999996,'2023-03-29'),
('H008','C005',29999998,'2023-02-14'),
('H009','C005',28999999,'2023-01-10'),
('H010','C005',149999994,'2023-04-01');


create table products (
	product_id varchar (4) primary key not null,
    name varchar(255) not null,
    description text,
    price double not null,
    status bit(1) not null default 1
);

insert into products (product_id, name, description, price ) value ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999),
('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999),
('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);

create table order_detail(
	primary key(order_id, product_id),
	order_id varchar(4) not null,
    foreign key (order_id) references orders (order_id),
    product_id varchar (4) not null,
    foreign key (product_id) references products (product_id),
    quantity int (11) not null,
    price double not null
);

insert into order_detail(order_id, product_id, price, quantity) value ('H001', 'P002', 14999999, 1),
('H001', 'P004', 18999999, 2),
('H002', 'P001', 22999999, 1),
('H002', 'P003', 28999999, 2),
('H003', 'P004', 18999999, 2),
('H003', 'P005', 4090000, 4),
('H004', 'P002', 14999999, 3),
('H004', 'P003', 28999999, 2),
('H005', 'P001', 22999999, 1),
('H005', 'P003', 28999999, 2),
('H006', 'P005', 4090000, 5),
('H006', 'P002', 14999999, 6),
('H007', 'P004', 18999999, 3),
('H007', 'P001', 22999999, 1),
('H008', 'P002', 14999999, 2),
('H009', 'P003', 28999999, 1),
('H010', 'P003', 28999999, 2),
('H010', 'P001', 22999999, 4);

-- Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
-- [4 điểm]
	select name, email, phone, address from customers;
    
-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng). [4 điểm]
	select c.name, c.phone, c.address 
    from customers c
    join orders ord
    on c.customer_id = ord.customer_id
    where month(order_date) = 3 and year(order_date) = 2023
    group by c.customer_id;
    
    

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ). [4 điểm]
	select month(order_date) as 'Tháng', sum(total_amount) as 'Doanh thu'
    from orders
    group by month(order_date);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại). [4 điểm]
	select c.name, c.address, c.email, c.phone 
    from customers c
    left join orders ord on ord.customer_id = c.customer_id 
    and year(ord.order_date) = 2023 
    and month(ord.order_date) = 2
    where ord.order_id is null;

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
	select p.product_id, p.name, sum(o.quantity) as 'Số lượng bán ra'
    from products p
    join order_detail o on o.product_id = p.product_id
    join orders ord on o.order_id = ord.order_id
    where month(ord.order_date) = 3 and year(ord.order_date) = 2023
    group by p.product_id, p.name;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
	select c.customer_id, c.name, sum(o.total_amount) as 'Mức chi tiêu'
    from customers c 
    join orders o on o.customer_id = c.customer_id
    where year(o.order_date) = 2023
    group by c.customer_id
    order by sum(o.total_amount) desc;
    
-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
	select c.name as 'tên người mua', o.total_amount as 'tổng tiền', o.order_date as 'ngày tạo hoá đơn', sum(ord.quantity) as 'tổng số lượng sản phẩm'
    from orders o
    join customers c on c.customer_id = o.customer_id
    join order_detail ord on ord.order_id = o.order_id
    group by c.name, o.order_date, o.total_amount
    having sum(ord.quantity) >= 5;
    
    
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn . [3 điểm]
	create view v_orders as select c.name, c.phone, c.address, o.total_amount, o.order_date 
    from orders o
    join customers c on c.customer_id = o.customer_id;
    
-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt. [3 điểm]
	create view v_total_order as select c.name, c.address, c.phone, count(o.customer_id) as 'tổng số đơn đã đặt'
    from orders o
    join customers c on c.customer_id = o.customer_id
    group by c.name, c.address, c.phone;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.[3 điểm]
	create view v_show_info_pro as select p.name, p.description, p.price, sum(ord.quantity) as 'tổng số đơn đã bán ra'
    from orders o
    join order_detail ord on ord.order_id = o.order_id
    join products p on p.product_id = ord.product_id
    group by p.name, p.description, p.price;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
	create index index_phone_email ON customers (phone, email)

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
	delimiter //
    create procedure info_cus (IN cus_id varchar(4))
    BEGIN
		select * from customers 
        where cus_id = customer_id;
	END ;
    //
	
	call info_cus ('C001');
-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
	delimiter //
    create procedure get_all_product ()
    BEGIN
		select * from products ;
	END ;
    //
    
    call get_all_product();
-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]
	delimiter //
    create procedure show_order_in_cus_id (IN cus_id varchar(4))
    BEGIN
		select o.order_id, o.customer_id, o.order_date, o.total_amount from orders o
        left join customers c on c.customer_id = o.customer_id
        where cus_id = o.customer_id;
	END ;
    //

	call show_order_in_cus_id('C001');
-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
	delimiter //
    create procedure add_new_order (IN order_id_new varchar(4), customer_id_new varchar(4), total_amount_new double, order_date_new date )
    BEGIN
		insert into orders (order_id, customer_id, total_amount, order_date) value (order_id_new, customer_id_new, total_amount_new, order_date_new);
        select * from orders
        where order_id_new = order_id;
	END ;
    //
	
    call add_new_order('H020','C002',52999997,'2023-02-22');
-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
	delimiter //
    create procedure show_number_sale (IN start_day date, end_day date)
    BEGIN
        select p.name, sum(ord.quantity) 
        from products p
        join order_detail ord on p.product_id = ord.product_id
        join orders o on o.order_id = ord.order_id
        where o.order_date >= start_day and o.order_date <= end_day
        group by p.name;
	END ;
    //

	call show_number_sale('2023-02-11', '2023-02-14');

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]
   delimiter //
    create procedure show_number_sale_for_month_and_year (IN month_in int, year_in int)
    BEGIN
        select p.name, sum(ord.quantity) 
        from products p
        join order_detail ord on p.product_id = ord.product_id
        join orders o on o.order_id = ord.order_id
        where month(o.order_date) = month_in and year(o.order_date) = year_in
        group by p.name
        order by sum(ord.quantity) desc;
	END ;
    //
    
    call show_number_sale_for_month_and_year(3, 2023);