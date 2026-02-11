-- Authors  

INSERT INTO authors (id, name, birth_date) VALUES (1, 'Miguel de Cervantes', '1547-09-29');  

INSERT INTO authors (id, name, birth_date) VALUES (2, 'Lewis Carroll', '1832-01-27');  

INSERT INTO authors (id, name, birth_date) VALUES (3, 'Mark Twain', '1835-11-30');  

INSERT INTO authors (id, name, birth_date) VALUES (4, 'Robert Louis Stevenson', '1850-11-13');  

INSERT INTO authors (id, name, birth_date) VALUES (5, 'Jane Austen', '1775-12-16');  

INSERT INTO authors (id, name, birth_date) VALUES (6, 'Emily Brontë', '1818-07-30');  

INSERT INTO authors (id, name, birth_date) VALUES (7, 'Charlotte Brontë', '1816-04-21');  

INSERT INTO authors (id, name, birth_date) VALUES (8, 'Herman Melville', '1819-08-01');  

INSERT INTO authors (id, name, birth_date) VALUES (9, 'Nathaniel Hawthorne', '1804-07-04');  

INSERT INTO authors (id, name, birth_date) VALUES (10, 'Jonathan Swift', '1667-11-30');  

INSERT INTO authors (id, name, birth_date) VALUES (11, 'John Bunyan', '1628-11-30');  

INSERT INTO authors (id, name, birth_date) VALUES (12, 'Charles Dickens', '1812-02-07');  

INSERT INTO authors (id, name, birth_date) VALUES (13, 'Louisa May Alcott', '1832-11-29');  

INSERT INTO authors (id, name, birth_date) VALUES (14, 'J.R.R. Tolkien', '1892-01-03');  

INSERT INTO authors (id, name, birth_date) VALUES (15, 'Mary Shelley', '1797-08-30');  



-- Books  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780142437230', 'Don Quixote', '1605-01-16');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780486275437', 'Alice''s Adventures in Wonderland', '1865-11-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780486280615', 'The Adventures of Huckleberry Finn', '1884-12-10');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780590408004', 'The Adventures of Tom Sawyer', '1876-06-09');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780486275598', 'Treasure Island', '1883-01-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781503290563', 'Pride and Prejudice', '1813-01-28');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781847490025', 'Wuthering Heights', '1847-12-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780140620115', 'Jane Eyre', '1847-10-19');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781503280780', 'Moby Dick', '1851-10-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780486280486', 'The Scarlet Letter', '1850-03-16');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781508474333', 'Gulliver''s Travels', '1726-10-28');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780802456540', 'The Pilgrim''s Progress', '1678-02-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780143122494', 'A Christmas Carol', '1843-12-19');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780140434941', 'David Copperfield', '1850-05-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781503219700', 'A Tale of Two Cities', '1859-04-30');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781503280298', 'Little Women', '1868-09-30');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9781503275183', 'Great Expectations', '1861-08-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780007458424', 'The Hobbit, or, There and Back Again', '1937-09-21');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780140433623', 'Frankenstein, or, the Modern Prometheus', '1818-01-01');  

INSERT INTO books (isbn, title, pub_date) VALUES ('9780812580036', 'Oliver Twist', '1838-11-09');  



-- Book Authors  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780142437230', 1);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780486275437', 2);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780486280615', 3);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780590408004', 3);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780486275598', 4);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781503290563', 5);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781847490025', 6);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780140620115', 7);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781503280780', 8);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780486280486', 9);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781508474333', 10);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780802456540', 11);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780143122494', 12);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780140434941', 12);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781503219700', 12);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781503280298', 13);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9781503275183', 12);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780007458424', 14);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780140433623', 15);  

INSERT INTO book_authors (isbn, author_id) VALUES ('9780812580036', 12);  



-- Copies  

INSERT INTO copies (isbn, copy_num) VALUES ('9780142437230', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780142437230', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275437', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275437', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275437', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275437', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275437', 5);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486280615', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486280615', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486280615', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486280615', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780590408004', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780590408004', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780590408004', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275598', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275598', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275598', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275598', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486275598', 5);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503290563', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503290563', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503290563', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503290563', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781847490025', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781847490025', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140620115', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140620115', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140620115', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140620115', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140620115', 5);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280780', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280780', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280780', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280780', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780486280486', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781508474333', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781508474333', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780802456540', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780802456540', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780802456540', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780802456540', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780802456540', 5);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780143122494', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140434941', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503219700', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503219700', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503219700', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503219700', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503219700', 5);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280298', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280298', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280298', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503280298', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503275183', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503275183', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503275183', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9781503275183', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780007458424', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780007458424', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780007458424', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780007458424', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780007458424', 5);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140433623', 1);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140433623', 2);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140433623', 3);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780140433623', 4);  

INSERT INTO copies (isbn, copy_num) VALUES ('9780812580036', 1);  



-- Patrons  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (1, 'John Doe', '123 Main St, Anytown, USA', 7.82);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (2, 'Jane Smith', '456 Elm St, Anytown, USA', 1.96);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (3, 'Alice Johnson', '789 Oak St, Anytown, USA', 6.44);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (4, 'Bob Brown', '101 Pine St, Anytown, USA', 7.47);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (5, 'Charlie Davis', '202 Maple St, Anytown, USA', 8.14);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (6, 'Diana Evans', '303 Birch St, Anytown, USA', 2.57);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (7, 'Eve Foster', '404 Cedar St, Anytown, USA', 2.12);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (8, 'Frank Green', '505 Walnut St, Anytown, USA', 3.3);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (9, 'Grace Harris', '606 Chestnut St, Anytown, USA', 5.51);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (10, 'Henry Irving', '707 Ash St, Anytown, USA', 0.42);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (11, 'Ivy Jackson', '808 Beech St, Anytown, USA', 5.29);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (12, 'Jack Kelly', '909 Cherry St, Anytown, USA', 4.86);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (13, 'Kara Lee', '1010 Dogwood St, Anytown, USA', 4.73);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (14, 'Leo Martin', '1111 Elmwood St, Anytown, USA', 2.42);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (15, 'Mia Nelson', '1212 Fir St, Anytown, USA', 0.87);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (16, 'Noah Oliver', '1313 Grove St, Anytown, USA', 2.1);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (17, 'Olivia Parker', '1414 Hickory St, Anytown, USA', 3.52);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (18, 'Paul Quinn', '1515 Ivy St, Anytown, USA', 3.09);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (19, 'Quinn Riley', '1616 Juniper St, Anytown, USA', 4.74);  

INSERT INTO patrons (card_number, name, address, fine_balance) VALUES (20, 'Riley Scott', '1717 Koa St, Anytown, USA', 1.34);  



-- Lendings  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (15, '9780486280615', 4, '2026-02-04');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (18, '9780486275598', 4, '2026-02-08');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (17, '9780486275598', 3, '2026-02-02');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (1, '9780143122494', 1, '2026-02-07');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (9, '9781847490025', 1, '2026-02-02');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (10, '9781847490025', 1, '2026-02-19');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (17, '9780486275598', 5, '2026-02-01');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (7, '9780486275598', 1, '2026-02-23');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (9, '9780486280615', 1, '2026-01-30');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (4, '9781503275183', 4, '2026-02-08');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (4, '9781503280780', 3, '2026-01-30');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (6, '9780007458424', 2, '2026-02-15');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (17, '9780486275437', 4, '2026-01-29');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (4, '9780140433623', 1, '2026-02-17');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (20, '9780143122494', 1, '2026-02-01');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (9, '9781503280780', 4, '2026-02-10');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (13, '9780143122494', 1, '2026-02-09');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (14, '9781503219700', 5, '2026-02-25');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (20, '9780486280486', 1, '2026-02-07');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (1, '9780486275437', 1, '2026-02-11');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (2, '9780812580036', 1, '2026-02-17');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (2, '9781503280298', 4, '2026-02-04');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (16, '9780140620115', 1, '2026-02-18');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (18, '9780486275437', 1, '2026-01-30');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (19, '9781503275183', 2, '2026-02-11');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (1, '9780486280615', 3, '2026-02-22');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (5, '9780802456540', 1, '2026-02-01');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (19, '9780486275598', 3, '2026-02-02');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (1, '9780486280486', 1, '2026-01-30');  

INSERT INTO lendings (card_number, isbn, copy_num, due_date) VALUES (13, '9780142437230', 1, '2026-02-12');
