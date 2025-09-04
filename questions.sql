-- 📚 Library Management System SQL Project (20 Questions + Solutions)

-- Q1. List all books with their authors.
SELECT b.book_id, b.title, a.name AS author_name
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;

-- Q2. Find all members who joined in the year 2023.
SELECT *
FROM Members
WHERE YEAR(join_date) = 2023;

-- Q3. Show books that currently have 0 available copies.
SELECT book_id, title, genre, total_copies, available_copies
FROM Books
WHERE available_copies = 0;

-- Q4. Retrieve all borrowing records where the book was not returned.
SELECT *
FROM Borrow_Records
WHERE return_date IS NULL;

-- Q5. Find the top 5 most borrowed books.
SELECT b.title, COUNT(*) AS borrow_count
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
GROUP BY b.title
ORDER BY borrow_count DESC
LIMIT 5;

-- Q6. Show the most popular genre (by total borrows).
SELECT b.genre, COUNT(*) AS borrow_count
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
GROUP BY b.genre
ORDER BY borrow_count DESC
LIMIT 1;

-- Q7. List members who borrowed more than 10 books.
SELECT m.member_id, m.name, COUNT(*) AS total_borrows
FROM Members m
JOIN Borrow_Records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(*) > 10
ORDER BY total_borrows DESC;

-- Q8. Find all books borrowed by a particular member (e.g., member_id = 205).
SELECT br.record_id, b.book_id, b.title, b.genre, br.borrow_date, br.due_date, br.return_date
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
WHERE br.member_id = 205;

-- Q9. Show all overdue books.
SELECT br.record_id, m.member_id, m.name AS member_name, 
       b.book_id, b.title AS book_title, 
       br.borrow_date, br.due_date
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE br.return_date IS NULL
  AND br.due_date < CURRENT_DATE
ORDER BY br.due_date ASC;

-- Q10. Find the average borrowing duration (days) for returned books.
SELECT AVG(DATEDIFF(return_date, borrow_date)) AS avg_borrow_days
FROM Borrow_Records
WHERE return_date IS NOT NULL;

-- Q11. Find the author whose books are borrowed the most.
SELECT a.name, COUNT(*) AS total_borrows
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Authors a ON b.author_id = a.author_id
GROUP BY a.name
ORDER BY total_borrows DESC
LIMIT 1;

-- Q12. Show the top 5 most active members (borrow count).
SELECT m.member_id, m.name, COUNT(*) AS total_borrows
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.name
ORDER BY total_borrows DESC
LIMIT 5;

-- Q13. Find the percentage of members who borrowed at least one book.
SELECT 
    ROUND(
        (COUNT(DISTINCT br.member_id) * 100.0 / (SELECT COUNT(*) FROM Members)), 2
    ) AS percentage_of_active_members
FROM Borrow_Records br;

-- Q14. Show the monthly borrowing trend (number of books borrowed per month).
SELECT 
    YEAR(borrow_date) AS year,
    MONTH(borrow_date) AS month,
    COUNT(*) AS total_borrows
FROM Borrow_Records
GROUP BY YEAR(borrow_date), MONTH(borrow_date)
ORDER BY year, month;

-- Q15. Find members who borrowed books from 3 or more different genres.
SELECT m.member_id, m.name, COUNT(DISTINCT b.genre) AS genre_count
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(DISTINCT b.genre) >= 3
ORDER BY genre_count DESC;

-- Q16. Identify books borrowed but never returned.
SELECT br.record_id, b.book_id, b.title, m.name AS borrowed_by, br.borrow_date, br.due_date
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL;

-- Q17. Show the retention rate: members who borrowed in 2023 and again in 2024.
WITH Borrow2023 AS (
    SELECT DISTINCT member_id FROM Borrow_Records
    WHERE YEAR(borrow_date) = 2023
),
Borrow2024 AS (
    SELECT DISTINCT member_id FROM Borrow_Records
    WHERE YEAR(borrow_date) = 2024
)
SELECT 
    (SELECT COUNT(*) FROM Borrow2023) AS members_2023,
    (SELECT COUNT(*) FROM Borrow2023 b3 WHERE b3.member_id IN (SELECT member_id FROM Borrow2024)) AS retained_members,
    ROUND(
        ( (SELECT COUNT(*) FROM Borrow2023 b3 WHERE b3.member_id IN (SELECT member_id FROM Borrow2024)) * 100.0 
          / (SELECT COUNT(*) FROM Borrow2023) ), 2
    ) AS retention_rate_percent;

-- Q18. Find the longest overdue book (max days overdue).
SELECT br.record_id, b.title, m.name, 
       DATEDIFF(CURRENT_DATE, br.due_date) AS days_overdue
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL
  AND br.due_date < CURRENT_DATE
ORDER BY days_overdue DESC
LIMIT 1;

-- Q19. List the top 3 books for each genre (most borrowed).
SELECT genre, title, borrow_count
FROM (
    SELECT b.genre, b.title, COUNT(*) AS borrow_count,
           RANK() OVER (PARTITION BY b.genre ORDER BY COUNT(*) DESC) AS rnk
    FROM Borrow_Records br
    JOIN Books b ON br.book_id = b.book_id
    GROUP BY b.genre, b.title
) ranked_books
WHERE rnk <= 3
ORDER BY genre, borrow_count DESC;

-- Q20. Rank members by number of borrows.
SELECT m.member_id, m.name, COUNT(*) AS total_borrows,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_position
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.name
ORDER BY total_borrows DESC;
