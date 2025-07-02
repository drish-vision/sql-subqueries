CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10, 2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers VALUES
(1, 'Alice', 'Chennai'),
(2, 'Bob', 'Delhi'),
(3, 'Charlie', 'Chennai'),
(4, 'David', 'Mumbai');

INSERT INTO Orders VALUES
(101, 1, 1500, '2025-06-10'),
(102, 1, 2000, '2025-06-15'),
(103, 2, 500, '2025-06-12'),
(104, 3, 1000, '2025-06-14');

SELECT 
    name,
    (SELECT SUM(amount) 
     FROM Orders 
     WHERE Orders.customer_id = Customers.customer_id) AS total_spent
FROM Customers;

SELECT * FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM Orders
);

SELECT * FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.customer_id = c.customer_id
);

SELECT name FROM Customers
WHERE (SELECT SUM(amount) 
       FROM Orders 
       WHERE Orders.customer_id = Customers.customer_id) > 1000;

SELECT name, avg_amount
FROM (
    SELECT customer_id, AVG(amount) AS avg_amount
    FROM Orders
    GROUP BY customer_id
) AS avg_orders
JOIN Customers ON Customers.customer_id = avg_orders.customer_id;

SELECT DISTINCT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.amount > (
    SELECT AVG(amount) 
    FROM Orders o2 
    WHERE o2.customer_id = o.customer_id
);
