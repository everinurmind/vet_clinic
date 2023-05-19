/*Queries that provide answers to the questions from all projects.*/

--Day 1
--Find all animals whose name ends in "mon".
SELECT *
    FROM animals
    WHERE name LIKE '%mon';
--List the name of all animals born between 2016 and 2019.
SELECT name
    FROM animals
    WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
--List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name
    FROM animals
    WHERE neutered = true AND escape_attempts < 3;
--List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth
    FROM animals
    WHERE name IN ('Agumon', 'Pikachu');
--List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts
    FROM animals
    WHERE weight_kg > 10.5;
--Find all animals that are neutered.
SELECT *
    FROM animals
    WHERE neutered = true;
--Find all animals not named Gabumon.
SELECT *
    FROM animals
    WHERE name != 'Gabumon';
--Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT *
    FROM animals
    WHERE weight_kg BETWEEN 10.4 AND 17.3;

START TRANSACTION;
UPDATE animals
SET species = 'unspecified';
SELECT species FROM animals;
ROLLBACK;
SELECT species FROM animals;

START TRANSACTION;
UPDATE animals
SET species = 'digimon' WHERE name LIKE '%mon';
SELECT species FROM animals;
UPDATE animals
SET species = 'pokemon' WHERE name NOT LIKE '%mon';
SELECT species FROM animals;
COMMIT;
SELECT species FROM animals;

START TRANSACTION;
DELETE FROM animals;
ROLLBACK;

START TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT update_weights;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO update_weights;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

--Day 2
--How many animals are there?
SELECT COUNT(*) AS total_animals
    FROM animals;
--How many animals have never tried to escape?
SELECT COUNT(*) AS non_escaping_animals
    FROM animals
    WHERE escape_attempts = 0;
--What is the average weight of animals?
SELECT AVG(weight_kg) AS average_weight
    FROM animals;
--Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
    FROM animals
    GROUP BY neutered;
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts
    FROM animals
    GROUP BY neutered;
--What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
    FROM animals
    GROUP BY species;
--What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS average_escape_attempts 
    FROM animals
    WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
    GROUP BY species;

--Day 3
--What animals belong to Melody Pond?
SELECT animals.name
    FROM animals JOIN owners ON animals.owner_id = owners.id
    WHERE owners.full_name = 'Melody Pond';
--List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name
    FROM animals
    JOIN species ON animals.species_id = species.id
    WHERE species.name = 'Pokemon';
--List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;
--How many animals are there per species?
SELECT species.name, COUNT(animals.name)
    FROM species
    LEFT JOIN animals ON species.id = animals.species_id
    GROUP BY species.name;
--List all Digimon owned by Jennifer Orwell.
SELECT animals.name, species.name, owners.full_name
    FROM animals
    JOIN owners ON owners.id = animals.owner_id
    JOIN species ON animals.species_id = species.id
    WHERE owners.full_name = 'Jennifer Orwell' AND species.name LIKE 'Digimon';
--List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, animals.escape_attempts, owners.full_name
    FROM animals
    JOIN owners ON animals.owner_id = owners.id
    WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
--Who owns the most animals?
SELECT COUNT(animals.name), owners.full_name
    FROM animals
    JOIN owners ON animals.owner_id = owners.id
    GROUP BY owners.full_name
    ORDER BY count DESC;

SELECT COUNT(animals.name), owners.full_name
    FROM animals
    JOIN owners ON animals.owner_id = owners.id
    GROUP BY owners.full_name
    ORDER BY count DESC LIMIT 1;

--Day 4
-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name, MAX(visits.date_of_visit)
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    WHERE vets.name = 'William Tatcher'
    GROUP BY animals.name, vets.name
    ORDER BY MAX(visits.date_of_visit) DESC LIMIT 1;
-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals.name)
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    WHERE vets.name = 'Stephanie Mendez';
-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
    FROM vets
    LEFT JOIN specializations ON vets.id = specializations.vet_id
    LEFT JOIN species ON species.id = specializations.species_id;
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, visits.date_of_visit
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';
-- What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animal_id)
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    GROUP BY animals.name
    ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;
-- Who was Maisy Smith's first visit?
SELECT animals.name, visits.date_of_visit
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    WHERE vets.name = 'Maisy Smith'
    ORDER BY visits.date_of_visit ASC LIMIT 1;
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vets.name, visits.date_of_visit
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    ORDER BY visits.date_of_visit DESC LIMIT 1;
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(visits.animal_id)
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    JOIN specializations ON vets.id = specializations.vet_id
    WHERE specializations.species_id != animals.species_id;
-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(visits.animal_id)
    FROM visits JOIN animals ON visits.animal_id = animals.id
    JOIN vets ON visits.vet_id = vets.id
    JOIN specializations ON vets.id = specializations.vet_id
    JOIN species ON species.id = specializations.species_id
    WHERE animals.owner_id = 1
    GROUP BY species.name
    ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;
