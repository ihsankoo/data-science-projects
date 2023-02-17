-- CREATE DATABASE ASSIGNMENT2;

CREATE TABLE Actions (
    Visitor_ID INT NOT NULL PRIMARY KEY,
    Adv_Type VARCHAR(1) NOT NULL,
    ACTION VARCHAR(20) NOT NULL,
);

INSERT INTO Actions
VALUES (1, 'A', 'Left'),
       (2, 'A', 'Order'),
       (3, 'B', 'Left'),
       (4, 'A', 'Order'),
       (5, 'A', 'Review'),
       (6, 'A', 'Left'),
       (7, 'B', 'Left'),
       (8, 'B', 'Order'),
       (9, 'B', 'Review'),
       (10, 'A', 'Review');

