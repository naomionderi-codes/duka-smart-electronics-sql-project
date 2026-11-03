-- public.orders definition

-- Drop table

-- DROP TABLE public.orders;

CREATE TABLE public.orders (
	order_id int4 NOT NULL,
	customer_id int4 NOT NULL,
	order_date date NOT NULL,
	product_name varchar(100) NULL,
	product_category varchar(50) NULL,
	quantity int4 NULL,
	unit_price numeric(12, 2) NULL,
	cost_price numeric(12, 2) NULL,
	discount numeric(5, 2) DEFAULT 0 NULL,
	payment_method varchar(30) NULL,
	order_status varchar(20) NULL,
	CONSTRAINT orders_customer_id_not_null NOT NULL customer_id,
	CONSTRAINT orders_order_date_not_null NOT NULL order_date,
	CONSTRAINT orders_order_id_not_null NOT NULL order_id,
	CONSTRAINT orders_pkey PRIMARY KEY (order_id)
);


-- public.orders foreign keys

ALTER TABLE public.orders ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);

-- public.customers definition

-- Drop table

-- DROP TABLE public.customers;

CREATE TABLE public.customers (
	customer_id int4 NOT NULL,
	customer_name varchar(100) NOT NULL,
	gender varchar(10) NULL,
	city varchar(50) NULL,
	registration_date date NULL,
	customer_segment varchar(20) NULL,
	CONSTRAINT customers_customer_id_not_null NOT NULL customer_id,
	CONSTRAINT customers_customer_name_not_null NOT NULL customer_name,
	CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
);