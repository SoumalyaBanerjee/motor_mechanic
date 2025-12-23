SELECT current_database(), current_user;


CREATE SCHEMA urban_services ;

CREATE TABLE urban_services.users (
user_id SERIAL PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone_number VARCHAR(15) UNIQUE NOT NULL,
password_hash VARCHAR(255) NOT NULL,
role VARCHAR(20) CHECK (role IN ('CUSTOMER', 'MECHANIC', 'ADMIN')),
city VARCHAR(50),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP
);

CREATE TABLE urban_services.mechanic_details (
mechanic_id INT PRIMARY KEY REFERENCES urban_services.users(user_id),
mechanic_name VARCHAR(100) NOT NULL,
mechanic_mob_no VARCHAR(15) UNIQUE NOT NULL,
mechanic_address1 VARCHAR(255),
mechanic_pin VARCHAR(10),
mechanic_category VARCHAR(50),
experience_years INT,
workshop_name VARCHAR(100),
verified_status VARCHAR(10) CHECK (verified_status IN ('YES', 'NO')),
avg_rating NUMERIC(2,1)
);

INSERT INTO urban_services.mechanic_details
(mechanic_id, mechanic_name, mechanic_mob_no, mechanic_address1, mechanic_pin, mechanic_category,
experience_years, workshop_name, verified_status, avg_rating)
VALUES
(1, 'Toton', '7003979633', 'Vip Road, Kaikhali, Kolkata', '700052', 'HEAD MECHANIC', 28, 'M Electric', NULL, NULL),
(2, 'Asgar Ali', '7908354733', 'Vip Road, Kaikhali, Kolkata', '700052', 'HEAD MECHANIC', 20, 'MM Motors', NULL, NULL),
(3, 'Enamul Haque', '9836864307', 'Rajarhat Road, Kolkata', '700135', 'OWNER', 30, 'Tofa Auto', NULL, NULL),
(4, 'Hafiz', '7687912106', 'Rajarhat Road, Kolkata', '700135', 'OWNER', 15, 'Hafiz Bike Point', NULL, NULL),
(5, 'Sanjay Dhara', '7076577134', 'Garia Station, Kamalgachi, Kolkata', '700084', 'HEAD MECHANIC, OWNER', 20, 'Dhara Bike Repair', NULL, NULL),
(6, 'Raj Mondal', '9123012146', 'Sarkar Bagan, Teghoria, Kolkata', '700059', 'HEAD MECHANIC, OWNER', 10, 'Mondal Garage', NULL, NULL),
(7, 'Dilip Yadav', '9339295441', 'Jessore Road, Dum Dum, Kolkata', '700080', NULL, 10, 'Dilip Service Centre', NULL, NULL),
(8, 'Randeep Basak', '9062500455', '91 Bus Route, Above SRCM Rd, Gopalpur, Kolkata', '700136', NULL, 15, 'Lokenath Auto Works', NULL, NULL);

CREATE TABLE urban_services.bookings (
order_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES urban_services.users(user_id),
mechanic_id INT REFERENCES urban_services.mechanic_details(mechanic_id),
bike_brand VARCHAR(50),
bike_model VARCHAR(50),
bike_reg_no VARCHAR(20),
service_category VARCHAR(50),
service_type VARCHAR(50),
preferred_date DATE,
preferred_time TIME,
service_notes TEXT,
estimated_cost NUMERIC(10,2),
payment_method VARCHAR(20),
payment_status VARCHAR(20) DEFAULT 'pending',
razorpay_order_id VARCHAR(100),
order_status VARCHAR(20) DEFAULT 'pending',
created_at TIMESTAMP DEFAULT NOW()
);
