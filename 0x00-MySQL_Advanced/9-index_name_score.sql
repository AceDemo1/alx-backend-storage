-- create indexes

CREATE INDEX idx_name_first_score ON names (names(1), score);
