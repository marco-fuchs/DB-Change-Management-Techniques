ALTER TABLE customer ADD COLUMN gender VARCHAR(50);


UPDATE customer
SET gender = 'undef';