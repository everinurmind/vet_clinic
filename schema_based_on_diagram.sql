
-- Implement the database from the diagram:
CREATE DATABASE clinic;

CREATE TABLE patients (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR,
  date_of_birth DATE,
  PRIMARY key (id)
);

CREATE TABLE medical_histories (
  id INT GENERATED ALWAYS AS IDENTITY,
  admitted_at TIMESTAMP,
  patient_id INT REFERENCES patients (id),
  status VARCHAR,
  PRIMARY KEY (id)
);

CREATE TABLE invoices (
  id INT GENERATED ALWAYS AS IDENTITY,
  total_amount DECIMAL,
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_histories_id INT REFERENCES medical_histories(id),
  PRIMARY key (id)
);

CREATE TABLE treatments (
  id INT GENERATED ALWAYS AS IDENTITY,
  type VARCHAR,
  name VARCHAR,
  PRIMARY KEY (id)
);

CREATE TABLE invoice_items (
  id INT GENERATED ALWAYS AS IDENTITY,
  unit_price DECIMAL,
  quantity INT,
  invoice_id INT REFERENCES invoices (id),
  treatment_id INT REFERENCES treatments (id),
  PRIMARY KEY (id) 
);

CREATE TABLE histories_treatments (
history_id INT REFERENCES medical_histories(id),
treatments_id INT REFERENCES treatments(id)
);