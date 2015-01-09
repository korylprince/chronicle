ALTER TABLE chronicle ADD clientidentifier VARCHAR(64);
CREATE INDEX chronicle_clientidentifier ON chronicle(clientidentifier);
