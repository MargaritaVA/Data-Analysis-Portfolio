-- CRM Database Schema Design

/*Datebase consists of six tables:
- customers 
- addresses
- vehicles
- policies
- claims
- communications*/

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
	  dob DATE,
    Email VARCHAR(50),
    Phone VARCHAR(20)
);

CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    address VARCHAR(100),
    city VARCHAR(50),
    post_code VARCHAR(10),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
	vrn VARCHAR(20),
    make VARCHAR(50),
    model VARCHAR(50),
    `year` YEAR,
    seats INT,
    fuel VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE UNIQUE INDEX vrn_unique ON vehicles(vrn);

CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    policy_number VARCHAR(20),
    start_date DATE,
    end_date DATE,
    premium DECIMAL(10,2),
    cover_type VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE claims (
    claim_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT,
    claim_date DATE,
    amount DECIMAL(10,2),
    `status` VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE communications (
    communication_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    `date` DATE,
    `type` VARCHAR(50), -- e.g., Phone, Email
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- Sample Data 


INSERT INTO customers (customer_id, first_name, last_name, dob, email, phone) VALUES
(1, 'Jane', 'Smith', '1990-02-28', 'janesmith@example.com', '555-234-5678'),
(2, 'Robert', 'Johnson', '1978-11-20', 'robertjohnson@example.com', '555-345-6789'),
(3, 'Emily', 'Davis', '1982-07-10', 'emilydavis@example.com', '555-456-7890'),
(4, 'Michael', 'Brown', '1995-09-05', 'michaelbrown@example.com', '555-567-8901'),
(5, 'Jessica', 'Wilson', '1988-03-18', 'jessicawilson@example.com', '555-678-9012');

INSERT INTO addresses (address_id, customer_id, address, city, post_code) VALUES
(1, 1, '10 Downing Street', 'London', 'SW1A 2AA'),
(2, 2, '77 Hope Street', 'Glasgow', 'G2 6AE'),
(3, 3, '1 Abbey Road', 'London', 'NW8 9AY'),
(4, 4, '32 Windsor Gardens', 'London', 'W9 3RJ'),
(5, 5, '50 High Street', 'Edinburgh', 'EH1 1SY');

INSERT INTO vehicles (vehicle_id, customer_id, vrn, make, model, `year`, seats, fuel) VALUES
(1, 1, 'AB12 CDE', 'Ford', 'Focus', 2015, 5, 'Petrol'),
(2, 2, 'CD34 EFG', 'Volkswagen', 'Golf', 2018, 5, 'Diesel'),
(3, 3, 'EF56 HIJ', 'BMW', '3 Series', 2020, 5, 'Petrol'),
(4, 4, 'GH78 KLM', 'Audi', 'A4', 2017, 5, 'Diesel'),
(5, 5, 'IJ90 NOP', 'Toyota', 'Prius', 2019, 5, 'Hybrid');

INSERT INTO policies (policy_id, customer_id, policy_number, start_date, end_date, premium, cover_type) VALUES
(1, 1, 'IN12345', '2023-01-01', '2024-01-01', 500.00, 'Comprehensive'),
(2, 2, 'IN12346', '2023-03-15', '2024-03-15', 600.00, 'Third Party'),
(3, 3, 'IN12347', '2023-05-20', '2024-05-20', 450.00, 'Comprehensive'),
(4, 4, 'IN12348', '2023-07-01', '2024-07-01', 700.00, 'Third Party, FT'),
(5, 5, 'IN12349', '2023-09-10', '2024-09-10', 550.00, 'Comprehensive');

INSERT INTO claims (claim_id, policy_id, claim_date, amount, `status`) VALUES
(1, 1, '2023-02-10', 1200.00, 'Approved'),
(2, 2, '2023-04-15', 2500.00, 'Pending'),
(3, 3, '2023-06-05', 800.00, 'Denied'),
(4, 4, '2023-08-20', 1500.00, 'Approved'),
(5, 5, '2023-10-01', 900.00, 'Pending');

INSERT INTO communications (communication_id, customer_id, `date`, `type`, notes) VALUES
(1, 1, '2023-01-05', 'Email', 'Sent policy renewal reminder.'),
(2, 2, '2023-02-10', 'Phone Call', 'Discussed coverage options and premium adjustments.'),
(3, 3, '2023-03-15', 'Letter', 'Received documents for new policy application.'),
(4, 4, '2023-04-20', 'Email', 'Sent claim approval confirmation.'),
(5, 5, '2023-05-25', 'Phone Call', 'Follow-up on recent claim submission.');


-- Query Test

/*Testing the relation between tables using JOINs*/
SELECT DISTINCT
    c.first_name, c.last_name, cl.claim_id, cl.claim_date
FROM
    customers c
        LEFT JOIN
    policies p ON c.customer_id = p.customer_id
        LEFT JOIN
    claims cl ON p.policy_id = cl.policy_id
WHERE
    cl.claim_id IS NOT NULL
ORDER BY cl.claim_date DESC;
