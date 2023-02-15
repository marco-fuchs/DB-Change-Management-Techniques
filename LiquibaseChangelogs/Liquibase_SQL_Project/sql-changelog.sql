--liquibase formatted sql

--changeset C.Kleinstein:1 labels:Scenario 1 
--comment: Scenario 1, Renaming an Attribute

ALTER TABLE customer RENAME COLUMN email TO private_email;

--rollback ALTER TABLE customer RENAME COLUMN private_email TO email;


--changeset C.Kleinstein:2 labels:Scenario 2
--comment: Scenario 2, Add Attribute and fill with const Value

ALTER TABLE customer ADD COLUMN gender VARCHAR(50);

UPDATE customer SET gender = 'undefined';

--rollback ALTER TABLE customer DROP COLUMN gender;


--changeset C.Kleinstein:3 labels:Scenario 3
--comment: Scenario 3, Delete an Attribute

ALTER TABLE customer DROP COLUMN gender;

--rollback ALTER TABLE customer ADD COLUMN gender VARCHAR(50);

--changeset C.Kleinstein:4 labels:Scenario 4
--comment: Scenario 4, Change Attribute type

ALTER TABLE customer ALTER COLUMN private_email TYPE VARCHAR(100) USING private_email::varchar;

--rollback ALTER TABLE customer ALTER COLUMN private_email TYPE TEXT USING private_email::text;

--changeset C.Kleinstein:5 labels:Scenario 5 
--comment: Scenario 5, Rename a table with a related view

ALTER TABLE customer RENAME TO clients;
CREATE OR REPLACE VIEW customer_list
 AS
 SELECT cl.customer_id AS id,
    (cl.first_name || ' '::text) || cl.last_name AS name,
    a.address,
    a.postal_code AS "zip code",
    a.phone,
    city.city,
    country.country,
        CASE
            WHEN cl.activebool THEN 'active'::text
            ELSE ''::text
        END AS notes,
    cl.store_id AS sid
   FROM clients cl
     JOIN address a ON cl.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id;

--rollback ALTER TABLE clients RENAME TO customer; 
--rollback CREATE OR REPLACE VIEW customer_list
--rollback AS
--rollback SELECT cu.customer_id AS id,
--rollback (cu.first_name || ' '::text) || cu.last_name AS name,
--rollback     a.address,
--rollback     a.postal_code AS "zip code",
--rollback     a.phone,
--rollback     city.city,
--rollback     country.country,
--rollback         CASE
--rollback             WHEN cu.activebool THEN 'active'::text
--rollback             ELSE ''::text
--rollback         END AS notes,
--rollback     cu.store_id AS sid
--rollback    FROM customer cu
--rollback      JOIN address a ON cu.address_id = a.address_id
--rollback      JOIN city ON a.city_id = city.city_id
--rollback      JOIN country ON city.country_id = country.country_id;


--changeset C.Kleinstein:6 labels:Scenario 6
--comment: Scenario 6, Split one Attribute into two

ALTER TABLE address ADD COLUMN house_number text;
ALTER TABLE address ADD COLUMN street text;

WITH results AS (
	SELECT address_id as id,
	(string_to_array(address, ' '))[1] as a1,
	array_to_string((string_to_array(address, ' '))[2:], ' ') as a2
	from address
)
UPDATE address
SET house_number = (SELECT a1 FROM results WHERE address_id = results.id),
street = (SELECT a2 FROM results WHERE address_id = results.id);

--rollback ALTER TABLE address DROP COLUMN house_number;
--rollback ALTER TABLE address DROP COLUMN street;





