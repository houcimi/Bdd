 DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Campuses;
DROP TABLE IF EXISTS Software;
DROP TABLE IF EXISTS Equipment;
DROP SEQUENCE IF EXISTS equipId;
DROP SEQUENCE IF EXISTS campusId;
DROP SEQUENCE IF EXISTS userId;
DROP SEQUENCE IF EXISTS TicketId;
DROP SEQUENCE IF EXISTS softId;


---- TABLE Campuses -----
CREATE TABLE Campuses (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  ville VARCHAR(255),
  region VARCHAR(255),
  codepostal VARCHAR(255)
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
--------  Function return  
CREATE OR REPLACE FUNCTION check_record_exists(p_id IN NUMBER, p_table_name IN VARCHAR2)
RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  -- perform the count query
  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table_name || ' WHERE id = :1' INTO v_count USING p_id;
  
  -- if count is 0, return 0, otherwise return 1
  IF v_count = 0 THEN
    RETURN 0;
  ELSE
    RETURN 1;
  END IF;
EXCEPTION
  -- handle any errors that may occur
  WHEN OTHERS THEN
    RETURN 0;
END;
---- Procedure that insert an equipment in the database -----
CREATE SEQUENCE equipId START WITH 1 INCREMENT BY 1 ;
CREATE OR REPLACE PROCEDURE insertEquipment(
  pname IN  VARCHAR,
  pserial_number IN  VARCHAR,
  ppurchase_date IN  DATE,
  ppurchase_cost IN  DECIMAL(10,2),
  pwarranty_expiry_date IN  DATE,
  pcampus_id IN  INT
)
IS
idEquip NUMBER;
BEGIN
  SELECT equipId.NEXTVAL INTO idEquip FROM dual;
  INSERT INTO Equipment (id,name, serial_number, purchase_date, purchase_cost, warranty_expiry_date, campus_id)
  VALUES (idEquip,pname, pserial_number, ppurchase_date, ppurchase_cost, pwarranty_expiry_date, pcampus_id);
END;
---- Procedure that insert a campus in the database -----
CREATE SEQUENCE campusId START WITH 1 INCREMENT BY 1 ;
CREATE OR REPLACE PROCEDURE insertCampus(
pname IN VARCHAR,
address IN VARCHAR,
ville IN VARCHAR,
region IN VARCHAR,
codepostal IN VARCHAR
)
IS
  name_exists NUMBER;
  idCampus NUMBER;
BEGIN
    SELECT campusId.NEXTVAL INTO idCampus FROM dual;
 SELECT COUNT(*) INTO name_exists FROM Campuses WHERE name = pname;
 IF name_exists > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'A site Avec le meme nom Deja exists.');
ELSE
INSERT INTO Campuses (id,name, address, ville, region, codepostal)
VALUES (idCampus,pname, address, ville, region, codepostal);
  END IF;

END;
----- Procedure that insert a user in the database and check if the user already exist  THROW an exception -----
CREATE SEQUENCE userId START WITH 1 INCREMENT BY 1 ;
CREATE PROCEDURE insertUser(
  pname IN  VARCHAR(255),
  email IN  VARCHAR(255),
  password IN  VARCHAR(255),
  campus_id IN  INT
)
IS
user_id INT;
idUser NUMBER;
BEGIN
 SELECT userId.NEXTVAL INTO idUser FROM dual;
  SELECT id INTO user_id FROM Users WHERE name = pname AND email = email AND campus_id = campus_id;
  IF user_id IS NULL THEN
    INSERT INTO Users (id,name, email, password, campus_id)
    VALUES (idUser,pname, email, password, campus_id);
  ELSE
    RAISE_APPLICATION_ERROR(-20002, 'ce utilisateur deja exist Deja exists.');
  END IF;
END;
----- Procedure that insert a ticket in the database and check if the ticket is already in the database throw an exception -----
CREATE SEQUENCE TicketId START WITH 1 INCREMENT BY 1 ;
CREATE PROCEDURE insertTicket(
  ptitle IN  VARCHAR,
  pdescription IN  VARCHAR,
  pstatus IN  VARCHAR,
  priorityp IN  VARCHAR,
  puser_id IN  INT,
  pcampus_id IN  INT
)
IS
ticket_id INT;
idTicket NUMBER;
BEGIN
  SELECT TicketId.NEXTVAL INTO idTicket FROM dual;
    INSERT INTO Tickets (id,title, description, status, priority, user_id, campus_id)
    VALUES (idTicket,ptitle, pdescription, pstatus, priorityp, puser_id, pcampus_id);
END;
---- Procedure that insert a software in the database -----	
CREATE SEQUENCE softId START WITH 1 INCREMENT BY 1 ;

CREATE PROCEDURE insertSoftware(
  pname IN  VARCHAR,
  pversion IN  VARCHAR,
  plicence_number IN  VARCHAR,
  plicence_expiry_date IN  DATE,
  pcampus_id IN  INT
)
IS
idSoftware NUMBER;
BEGIN
  SELECT softId.NEXTVAL INTO idSoftware FROM dual;
  INSERT INTO Software (id,name, version, licence_number, licence_expiry_date, campus_id)
  VALUES (idSoftware,pname, pversion, plicence_number, plicence_expiry_date, pcampus_id);
END;
----- Procedure that update an equipment in the database -----
CREATE PROCEDURE updateEquipment(
  pid IN  INT,
  pname IN  VARCHAR,
  pserial_number IN  VARCHAR,
  ppurchase_date IN  DATE,
  ppurchase_cost IN  DECIMAL(10,2),
  pwarranty_expiry_date IN  DATE,
  pcampus_id IN  INT
)
IS
equipment_count INT;
BEGIN
  SELECT COUNT(*) INTO equipment_count FROM Equipment WHERE id = pid;
  IF equipment_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Équipement inexistant.');
  END IF;
  UPDATE Equipment SET name = pname, serial_number = pserial_number, purchase_date = ppurchase_date, purchase_cost = ppurchase_cost, warranty_expiry_date = pwarranty_expiry_date, campus_id = pcampus_id WHERE id = pid;
END;
----- Procedure that update a campus in the database -----
CREATE PROCEDURE updateCampus(
 pid IN INT,
  pname IN VARCHAR,
  address IN VARCHAR,
  ville IN VARCHAR,
  region IN VARCHAR,
  codepostal IN VARCHAR
)
IS
campus_count INT;
BEGIN
  SELECT COUNT(*) INTO campus_count FROM Campuses WHERE id = pid;
  IF campus_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Campus inexistant.');
  END IF;
  UPDATE Campuses SET name = pname, address = address, ville = ville, region = region, codepostal = codepostal WHERE id = pid;
END;
----- Procedure that update a user in the database -----
CREATE PROCEDURE updateUser(
  pid IN INT,
  pname IN VARCHAR,
  email IN VARCHAR,
  ppassword IN VARCHAR,
  pcampus_id IN INT
)
IS
user_count INT;
BEGIN
  SELECT COUNT(*) INTO user_count FROM Users WHERE id = pid;
  IF user_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20005, 'Utilisateur inexistant.');
  END IF;
  UPDATE Users SET name = pname, email = email, password = ppassword, campus_id = pcampus_id WHERE id = pid;
END;
---- function that check if the ticket exist or not if not return 0 else return 1 -----
CREATE OR REPLACE FUNCTION checkTicketExist(
  pid IN INT
)
RETURN INT
IS
ticket_count INT;
BEGIN
  SELECT COUNT(*) INTO ticket_count FROM Tickets WHERE id = pid;
  IF ticket_count = 0 THEN
    RETURN 0;
  ELSE
    RETURN 1;
  END IF;
END;
----- Procedure that update a ticker status in the database -----
CREATE PROCEDURE updateTicketStatus(
 
 pid IN INT,
  pstatus IN VARCHAR
)
IS
ticketExist INT;
BEGIN
  SELECT checkTicketExist(pid) INTO ticketExist FROM dual;
  IF ticketExist = 0 THEN
    RAISE_APPLICATION_ERROR(-20006, 'Ticket inexistant.');
  END IF;
  UPDATE Tickets SET status = pstatus WHERE id = Pid;
END;

----- Procedure that update a ticket priority in the database -----
CREATE PROCEDURE updateTicketPriority(
  pid IN INT,
  ppriority IN VARCHAR
)
IS
ticketExist INT;
BEGIN
  SELECT checkTicketExist(pid) INTO ticketExist FROM dual;
  IF ticketExist = 0 THEN
    RAISE_APPLICATION_ERROR(-20007, 'Ticket inexistant.');
  END IF;
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
  pid IN INT
)
IS
equipment_count INT;
BEGIN
  SELECT COUNT(*) INTO equipment_count FROM Equipment WHERE id = pid;
  IF equipment_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20008, 'Équipement inexistant.');
  END IF;
  DELETE FROM Equipment WHERE id = pid;
END;


----- Procedure that delete a campus before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteCampus(
 pid IN INT
)
IS
campus_count INT;
BEGIN
  SELECT COUNT(*) INTO campus_count FROM Campuses WHERE id = pid;
  IF campus_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20009, 'Campus inexistant.');
  END IF;
  DELETE FROM Campuses WHERE id = pid;
END;
----- Procedure that delete a user before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteUser(
  pid IN INT
)
IS
user_count INT;
BEGIN
  SELECT COUNT(*) INTO user_count FROM Users WHERE id = pid;
  IF user_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20010, 'Utilisateur inexistant.');
  END IF;
  DELETE FROM Users WHERE id = pid;
END;
----- Procedure that delete a ticket before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteTicket(
  pid IN INT
)
IS
ticket_count INT;
BEGIN
  SELECT COUNT(*) INTO ticket_count FROM Tickets WHERE id = pid;
  IF ticket_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20011, 'Ticket inexistant.');
  END IF;
  DELETE FROM Tickets WHERE id = pid;
END;
----- Procedure that delete a software before deleting check if exist or not if not throw exception -----
CREATE PROCEDURE deleteSoftware(
  pid IN INT
)
IS
software_count INT;
BEGIN
  SELECT COUNT(*) INTO software_count FROM Software WHERE id = pid;
  IF software_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20012, 'Logiciel inexistant.');
  END IF;
  DELETE FROM Software WHERE id = pid;
END;


------ admin role that have all the privileges on the tables and procedures in the database ------
CREATE ROLE admin;
GRANT ALL PRIVILEGES ON Equipment TO admin;

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
     raise_application_error(-20114,' LE STATUS DU Ticket status is pas closed');
  END IF;
END;
----- Trigger that on creating a ticket check for the user campus if the campus is not the same as the ticket campus throw an exception ------

CREATE OR REPLACE TRIGGER checkTicketCampus
BEFORE INSERT ON Tickets
FOR EACH ROW
DECLARE 
  user_campus_id Users.campus_id%TYPE;
  ticket_campus_id Tickets.campus_id%TYPE;
BEGIN
  SELECT campus_id INTO user_campus_id FROM Users WHERE id = :NEW.user_id;
  SELECT campus_id INTO ticket_campus_id FROM Tickets WHERE id = :NEW.id;
  IF user_campus_id != ticket_campus_id THEN
    raise_application_error(-20115, 'le campus de lutilisateur est different du campus du ticket');
  END IF;
END;
----- function that return the number of tickets created by a user ------
CREATE OR REPLACE FUNCTION getNumberOfTicketsByUser(
  user_id IN INT
)
RETURN INT IS
  numberOfTickets INT;
BEGIN
  SELECT COUNT(*) INTO numberOfTickets FROM Tickets WHERE user_id = user_id;
  RETURN numberOfTickets;
END;
----- function that return the number of tickets created by a user in a specific campus ------
CREATE OR REPLACE FUNCTION getNumberOfTicketsByUserAndCampus(
  user_id IN INT,
  campus_id IN INT
)
RETURN INT IS
  numberOfTickets INT;
BEGIN
  SELECT COUNT(*) INTO numberOfTickets FROM Tickets WHERE user_id = user_id AND campus_id = campus_id;
  RETURN numberOfTickets;
END;
-----  function that return the average purchase cost of all equipments in a campus ------	
CREATE OR REPLACE FUNCTION getAveragePurchaseCostByCampus(
  campus_id IN INT
)
RETURN DECIMAL(10,2) IS
  averagePurchaseCost DECIMAL(10,2);
BEGIN
  SELECT AVG(purchase_cost) INTO averagePurchaseCost FROM Equipment WHERE campus_id = campus_id;
  RETURN averagePurchaseCost;
END;

-----  Distributed database that store data for each campus in a different server ------

-----  query plan that shows the number of tickets in each campus ------
EXPLAIN SELECT COUNT(*), Campuses.name FROM Tickets INNER JOIN Campuses ON Tickets.campus_id = Campuses.id GROUP BY Tickets.campus_id;


