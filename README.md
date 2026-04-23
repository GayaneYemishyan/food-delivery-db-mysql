# Online Food Delivery System — Database + Admin Dashboard

> A fully normalized relational database for an online food delivery platform, implemented in **Microsoft SQL Server (T‑SQL)** and connected to a lightweight **Flask + HTML/CSS/JS** admin dashboard.

---

## 📌 Project Overview

This repository contains a complete **relational database** for an Online Food Delivery System (OFDS) and a connected admin interface that queries and visualizes live data.

**What this project demonstrates**
- Conceptual design → relational schema mapping
- **Normalization to 3NF**
- Full SQL implementation (DDL/DML + reporting queries)
- **Views**, **Indexes**, **Triggers**, and **Stored Procedures**
- A connected **Flask API** serving a static **HTML admin dashboard**

---

## 🗂️ Repository Structure

```
food-delivery-db-mysql/
│
├── database/
│   ├── creating_database.sql
│   ├── data.sql
│   ├── indexes.sql
│   ├── views.sql
│   ├── triggers.sql
│   ├── stored_procedures.sql
│   ├── dcl.sql
│   └── queries.sql
│
├── UI/
│   ├── server.py
│   ├── requirements.txt
│   └── public/
│       └── index.html
│
├── requirements.txt
└── startup.sh
```

---

## 🗃️ Database Schema (Main Tables)

The database consists of **12 tables** covering platform operations:

| Table | Description |
|------|-------------|
| `USER` | Platform accounts: customers, drivers, and admins |
| `USER_PHONE` | Multi-valued phone numbers per user |
| `ADDRESS` | Delivery addresses owned by users |
| `RESTAURANT` | Registered restaurants with location and rating |
| `RESTAURANT_CUISINETYPE` | Multi-valued cuisine categories per restaurant |
| `RESTAURANT_PHONE` | Multi-valued contact phones per restaurant |
| `MENUITEM` | Dishes offered by each restaurant with pricing |
| `ORDERS` | Customer order headers with status tracking |
| `ORDERITEM` | Line items within each order |
| `PAYMENT` | Payment records (1:1 with orders) |
| `DELIVERY` | Fulfilment records linking orders to drivers |
| `FEEDBACK` | Post-delivery customer ratings and comments |

---

## ⚙️ Database Scripts (Execution Order)

Run the scripts in this order to respect referential integrity and dependencies:

```sql
-- 1) Create DB objects (tables + constraints)
-- File: database/creating_database.sql

-- 2) Insert sample data
-- File: database/data.sql

-- 3) Create performance indexes
-- File: database/indexes.sql

-- 4) Create views
-- File: database/views.sql

-- 5) Create triggers (business rules)
-- File: database/triggers.sql

-- 6) Create stored procedures (workflows)
-- File: database/stored_procedures.sql

-- 7) Access control / roles
-- File: database/dcl.sql

-- 8) (Optional) Verification / reporting queries
-- File: database/queries.sql
```

---

## 🔒 Triggers, Views, Stored Procedures (Highlights)

This project includes:
- **Triggers** to enforce business rules (e.g., preventing invalid feedback, syncing totals, updating ratings)
- **Views** for reporting and dashboard-friendly querying
- **Stored procedures** for reusable workflows (place order, process payment, analytics, etc.)

See:
- `database/triggers.sql`
- `database/views.sql`
- `database/stored_procedures.sql`

---

## 🖥️ Admin Dashboard (Flask + Static UI)

The UI is served by a Flask app and a static HTML frontend:

- Flask API: `UI/server.py`
- Static frontend: `UI/public/index.html`

---

## 🔌 Database Connection (Environment Variables)

The Flask app uses `pyodbc` and expects the following environment variables:

- `DB_HOST` — SQL Server host (local or Azure SQL)
- `DB_NAME` — database name (default: `FoodDeliveryDB`)
- `DB_USER` — username
- `DB_PASSWORD` — password
- `SERVER_PORT` — optional; default is `5000`

> Note: `UI/server.py` is configured to use **ODBC Driver 18 for SQL Server** and enables encryption settings appropriate for Azure SQL.

---

## 🚀 How to Run (Local)

### Requirements
- Python 3.x
- Microsoft SQL Server (local) or Azure SQL
- ODBC Driver 18 for SQL Server installed
- (Recommended) a Python virtual environment

### 1) Install dependencies

From the repo root:

```bash
pip install -r requirements.txt
```

(or from `UI/`)

```bash
pip install -r UI/requirements.txt
```

### 2) Create the database + load data

Run the SQL scripts in the order listed above (see **Database Scripts** section).

### 3) Set environment variables

**macOS/Linux**
```bash
export DB_HOST="your-sql-server-host"
export DB_NAME="FoodDeliveryDB"
export DB_USER="your-username"
export DB_PASSWORD="your-password"
export SERVER_PORT=5000
```

**Windows (PowerShell)**
```powershell
setx DB_HOST "your-sql-server-host"
setx DB_NAME "FoodDeliveryDB"
setx DB_USER "your-username"
setx DB_PASSWORD "your-password"
setx SERVER_PORT "5000"
```

### 4) Start the server

```bash
python UI/server.py
```

Open in your browser:
- `http://localhost:5000/`

---

## ☁️ Deployment Notes

A `startup.sh` is included to run the app with Gunicorn (useful for Azure App Service / Linux hosting):

```bash
cd /home/site/wwwroot/UI
gunicorn --bind=0.0.0.0 --timeout 600 server:app
```

---

## 🛠️ Technology Stack

| Layer | Technology |
|------|------------|
| Database | Microsoft SQL Server (T‑SQL) |
| API | Python (Flask) |
| UI | HTML / CSS / JavaScript |
| DB Driver | `pyodbc` (ODBC Driver 18) |

---

## 👤 Authors

**Gayane Yemishyan**
[**Monika Yepemyan**](https://github.com/Monika303)
