ALTER TABLE address ADD COLUMN gender VARCHAR(50);


UPDATE address
SET gender = 'undef';