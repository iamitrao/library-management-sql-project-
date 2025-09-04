CREATE TABLE `Authors` (
  `author_id` int PRIMARY KEY,
  `name` varchar(255),
  `birth_year` int
);

CREATE TABLE `Books` (
  `book_id` int PRIMARY KEY,
  `title` varchar(255),
  `genre` varchar(255),
  `author_id` int,
  `total_copies` int,
  `available_copies` int
);

CREATE TABLE `Members` (
  `member_id` int PRIMARY KEY,
  `name` varchar(255),
  `email` varchar(255),
  `join_date` date,
  `membership_type` varchar(255)
);

CREATE TABLE `Borrow_Records` (
  `record_id` int PRIMARY KEY,
  `book_id` int,
  `member_id` int,
  `borrow_date` date,
  `due_date` date,
  `return_date` date
);

ALTER TABLE `Books` ADD FOREIGN KEY (`author_id`) REFERENCES `Authors` (`author_id`);

ALTER TABLE `Borrow_Records` ADD FOREIGN KEY (`book_id`) REFERENCES `Books` (`book_id`);

ALTER TABLE `Borrow_Records` ADD FOREIGN KEY (`member_id`) REFERENCES `Members` (`member_id`);
