ALTER TABLE chronicle ADD clientidentifier clientidentifier VARCHAR(64);
CREATE INDEX chronicle_clientidentifier ON chronicle(clientidentifier);
