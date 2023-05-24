/* Create new database */

-- Implement the database from the diagram:
CREATE DATABASE clinic;

CREATE TABLE patients (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR,
  date_of_birth DATE,
  PRIMARY KEY (id)
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
  medical_history_id INT REFERENCES medical_histories(id),
  PRIMARY KEY (id)
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

CREATE TABLE treatment_history (
  history_id INT REFERENCES medical_histories(id),
  treatment_id INT REFERENCES treatments(id)
);

-- Remember to add the FK indexes:
CREATE INDEX patients_idx ON medical_histories(patient_id);
CREATE INDEX medical_histories_idx ON invoices(medical_history_id);
CREATE INDEX invoices_idx ON invoice_items(invoice_id);
CREATE INDEX treatments_idx ON invoice_items(treatment_id);
CREATE INDEX history_idx ON treatment_history(history_id);
CREATE INDEX treatment_idx ON treatment_history(treatment_id);
