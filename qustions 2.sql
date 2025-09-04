

# Q1. List all books with their authors.
select title as book_name, name as author_name from books join authors on books.author_id = authors.author_id;
select * from books;
select * from authors;
# Q2 Find all members who joined in the year 2023.
select * from members where year(join_date) = 2023;

# Q3. Show books that currently have 0 available copies
select * from books where available_copies = 0;

# Q4. Retrieve all borrowing records where the book was not returned (return_date IS NULL).
select * from borrow_records where return_date is null; 


# Q5. Find the top 5 most borrowed books.
 select title as book_name 
 from books where book_id in
 (select book_id from borrow_records 
 group by book_id order by book_id desc) 
 limit 5;
# Q6. Show the most popular genre (by total borrows).
select genre as book_genre 
 from books where book_id in
 (select book_id from borrow_records 
 group by book_id order by book_id desc) 
 limit 1;

# Q7. List members who borrowed more than 10 books.
select * from members;
select * from borrow_records;
SELECT m.member_id, m.name, COUNT(br.record_id) AS total_borrows
FROM Members m
JOIN Borrow_Records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(br.record_id) > 10
ORDER BY total_borrows DESC;


# Q8. Find all books borrowed by a particular member (e.g., member_id = 205).
select * from borrow_records;
select * from books;
select *
from books where book_id in
(select book_id from Borrow_Records 
where member_id = 503);

# Q9. Show all overdue books (where due_date < CURRENT_DATE and return_date IS NULL).
 select * from members 
 where member_id in
 (select member_id from Borrow_Records 
 where current_date() > due_date and 
 return_date is null);


# Q10. Find the average borrowing duration (days) for returned books.
select book_id, round(avg
(datediff(return_date,borrow_date)))
 as avg_duration from borrow_records 
group by book_id;




# Q11. Retrieve all borrowing records where the book was not returned (return_date IS NULL).
select * from borrow_records where return_date is null;

# Q12.Find the author whose books are borrowed the most.
select * from books where 
book_id in(select book_id 
from borrow_records group by book_id 
order by book_id desc) limit 1;


#Q13. Show the top 5 most active members (borrow count).

select member_id from borrow_records group by 
member_id order by count(*) desc limit 5;






#Q14. Find the percentage of members who borrowed at least one book.
SELECT 
    ROUND(
        (COUNT(DISTINCT br.member_id) * 100.0 / (SELECT COUNT(*) FROM Members)), 2
    ) AS percentage_of_active_members
FROM Borrow_Records br;


#Q15. Show the monthly borrowing trend (number of books borrowed per month).
SELECT 
    YEAR(borrow_date) AS year,
    MONTH(borrow_date) AS month,
    COUNT(*) AS total_borrows
FROM Borrow_Records
GROUP BY YEAR(borrow_date), MONTH(borrow_date)
ORDER BY year, month;

#Q16. Find members who borrowed books from 3 or more different genres.
SELECT m.member_id, m.name, COUNT(DISTINCT b.genre) AS genre_count
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(DISTINCT b.genre) >= 3
ORDER BY genre_count DESC;

#Q17.Identify books borrowed but never returned.
SELECT br.record_id, b.book_id, b.title, m.name AS borrowed_by, br.borrow_date, br.due_date
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL;

#Q18.Show the retention rate: how many members who borrowed in 2023 also borrowed again in 2024.
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

#Q19. Find the longest overdue book (max days overdue).
SELECT br.record_id, b.title, m.name, 
       DATEDIFF(CURRENT_DATE, br.due_date) AS days_overdue
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL
  AND br.due_date < CURRENT_DATE
ORDER BY days_overdue DESC
LIMIT 1;

#Q20. List the top 3 books for each genre (most borrowed).
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

#Q21. Rank members by number of borrows using a window function (ROW_NUMBER / RANK)
SELECT m.member_id, m.name, COUNT(*) AS total_borrows,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_position
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.name
ORDER BY total_borrows DESC;























