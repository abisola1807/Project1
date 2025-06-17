DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
  customer_id   INTEGER PRIMARY KEY,
  name          TEXT,
  email         TEXT
);

CREATE Table Products (
  product_id    INTEGER PRIMARY KEY,
  name          TEXT,
  price         REAL
);

CREATE Table Orders (
  order_id      INTEGER PRIMARY KEY,
  customer_id   INTEGER,
  order_date    DATE,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
  order_item_id INTEGER PRIMARY KEY,
  order_id      INTEGER,
  product_id    INTEGER,
  quantity      INTEGER,
  FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


INSERT INTO Customers (customer_id, name, email) VALUES
  (1, 'Amina Okafor',       'amina.okafor@gmail.com'),
  (2, 'Daniel O''Neill',    'daniel.oneill@gmail.com'),
  (3, 'Chioma Nwosu',       'chioma.nwosu@gmail.com'),
  (4, 'Mateo Alvarez',      'mateo.alvarez@gmail.com'),
  (5, 'Olivia Smith',       'olivia.smith@gmail.com'),
  (6, 'Tariq Al-Mansour',   'tariq.al-mansour@gmail.com');

INSERT INTO Products (product_id, name, price) VALUES
  (1, 'Smartphone',     699.99),
  (2, 'Tablet',         329.50),
  (3, 'Laptop',         1199.00),
  (4, 'Smartwatch',     199.99),
  (5, 'Headphones',     149.95);

-- 2. Insert six orders (one per customer)
INSERT INTO Orders (order_id, customer_id, order_date) VALUES
  (101, 1, '2025-06-10'),
  (102, 2, '2025-06-11'),
  (103, 3, '2025-06-12'),
  (104, 4, '2025-06-13'),
  (105, 5, '2025-06-14'),
  (106, 6, '2025-06-15');



-- 3. Insert order items (at least one per order, some multiple)
INSERT INTO OrderItems (order_item_id, order_id, product_id, quantity) VALUES
  (1,  101, 1, 1),  -- Amina buys 1 Smartphone
  (2,  101, 5, 2),  -- Amina also buys 2 Headphones
  (3,  102, 2, 1),  -- Daniel buys 1 Tablet
  (4,  103, 3, 1),  -- Chioma buys 1 Laptop
  (5,  103, 4, 1),  -- Chioma also buys 1 Smartwatch
  (6,  104, 5, 3),  -- Mateo buys 3 Headphones
  (7,  105, 1, 2),  -- Olivia buys 2 Smartphones
  (8,  106, 4, 1);  -- Tariq buys 1 Smartwatch

SELECT * FROM Orders;

SELECT * FROM OrderItems;

-- Total Number of Orders
SELECT 
  COUNT(*) AS total_orders
FROM Orders;

-- Total Revenue
SELECT 
  SUM(oi.quantity * p.price) AS total_revenue
FROM OrderItems oi
JOIN Products p 
  ON oi.product_id = p.product_id;

-- orders by customer
SELECT 
  c.name,
  COUNT(o.order_id) AS orders_placed
FROM Customers c
LEFT JOIN Orders o 
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Most popular product by units sold
SELECT 
  p.name,
  SUM(oi.quantity) AS total_units_sold
FROM Products p
JOIN OrderItems oi 
  ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_units_sold DESC
LIMIT 1;

--revenue by customer
SELECT 
  c.name,
  SUM(oi.quantity * p.price) AS revenue
FROM Customers c
JOIN Orders o 
  ON c.customer_id = o.customer_id
JOIN OrderItems oi 
  ON o.order_id = oi.order_id
JOIN Products p 
  ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name;

-- show order details using inner join
SELECT 
  o.order_id,
  c.name   AS customer,
  p.name   AS product,
  oi.quantity,
  (oi.quantity * p.price) AS item_revenue
FROM OrderItems oi
JOIN Orders o 
  ON oi.order_id = o.order_id
JOIN Customers c 
  ON o.customer_id = c.customer_id
JOIN Products p 
  ON oi.product_id = p.product_id
ORDER BY o.order_id;


-- unsold product using left join
SELECT 
  p.name       AS product,
  COALESCE(SUM(oi.quantity), 0) AS units_sold
FROM Products p
LEFT JOIN OrderItems oi 
  ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name;


