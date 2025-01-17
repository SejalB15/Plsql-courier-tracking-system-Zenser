
# Courier Tracking Management System
## Overview
-The Courier Tracking Management System is a comprehensive solution for managing and tracking couriers, assigning delivery boys, and updating courier statuses. The 
 system uses PL/SQL for managing operations such as CRUD actions, updates, and triggers. It offers a robust database design to handle couriers, tracking, and 
 delivery assignments.

## Features
1. Courier Management: Create, update, track, and manage couriers.<br />
2. Delivery Boy Assignment: Assign delivery boys to couriers and prevent double assignments.<br />
3. Tracking Updates: Track the current status and location of each courier.<br />
4. Real-time Status Updates: View courier status such as Pending, Shipped, or Delivered.<br />

## Database Schema
1. Couriers: Stores courier information including sender and receiver details.<br />
2. Delivery_Boy: Manages delivery boy information and assignment status.<br />
3. Tracking: Tracks courier movements and status updates.<br />
4. Courier_Status: Stores the status history of couriers.<br />
5. Customers: Stores customer information for sending and receiving couriers.<br />
6. Locations: Stores detailed location data for couriers.<br />

## Relations
1. Couriers ↔ Tracking: One-to-Many relationship (a courier has multiple tracking updates).<br />
2. Delivery_Boy ↔ Couriers: One-to-One relationship (each delivery boy can be assigned to only one courier at a time).<br />
3.Couriers ↔ Courier_Status: One-to-Many relationship (each courier has multiple status updates).<br />
4.Tracking ↔ Locations: One-to-Many relationship (tracking records linked to locations).<br />

## Technologies Used
PL/SQL for stored procedures, triggers, and handling database operations.
Oracle Database for storing and managing the data.

## Installation
Set up Oracle Database and create the necessary tables and relationships as described in the schema section.
Insert sample data into the tables to test the system.
Execute stored procedures and triggers for managing couriers, delivery boys, and tracking.

## Usage
Use PL/SQL scripts for adding, updating, and deleting couriers, delivery boys, and tracking records.
Trigger-based checks ensure data integrity and prevent errors such as double assignments.

## Future Enhancements
Adding an admin interface for easier management.<br />
Implementing a mobile application for real-time courier tracking.<br />

### Name: Bajaj Sejal Dipak<br />
### Role: Computer Engineering Student (3rd Year)<br />
### College: Amrutvahini College of Engineering, Sangamner<br />
