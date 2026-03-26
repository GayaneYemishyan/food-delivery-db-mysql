CREATE DATABASE IF NOT EXISTS FoodDeliveryDB;
USE FoodDeliveryDB;
-- ============================================================
-- Food Delivery Database - MySQL Implementation
-- Run this script inside your existing database.
-- ============================================================

-- ============================================================
-- 1. USER
-- ============================================================
DROP TABLE IF EXISTS FEEDBACK;
DROP TABLE IF EXISTS DELIVERY;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS ORDERITEM;
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS MENUITEM;
DROP TABLE IF EXISTS RESTAURANT_PHONE;
DROP TABLE IF EXISTS RESTAURANT_CUISINETYPE;
DROP TABLE IF EXISTS USER_PHONE;
DROP TABLE IF EXISTS ADDRESS;
DROP TABLE IF EXISTS RESTAURANT;
DROP TABLE IF EXISTS USER;
CREATE TABLE IF NOT EXISTS `USER` (
    UserID       INT          NOT NULL AUTO_INCREMENT,
    FirstName    VARCHAR(100) NOT NULL,
    LastName     VARCHAR(100) NOT NULL,
    Email        VARCHAR(255) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    UserName     VARCHAR(100) NOT NULL,
    CreatedAt    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UserType     ENUM('customer','driver','admin') NOT NULL DEFAULT 'customer',

    CONSTRAINT PK_USER          PRIMARY KEY (UserID),
    CONSTRAINT UQ_USER_Email    UNIQUE (Email),
    CONSTRAINT UQ_USER_UserName UNIQUE (UserName)
);

-- ============================================================
-- 2. USER_PHONE
-- ============================================================
CREATE TABLE IF NOT EXISTS USER_PHONE (
    Phone  VARCHAR(20) NOT NULL,
    UserID INT         NOT NULL,

    CONSTRAINT PK_USER_PHONE  PRIMARY KEY (Phone),
    CONSTRAINT FK_UPHONE_USER FOREIGN KEY (UserID)
        REFERENCES `USER` (UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- 3. ADDRESS
-- ============================================================
CREATE TABLE IF NOT EXISTS ADDRESS (
    AddressID    INT          NOT NULL AUTO_INCREMENT,
    City         VARCHAR(100) NOT NULL,
    StreetName   VARCHAR(150) NOT NULL,
    StreetNumber VARCHAR(20)  NOT NULL,
    Apartment    VARCHAR(50)  NULL,
    PostalCode   VARCHAR(20)  NULL,
    IsDefault    TINYINT(1)   NULL DEFAULT 0,
    UserID       INT          NULL,

    CONSTRAINT PK_ADDRESS   PRIMARY KEY (AddressID),
    CONSTRAINT FK_ADDR_USER FOREIGN KEY (UserID)
        REFERENCES `USER` (UserID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ============================================================
-- 4. RESTAURANT
-- ============================================================
CREATE TABLE IF NOT EXISTS RESTAURANT (
    RestaurantID INT            NOT NULL AUTO_INCREMENT,
    Name         VARCHAR(150)   NOT NULL,
    Rating       DECIMAL(3,2)   NULL CHECK (Rating BETWEEN 0 AND 5),
    IsActive     TINYINT(1)     NOT NULL DEFAULT 1,
    City         VARCHAR(100)   NOT NULL,
    StreetName   VARCHAR(150)   NOT NULL,
    StreetNumber VARCHAR(20)    NOT NULL,
    Unit         VARCHAR(50)    NULL,

    CONSTRAINT PK_RESTAURANT PRIMARY KEY (RestaurantID)
);

-- ============================================================
-- 5. RESTAURANT_CUISINETYPE
-- ============================================================
CREATE TABLE IF NOT EXISTS RESTAURANT_CUISINETYPE (
    RestaurantID INT          NOT NULL,
    CuisineType  VARCHAR(100) NOT NULL,

    CONSTRAINT PK_RCT      PRIMARY KEY (RestaurantID, CuisineType),
    CONSTRAINT FK_RCT_REST FOREIGN KEY (RestaurantID)
        REFERENCES RESTAURANT (RestaurantID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- 6. RESTAURANT_PHONE
-- ============================================================
CREATE TABLE IF NOT EXISTS RESTAURANT_PHONE (
    Phone        VARCHAR(20) NOT NULL,
    RestaurantID INT         NOT NULL,

    CONSTRAINT PK_RPHONE      PRIMARY KEY (Phone),
    CONSTRAINT FK_RPHONE_REST FOREIGN KEY (RestaurantID)
        REFERENCES RESTAURANT (RestaurantID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- 7. MENUITEM
-- ============================================================
CREATE TABLE IF NOT EXISTS MENUITEM (
    ItemID       INT           NOT NULL AUTO_INCREMENT,
    RestaurantID INT           NOT NULL,
    Name         VARCHAR(150)  NOT NULL,
    Price        DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Description  TEXT          NULL,
    IsAvailable  TINYINT(1)    NOT NULL DEFAULT 1,

    CONSTRAINT PK_MENUITEM  PRIMARY KEY (ItemID),
    CONSTRAINT FK_MENU_REST FOREIGN KEY (RestaurantID)
        REFERENCES RESTAURANT (RestaurantID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- 8. ORDERS
-- ============================================================
CREATE TABLE IF NOT EXISTS ORDERS (
    OrderID    INT           NOT NULL AUTO_INCREMENT,
    UserID     INT           NOT NULL,
    Status     ENUM('pending','confirmed','preparing',
                    'out_for_delivery','delivered','cancelled')
                             NOT NULL DEFAULT 'pending',
    TotalPrice DECIMAL(10,2) NOT NULL CHECK (TotalPrice >= 0),
    OrderDate  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_ORDERS      PRIMARY KEY (OrderID),
    CONSTRAINT FK_ORDERS_USER FOREIGN KEY (UserID)
        REFERENCES `USER` (UserID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- 9. ORDERITEM
-- ============================================================
CREATE TABLE IF NOT EXISTS ORDERITEM (
    OrderItemID INT           NOT NULL AUTO_INCREMENT,
    OrderID     INT           NOT NULL,
    ItemID      INT           NOT NULL,
    Quantity    INT           NOT NULL CHECK (Quantity > 0),
    UnitPrice   DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),

    CONSTRAINT PK_ORDERITEM PRIMARY KEY (OrderItemID),
    CONSTRAINT FK_OI_ORDER  FOREIGN KEY (OrderID)
        REFERENCES ORDERS (OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_OI_MENU   FOREIGN KEY (ItemID)
        REFERENCES MENUITEM (ItemID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- 10. PAYMENT
-- ============================================================
CREATE TABLE IF NOT EXISTS PAYMENT (
    PaymentID     INT           NOT NULL AUTO_INCREMENT,
    OrderID       INT           NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Method        ENUM('cash','credit_card','debit_card',
                       'online_wallet','bank_transfer') NOT NULL,
    PaymentTime   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PaymentStatus ENUM('pending','completed','failed','refunded')
                               NOT NULL DEFAULT 'pending',

    CONSTRAINT PK_PAYMENT   PRIMARY KEY (PaymentID),
    CONSTRAINT FK_PAY_ORDER FOREIGN KEY (OrderID)
        REFERENCES ORDERS (OrderID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT UQ_PAY_ORDER UNIQUE (OrderID)
);

-- ============================================================
-- 11. DELIVERY
-- ============================================================
CREATE TABLE IF NOT EXISTS DELIVERY (
    DeliveryID     INT      NOT NULL AUTO_INCREMENT,
    OrderID        INT      NOT NULL,
    UserID         INT      NOT NULL,
    AddressID      INT      NOT NULL,
    PickupTime     DATETIME NULL,
    DeliveryTime   DATETIME NULL,
    DeliveryStatus ENUM('assigned','picked_up',
                        'in_transit','delivered','failed')
                            NOT NULL DEFAULT 'assigned',

    CONSTRAINT PK_DELIVERY   PRIMARY KEY (DeliveryID),
    CONSTRAINT FK_DEL_ORDER  FOREIGN KEY (OrderID)
        REFERENCES ORDERS (OrderID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_DEL_DRIVER FOREIGN KEY (UserID)
        REFERENCES `USER` (UserID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_DEL_ADDR   FOREIGN KEY (AddressID)
        REFERENCES ADDRESS (AddressID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- 12. FEEDBACK
-- ============================================================
CREATE TABLE IF NOT EXISTS FEEDBACK (
    FeedbackID   INT      NOT NULL AUTO_INCREMENT,
    UserID       INT      NOT NULL,
    OrderID      INT      NOT NULL,
    RestaurantID INT      NOT NULL,
    Rating       TINYINT  NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment      TEXT     NULL,
    FeedbackDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_FEEDBACK  PRIMARY KEY (FeedbackID),
    CONSTRAINT FK_FB_USER   FOREIGN KEY (UserID)
        REFERENCES `USER` (UserID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_FB_ORDER  FOREIGN KEY (OrderID)
        REFERENCES ORDERS (OrderID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_FB_REST   FOREIGN KEY (RestaurantID)
        REFERENCES RESTAURANT (RestaurantID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX IDX_UPHONE_USER ON USER_PHONE  (UserID);
CREATE INDEX IDX_ADDR_USER   ON ADDRESS     (UserID);
CREATE INDEX IDX_MENU_REST   ON MENUITEM    (RestaurantID);
CREATE INDEX IDX_ORDERS_USER ON ORDERS      (UserID);
CREATE INDEX IDX_OI_ORDER    ON ORDERITEM   (OrderID);
CREATE INDEX IDX_OI_ITEM     ON ORDERITEM   (ItemID);
CREATE INDEX IDX_DEL_ORDER   ON DELIVERY    (OrderID);
CREATE INDEX IDX_DEL_DRIVER  ON DELIVERY    (UserID);
CREATE INDEX IDX_DEL_ADDR    ON DELIVERY    (AddressID);
CREATE INDEX IDX_FB_USER     ON FEEDBACK    (UserID);
CREATE INDEX IDX_FB_ORDER    ON FEEDBACK    (OrderID);
CREATE INDEX IDX_FB_REST     ON FEEDBACK    (RestaurantID);


-- Optional verification
SHOW TABLES;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY table_name;