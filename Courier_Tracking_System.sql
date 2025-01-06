--USERS TABLE-----------------------------------------------------------------------------------------
CREATE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('Admin', 'User')) NOT NULL
);
INSERT INTO Users VALUES (1, 'admin1', 'adminpass', 'Admin');
INSERT INTO Users VALUES (2, 'user1', 'userpass', 'User');
INSERT INTO Users VALUES (3, 'user2', 'userpass', 'User');
INSERT INTO Users VALUES (4, 'admin2', 'adminpass', 'Admin');
INSERT INTO Users VALUES (5, 'user3', 'userpass', 'User');

---Customers Table--------------------------------------------------------------------------------------------
CREATE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(50)
);
INSERT INTO Customers VALUES (1, 'John Doe', '123 Street, NY', '1234567890', 'john@example.com');
INSERT INTO Customers VALUES (2, 'Alice Brown', '456 Road, LA', '2345678901', 'alice@example.com');
INSERT INTO Customers VALUES (3, 'Bob Smith', '789 Lane, SF', '3456789012', 'bob@example.com');
INSERT INTO Customers VALUES (4, 'Charlie Puth', '567 Blvd, TX', '4567890123', 'charlie@example.com');
INSERT INTO Customers VALUES (5, 'Diana Prince', '890 Ave, WA', '5678901234', 'diana@example.com');

----Couriers Table--------------------------------------------------------------------------
CREATE TABLE Couriers (
    courier_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    origin VARCHAR(50),
    destination VARCHAR(50),
    shipment_date DATE,
    delivery_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Couriers VALUES (1, 1, 'NY', 'LA', SYSDATE, NULL, 'In Transit');
INSERT INTO Couriers VALUES (2, 2, 'LA', 'SF', SYSDATE, NULL, 'Out for Delivery');
INSERT INTO Couriers VALUES (3, 3, 'TX', 'NY', SYSDATE, NULL, 'Delivered');
INSERT INTO Couriers VALUES (4, 4, 'SF', 'TX', SYSDATE, NULL, 'Pending');
INSERT INTO Couriers VALUES (5, 5, 'WA', 'LA', SYSDATE, NULL, 'In Transit');

--Tracking Table---------------------------------------------------------------
CREATE TABLE Tracking (
    tracking_id NUMBER PRIMARY KEY,
    courier_id NUMBER,
    location VARCHAR(50),
    status_update VARCHAR(50),
    timestamp DATE,
    FOREIGN KEY (courier_id) REFERENCES Couriers(courier_id)
);

INSERT INTO Tracking VALUES (1, 1, 'NY Hub', 'Dispatched', SYSDATE);
INSERT INTO Tracking VALUES (2, 1, 'LA Hub', 'In Transit', SYSDATE);
INSERT INTO Tracking VALUES (3, 2, 'LA Center', 'Out for Delivery', SYSDATE);
INSERT INTO Tracking VALUES (4, 3, 'TX Hub', 'Delivered', SYSDATE);
INSERT INTO Tracking VALUES (5, 4, 'SF Warehouse', 'Pending', SYSDATE);

--- Delivery_Boy Table--------------------------------------------------------------------------
CREATE TABLE Delivery_Boy (
    delivery_boy_id NUMBER PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50),
    assigned_courier_id NUMBER,
    status VARCHAR(20),
    rating NUMBER(2,1),
    FOREIGN KEY (assigned_courier_id) REFERENCES Couriers(courier_id)
);

INSERT INTO Delivery_Boy VALUES (1, 'Mike Ross', '5678901234', 'mike@example.com', 1, 'Busy', 4.5);
INSERT INTO Delivery_Boy VALUES (2, 'Rachel Zane', '6789012345', 'rachel@example.com', 2, 'Busy', 4.7);
INSERT INTO Delivery_Boy VALUES (3, 'Harvey Specter', '7890123456', 'harvey@example.com', NULL, 'Available', 5.0);
INSERT INTO Delivery_Boy VALUES (4, 'Louis Litt', '8901234567', 'louis@example.com', 3, 'Busy', 4.0);
INSERT INTO Delivery_Boy VALUES (5, 'Donna Paulsen', '9012345678', 'donna@example.com', NULL, 'Available', 4.8);

-- Payments Table-------------------------------
CREATE TABLE Payments (
    payment_id NUMBER PRIMARY KEY,
    courier_id NUMBER,
    amount NUMBER(10,2),
    payment_date DATE,
    payment_status VARCHAR(20),
    payment_mode VARCHAR(30),
    FOREIGN KEY (courier_id) REFERENCES Couriers(courier_id)
);
INSERT INTO Payments VALUES (1, 1, 50.00, SYSDATE, 'Paid', 'Online');
INSERT INTO Payments VALUES (2, 2, 75.00, SYSDATE, 'Pending', 'Cash');
INSERT INTO Payments VALUES (3, 3, 100.00, SYSDATE, 'Paid', 'Card');
INSERT INTO Payments VALUES (4, 4, 60.00, SYSDATE, 'Failed', 'Online');
INSERT INTO Payments VALUES (5, 5, 90.00, SYSDATE, 'Paid', 'Online');

--Feedback Table-----------------
CREATE TABLE Feedback (
    feedback_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    courier_id NUMBER,
    delivery_boy_id NUMBER,
    rating NUMBER(2,1),
    comments VARCHAR(255),
    feedback_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (courier_id) REFERENCES Couriers(courier_id),
    FOREIGN KEY (delivery_boy_id) REFERENCES Delivery_Boy(delivery_boy_id)
);
INSERT INTO Feedback VALUES (1, 1, 1, 1, 4.5, 'Great Service!', SYSDATE);
INSERT INTO Feedback VALUES (2, 2, 2, 2, 4.7, 'Quick Delivery!', SYSDATE);
INSERT INTO Feedback VALUES (3, 3, 3, 4, 4.0, 'Satisfied.', SYSDATE);

---Warehouse Table-----------------------------------------------------------------------------------
CREATE TABLE Warehouse (
    warehouse_id NUMBER PRIMARY KEY,
    location VARCHAR(50),
    manager_name VARCHAR(50),
    capacity NUMBER(5),
    current_load NUMBER(5),
    status VARCHAR(20)
);

INSERT INTO Warehouse VALUES (1, 'NY Hub', 'Tom Keller', 500, 300, 'Active');
INSERT INTO Warehouse VALUES (2, 'LA Hub', 'Sara Lane', 600, 450, 'Active');
-------------------------------------------------------------------------------------------------------------------------------
---Procedure 1: Assign Delivery Boy to Courier-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE AssignDeliveryBoy(
    p_delivery_boy_id IN NUMBER,
    p_courier_id IN NUMBER
) AS
    v_assigned_courier_id NUMBER;
    v_status VARCHAR2(50);
BEGIN
    -- Check if Delivery Boy is already assigned
    SELECT assigned_courier_id, status 
    INTO v_assigned_courier_id, v_status 
    FROM Delivery_Boy 
    WHERE delivery_boy_id = p_delivery_boy_id;

    IF v_status = 'Busy' AND v_assigned_courier_id IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Delivery Boy is already assigned to a courier!');
    END IF;

    -- Update Delivery_Boy table
    UPDATE Delivery_Boy 
    SET assigned_courier_id = p_courier_id, status = 'Busy'
    WHERE delivery_boy_id = p_delivery_boy_id;

    -- Update Couriers table
    UPDATE Couriers 
    SET status = 'Out for Delivery'
    WHERE courier_id = p_courier_id;

    DBMS_OUTPUT.PUT_LINE('Delivery Boy Assigned Successfully!');
END;
/

EXEC AssignDeliveryBoy(3, 4);

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedure 2: Update Courier Status-----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE UpdateCourierStatus(
    p_courier_id IN NUMBER,
    p_status IN VARCHAR
) AS
BEGIN
    UPDATE Couriers 
    SET status = p_status 
    WHERE courier_id = p_courier_id;

    DBMS_OUTPUT.PUT_LINE('Courier Status Updated Successfully!');
END;
/

EXEC UpdateCourierStatus(4, 'Delivered');

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Trigger 1: Auto-Update Tracking Table on Courier Status Change------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_CourierStatusUpdate
AFTER UPDATE ON Couriers
FOR EACH ROW
WHEN (OLD.status <> NEW.status)
BEGIN
    INSERT INTO Tracking (tracking_id, courier_id, location, status_update, timestamp)
    VALUES (
        Tracking_seq.NEXTVAL,
        :NEW.courier_id,
        'System Auto-Log',
        :NEW.status,
        SYSDATE
    );
    DBMS_OUTPUT.PUT_LINE('Tracking Record Added Automatically!');
END;
/

UPDATE Couriers SET status = 'In Transit' WHERE courier_id = 2;
--------------------------------------------------------------------------
CREATE SEQUENCE Tracking_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = 'TRACKING_SEQ';
-------------------------------------------------------------------------------------------------------------------------------------
--Trigger 2: Prevent Overbooking Delivery Boy-----------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_PreventDoubleAssign
BEFORE UPDATE ON Delivery_Boy
FOR EACH ROW
WHEN (NEW.status = 'Busy' AND OLD.assigned_courier_id IS NOT NULL)
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Delivery Boy is already assigned to a courier!');
END;
/
UPDATE Delivery_Boy SET assigned_courier_id = 5 WHERE delivery_boy_id = 1;
-----------------------------------------------------------------------------------------------------------------------------
-------- CRUD Operations---------------------------------------------------------------------------------------------------------
----1) Create (Insert Records)
-- Add a new courier
INSERT INTO Couriers (courier_id, customer_id, origin, destination, shipment_date, delivery_date, status)
VALUES (6, 2, 'NY', 'SF', SYSDATE, NULL, 'Pending');
SELECT * FROM Couriers WHERE courier_id = 6;

----2)Read (Fetch Records)
SELECT * FROM Couriers WHERE status = 'In Transit';
SELECT * FROM Delivery_Boy WHERE status = 'Busy';

----3)SELECT * FROM Couriers WHERE courier_id = 6;
UPDATE Couriers SET destination = 'TX' WHERE courier_id = 6;
SELECT * FROM Couriers WHERE courier_id = 6;

----4)Delete (Remove Records)
DELETE FROM Couriers WHERE courier_id = 6;
SELECT * FROM Couriers WHERE courier_id = 6;

-----------------------------------------------------------------------------------------------------------------------------------------------------
---Testing and Validation----------------------------------------------------------------------------------
--1.Add a New Courier:
INSERT INTO Couriers VALUES (7, 5, 'TX', 'LA', SYSDATE, NULL, 'Pending');

--2.Assign Delivery Boy to the Courier:
EXEC AssignDeliveryBoy(5, 7);

--3.Update Courier Status to 'Delivered':
EXEC UpdateCourierStatus(7, 'Delivered');

--4.Check Tracking Logs:
SELECT * FROM Tracking WHERE courier_id = 7;

--5.Validate Delivery Boy Status:
SELECT * FROM Delivery_Boy WHERE delivery_boy_id = 4;

--6.Payment for Courier
INSERT INTO Payments VALUES (6, 7, 85.00, SYSDATE, 'Paid', 'Online');

--7.Add Feedback:
INSERT INTO Feedback VALUES (4, 4, 7, 4, 4.8, 'Excellent Service!', SYSDATE);

--8.Check All Details:
SELECT * FROM Couriers WHERE courier_id = 7;
SELECT * FROM Payments WHERE courier_id = 7;
SELECT * FROM Feedback WHERE courier_id = 7;
--------------------------------------------------------------------------------------------------------------------------















