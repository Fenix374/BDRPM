CREATE TABLE Users (
    ID SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Address (
    ID SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users (ID),
    city VARCHAR(50),
    street VARCHAR(100),
    house_number VARCHAR(10),
    postal_code VARCHAR(10)
);

CREATE TABLE Payment_Method (
    ID SERIAL PRIMARY KEY,
    method VARCHAR(50)
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Game (
    ID SERIAL PRIMARY KEY,
    title VARCHAR(100),
    developer VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT REFERENCES Category (ID)
);

CREATE TABLE Discount (
    ID SERIAL PRIMARY KEY,
    description VARCHAR(100),
    percentage DECIMAL(5, 2)
);

CREATE TABLE Orders (
    ID SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users (ID),
    order_date DATE,
    total_amount DECIMAL(10, 2),
    payment_method_id INT REFERENCES Payment_Method (ID)
);

CREATE TABLE Order_Details (
    ID SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders (ID),
    game_id INT REFERENCES Game (ID),
    quantity INT,
    price DECIMAL(10, 2)
);

CREATE TABLE Order_Discount (
    ID SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders (ID),
    discount_id INT REFERENCES Discount (ID)
);

CREATE TABLE Review (
    ID SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users (ID),
    game_id INT REFERENCES Game (ID),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT
);

-- категории
INSERT INTO Category (name) VALUES ('Action'), ('RPG'), ('Simulator');

-- пользователи
INSERT INTO Users (name, email) VALUES ('Alex', 'alex@example.com'), ('Maria', 'maria@example.com');

-- адреса
INSERT INTO Address (user_id, city, street, house_number, postal_code) 
VALUES (1, 'Moscow', 'Lenina', '10', '101000'), (2, 'St. Petersburg', 'Pushkina', '20', '102000');

-- методы оплаты
INSERT INTO Payment_Method (method) VALUES ('Credit Card'), ('PayPal');

-- игры
INSERT INTO Game (title, developer, price, category_id)
VALUES ('Game A', 'Dev A', 199.99, 1), ('Game B', 'Dev B', 59.99, 2), ('Game C', 'Dev C', 99.99, 1);

-- скидки
INSERT INTO Discount (description, percentage) VALUES ('New Year Discount', 10), ('Loyalty Discount', 15);

-- заказы
INSERT INTO Orders (user_id, order_date, total_amount, payment_method_id) VALUES (1, '2024-10-01', 259.98, 1), (2, '2024-10-05', 199.99, 2);

-- детали заказов
INSERT INTO Order_Details (order_id, game_id, quantity, price) VALUES (1, 1, 1, 199.99), (1, 2, 1, 59.99), (2, 3, 1, 99.99);

-- скидка на заказ
INSERT INTO Order_Discount (order_id, discount_id) VALUES (1, 1);

-- отзывы
INSERT INTO Review (user_id, game_id, rating, comment) VALUES (1, 1, 5, 'Great game!'), (2, 2, 4, 'Interesting storyline.');

SELECT * FROM Orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY order_date DESC;

SELECT user_id, COUNT(*) AS order_count
FROM Orders
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT DISTINCT title
FROM Game
WHERE title LIKE 'Game%';

SELECT AVG(price) AS average_price FROM Game;

SELECT MAX(total_amount) AS max_total FROM Orders;

SELECT COUNT(*) AS total_orders FROM Orders;

SELECT ID, user_id, order_date, total_amount,
       AVG(total_amount) OVER () AS average_order_total
FROM Orders;