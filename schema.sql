/* Database schema to keep the structure of entire database. */

-- Create a table named animals with the following columns:
CREATE TABLE animals (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL(5, 2) NOT NULL
);

--Add a column species of type string to your animals table:
ALTER TABLE animals ADD species VARCHAR(30);

-- Create a table named owners with the following columns:
CREATE TABLE owners(
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(30),
  age INT,
  PRIMARY KEY(id)
);

-- Create a table named species with the following columns:
CREATE TABLE species(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(30),
  PRIMARY KEY(id)
);

-- Modify animals table:
-- Make sure that id is set as autoincremented PRIMARY KEY:
ALTER TABLE animals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;

-- Remove column species:
ALTER TABLE animals DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table:
ALTER TABLE animals ADD species_id INT REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table:
ALTER TABLE animals ADD owner_id INT REFERENCES owners(id);

-- Create a table named vets with the following columns:
CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(30),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

--  Create a "join table" called specializations to handle this relationship:
CREATE TABLE specializations(
  id INT GENERATED ALWAYS AS IDENTITY,
  vet_id INT REFERENCES vets(id),
  species_id INT REFERENCES species(id),
  PRIMARY KEY(id)
);

-- Create a "join table" called visits to handle this relationship:
CREATE TABLE visits(
  id INT GENERATED ALWAYS AS IDENTITY,
  animal_id INT REFERENCES animals(id),
  vet_id INT REFERENCES vets(id),
  date_of_visit DATE,
  PRIMARY KEY(id)
);

-- Add an email column to your owners table:
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Find a way to improve execution time of the queries:
CREATE INDEX visits_idx ON visits(animal_id);
CREATE INDEX vets_idx ON visits(vet_id);
CREATE INDEX idx_owners_email ON owners(email);