Drop table Campuses;
Drop table Equipment;
Drop table Users;
Drop table Tickets;
Drop table Software;
---- TABLE Campuses -----
CREATE TABLE Campuses (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  ville VARCHAR(255),
  region VARCHAR(255),
  codepostal VARCHAR(255)
);
---- TABLE Equipment -----
CREATE TABLE Equipment (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  serial_number VARCHAR(255),
  purchase_date DATE,
  purchase_cost DECIMAL(10,2),
  warranty_expiry_date DATE,
  campus_id INT,
  FOREIGN KEY (campus_id) REFERENCES Campuses(id)
);


---- TABLE Users -----
CREATE TABLE Users (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
    campus_id INT,
    FOREIGN KEY (campus_id) REFERENCES Campuses(id)
);

---- TABLE TICKETS -----
CREATE TABLE Tickets (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  description VARCHAR(255),
  status VARCHAR(255),
  priority VARCHAR(255),
  user_id INT,
  campus_id INT,
  FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (campus_id) REFERENCES Campuses(id)
);

---- TABLE Software -----
CREATE TABLE Software (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  version VARCHAR(255),
  licence_number VARCHAR(255),
  licence_expiry_date DATE,
  campus_id INT,
  FOREIGN KEY (campus_id) REFERENCES Campuses(id)
);

---- Procedure that insert an equipment in the database -----
CREATE PROCEDURE insertEquipment(
  IN name VARCHAR(255),
  IN serial_number VARCHAR(255),
  IN purchase_date DATE,
  IN purchase_cost DECIMAL(10,2),
  IN warranty_expiry_date DATE,
  IN campus_id INT
)
BEGIN
  INSERT INTO Equipment (name, serial_number, purchase_date, purchase_cost, warranty_expiry_date, campus_id)
  VALUES (name, serial_number, purchase_date, purchase_cost, warranty_expiry_date, campus_id);
END;
---- Procedure that insert a campus in the database -----
CREATE PROCEDURE insertCampus(
  IN name VARCHAR(255),
  IN address VARCHAR(255),
  IN ville VARCHAR(255),
  IN region VARCHAR(255),
  IN codepostal VARCHAR(255)
)
BEGIN
  INSERT INTO Campuses (name, address, ville, region, codepostal)
  VALUES (name, address, ville, region, codepostal);
END;
----- Procedure that insert a user in the database and check if the user already exist  THROW an exception -----
CREATE PROCEDURE insertUser(
  IN name VARCHAR(255),
  IN email VARCHAR(255),
  IN password VARCHAR(255),
  IN campus_id INT
)
BEGIN
  DECLARE user_id INT;
  SELECT id INTO user_id FROM Users WHERE name = name AND email = email AND password = password AND campus_id = campus_id;
  IF user_id IS NULL THEN
    INSERT INTO Users (name, email, password, campus_id)
    VALUES (name, email, password, campus_id);
  ELSE
    ------ EXCEPTION A COMPLETE 'User already in the database';
  END IF;
END;
----- Procedure that insert a ticket in the database and check if the ticket is already in the database throw an exception -----
CREATE PROCEDURE insertTicket(
  IN title VARCHAR(255),
  IN description VARCHAR(255),
  IN status VARCHAR(255),
  IN priority VARCHAR(255),
  IN user_id INT,
  IN campus_id INT
)
BEGIN
  DECLARE ticket_id INT;
  SELECT id INTO ticket_id FROM Tickets WHERE title = title AND description = description AND status = status AND priority = priority AND user_id = user_id AND campus_id = campus_id;
  IF ticket_id IS NULL THEN
    INSERT INTO Tickets (title, description, status, priority, user_id, campus_id)
    VALUES (title, description, status, priority, user_id, campus_id);
  ELSE
    ------ EXCEPTION A COMPLETE 'Ticket already in the database';
  END IF;
END;
---- Procedure that insert a software in the database -----	
CREATE PROCEDURE insertSoftware(
  IN name VARCHAR(255),
  IN version VARCHAR(255),
  IN licence_number VARCHAR(255),
  IN licence_expiry_date DATE,
  IN campus_id INT
)
BEGIN
  INSERT INTO Software (name, version, licence_number, licence_expiry_date, campus_id)
  VALUES (name, version, licence_number, licence_expiry_date, campus_id);
END;
----- Procedure that update an equipment in the database -----
CREATE PROCEDURE updateEquipment(
  IN id INT,
  IN name VARCHAR(255),
  IN serial_number VARCHAR(255),
  IN purchase_date DATE,
  IN purchase_cost DECIMAL(10,2),
  IN warranty_expiry_date DATE,
  IN campus_id INT
)
BEGIN
  UPDATE Equipment SET name = name, serial_number = serial_number, purchase_date = purchase_date, purchase_cost = purchase_cost, warranty_expiry_date = warranty_expiry_date, campus_id = campus_id WHERE id = id;
END;
----- Procedure that update a campus in the database -----
CREATE PROCEDURE updateCampus(
  IN id INT,
  IN name VARCHAR(255),
  IN address VARCHAR(255),
  IN ville VARCHAR(255),
  IN region VARCHAR(255),
  IN codepostal VARCHAR(255)
)
BEGIN
  UPDATE Campuses SET name = name, address = address, ville = ville, region = region, codepostal = codepostal WHERE id = id;
END;
----- Procedure that update a user in the database -----
CREATE PROCEDURE updateUser(
  IN id INT,
  IN name VARCHAR(255),
  IN email VARCHAR(255),
  IN password VARCHAR(255),
  IN campus_id INT
)
BEGIN
  UPDATE Users SET name = name, email = email, password = password, campus_id = campus_id WHERE id = id;
END;
----- Procedure that update a ticker status in the database -----
CREATE PROCEDURE updateTicketStatus(
  IN id INT,
  IN status VARCHAR(255)
)
BEGIN
  UPDATE Tickets SET status = status WHERE id = id;
END;
----- Procedure that update a ticket priority in the database -----
CREATE PROCEDURE updateTicketPriority(
  IN id INT,
  IN priority VARCHAR(255)
)
BEGIN
  UPDATE Tickets SET priority = priority WHERE id = id;
END;
----- Procedure that update a software in the database -----
CREATE PROCEDURE updateSoftware(
  IN id INT,
  IN name VARCHAR(255),
  IN version VARCHAR(255),
  IN licence_number VARCHAR(255),
  IN licence_expiry_date DATE,
  IN campus_id INT
)
BEGIN
  UPDATE Software SET name = name, version = version, licence_number = licence_number, licence_expiry_date = licence_expiry_date, campus_id = campus_id WHERE id = id;
END;
----- Procedure that delete an equipment before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteEquipment(
  IN id INT
)
------  A COMPLETE

----- Procedure that delete a campus before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteCampus(
  IN id INT
)
BEGIN
  DECLARE campus_id INT;
  SELECT id INTO campus_id FROM Campuses WHERE id = id;
  IF campus_id IS NULL THEN
    ------ EXCEPTION A COMPLETE 'Campus does not exist';
  ELSE
    DELETE FROM Campuses WHERE id = id;
  END IF;
END;
----- Procedure that delete a user before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteUser(
  IN id INT
)
BEGIN
  DECLARE user_id INT;
  SELECT id INTO user_id FROM Users WHERE id = id;
  IF user_id IS NULL THEN
    ---- EXCEPTION A COMPLETE 'User does not exist';
  ELSE
    DELETE FROM Users WHERE id = id;
  END IF;
END;
----- Procedure that delete a ticket before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteTicket(
  IN id INT
)
BEGIN
  DECLARE ticket_id INT;
  SELECT id INTO ticket_id FROM Tickets WHERE id = id;
  IF ticket_id IS NULL THEN
    ------ EXCEPTION A COMPLETE 'Ticket does not exist';
  ELSE
    DELETE FROM Tickets WHERE id = id;
  END IF;
END;
----- Procedure that delete a software before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteSoftware(
  IN id INT
)



------ admin role that have all the privileges on the tables and procedures in the database ------
CREATE ROLE admin;
GRANT ALL PRIVILEGES ON Equipment TO admin;

---- Create supportIT 

---- Etudient role have read only access to Tickets and Users tables ------
CREATE ROLE Etudient;
GRANT SELECT ON Tickets TO Etudient;
GRANT SELECT ON Users TO Etudient;

----  view that show all the tickets and the name of the user that created the ticket ------
CREATE VIEW TicketsUsers AS
SELECT Tickets.id, Tickets.title, Tickets.description, Tickets.status, Tickets.priority, Users.name
FROM Tickets
INNER JOIN Users ON Tickets.user_id = Users.id;

----- view that show all the tickets and the name of the campus where the ticket was created ------
CREATE VIEW TicketsCampuses AS
SELECT Tickets.id, Tickets.title, Tickets.description, Tickets.status, Tickets.priority, Campuses.name
FROM Tickets
INNER JOIN Campuses ON Tickets.campus_id = Campuses.id;
-----  view that show all equipments and the name of the campus where the equipment is located ------
CREATE VIEW EquipmentCampuses AS
SELECT Equipment.id, Equipment.name, Equipment.serial_number, Equipment.purchase_date, Equipment.purchase_cost, Equipment.warranty_expiry_date, Campuses.name
FROM Equipment
INNER JOIN Campuses ON Equipment.campus_id = Campuses.id;
----- view that show all softw are and the name of the campus where the software is located sorted by the campus name ------
CREATE VIEW SoftwareCampuses AS
SELECT Software.id, Software.name, Software.version, Software.licence_number, Software.licence_expiry_date, Campuses.name
FROM Software
INNER JOIN Campuses ON Software.campus_id = Campuses.id
ORDER BY Campuses.name;
----- Trigger that on deleting a ticket check the ticket status if the status is not closed throw an exception ------
CREATE TRIGGER checkTicketStatus BEFORE DELETE ON Tickets
FOR EACH ROW
BEGIN
  IF OLD.status != 'Closed' THEN
    ------ EXCEPTION A COMPLETE 'Ticket status is not closed';
  END IF;
END;
----- Trigger that on creating a ticket check for the user campus if the campus is not the same as the ticket campus throw an exception ------
CREATE TRIGGER checkTicketCampus BEFORE INSERT ON Tickets
FOR EACH ROW
BEGIN
  DECLARE user_campus_id INT;
  DECLARE ticket_campus_id INT;
  SELECT campus_id INTO user_campus_id FROM Users WHERE id = NEW.user_id;
  SELECT campus_id INTO ticket_campus_id FROM Tickets WHERE id = NEW.id;
  IF user_campus_id != ticket_campus_id THEN
    ------ EXCEPTION A COMPLETE 'User campus is not the same as the ticket campus';
  END IF;
END;
----- function that return the number of tickets created by a user ------
CREATE FUNCTION getNumberOfTicketsByUser(
  IN user_id INT
)
RETURNS INT
BEGIN
  DECLARE numberOfTickets INT;
  SELECT COUNT(*) INTO numberOfTickets FROM Tickets WHERE user_id = user_id;
  RETURN numberOfTickets;
END;
----- function that return the number of tickets created by a user in a specific campus ------
CREATE FUNCTION getNumberOfTicketsByUserAndCampus(
  IN user_id INT,
  IN campus_id INT
)
RETURNS INT
BEGIN
  DECLARE numberOfTickets INT;
  SELECT COUNT(*) INTO numberOfTickets FROM Tickets WHERE user_id = user_id AND campus_id = campus_id;
  RETURN numberOfTickets;
END;
-----  function that return the average purchase cost of all equipments in a campus ------	
CREATE FUNCTION getAveragePurchaseCostByCampus(
  IN campus_id INT
)
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE averagePurchaseCost DECIMAL(10,2);
  SELECT AVG(purchase_cost) INTO averagePurchaseCost FROM Equipment WHERE campus_id = campus_id;
  RETURN averagePurchaseCost;
END;

-----  Distributed database that store data for each campus in a different server ------
CREATE DATABASE IF NOT EXISTS Campus1;
CREATE DATABASE IF NOT EXISTS Campus2;

-----  query plan that shows the number of tickets in each campus ------
EXPLAIN SELECT COUNT(*), Campuses.name FROM Tickets INNER JOIN Campuses ON Tickets.campus_id = Campuses.id GROUP BY Tickets.campus_id;


