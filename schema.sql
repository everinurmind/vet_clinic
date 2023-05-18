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