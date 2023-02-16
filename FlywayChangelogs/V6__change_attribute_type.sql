ALTER TABLE customer
ALTER COLUMN private_email TYPE VARCHAR(100) USING private_email::varchar;