ALTER TABLE customer RENAME TO clients;


CREATE OR REPLACE VIEW customer_list AS
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