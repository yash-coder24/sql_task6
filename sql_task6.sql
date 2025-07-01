-- SUBQUERIES AND NESTED QUERIES EXAMPLES
-- 1.Subquery in WHERE: Find books ordered by Susan Hicks 

SELECT Title 
FROM Books 
WHERE Book_ID IN (
    SELECT Book_ID 
    FROM Orders 
    WHERE Customer_ID = (
        SELECT Customer_ID 
        FROM Customers 
        WHERE Name = 'Susan Hicks'
    )
);
select*from customers
-- 2.Subquery in SELECT: Show each order with the book price
SELECT 
    o.Order_ID,
    c.Name AS Customer,
    b.Title AS Book,
    o.Quantity,
    (SELECT Price FROM Books WHERE Book_ID = o.Book_ID) AS Book_Price,
    (o.Quantity * (SELECT Price FROM Books WHERE Book_ID = o.Book_ID)) AS Total_Amount
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Books b ON o.Book_ID = b.Book_ID;

-- 3.Subquery in FROM: Find customers who ordered the most expensive book

SELECT Name
FROM Customers 
WHERE Customer_ID IN (
    SELECT Customer_ID 
    FROM Orders 
    WHERE Book_ID = (
        SELECT Book_ID 
        FROM Books 
        ORDER BY Price DESC 
        LIMIT 1
    )
);

-- 4.Correlated Subquery: Find books whose price is above the average price of books in the same genre

SELECT Title, Genre, Price
FROM Books b1
WHERE Price > (
    SELECT AVG(Price)
    FROM Books b2
    WHERE b1.Genre = b2.Genre
);

-- 5.Nested Subquery with Aggregation: Top customer by total quantity ordered.

SELECT Name 
FROM Customers 
WHERE Customer_ID = (
    SELECT Customer_ID 
    FROM Orders 
    GROUP BY Customer_ID 
    ORDER BY SUM(Quantity) DESC 
    LIMIT 1
);
