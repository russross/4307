-- Source:
-- http://2016.padjo.org/tutorials/sqlite-data-starterpacks/#more-info-american-community-survey-1-year-data-for-2015

CREATE TABLE states (
    year INTEGER , 
    name TEXT , 
    geo_id TEXT , 
    total_population INTEGER , 
    white INTEGER , 
    black INTEGER , 
    hispanic INTEGER , 
    asian INTEGER , 
    american_indian INTEGER , 
    pacific_islander INTEGER , 
    other_race INTEGER , 
    median_age FLOAT , 
    total_households INTEGER , 
    owner_occupied_homes_median_value INTEGER , 
    per_capita_income INTEGER , 
    median_household_income INTEGER , 
    below_poverty_line INTEGER, 
    foreign_born_population INTEGER, 
    state TEXT 
);
CREATE TABLE congressional_districts (
    year INTEGER , 
    name TEXT , 
    geo_id TEXT , 
    total_population INTEGER , 
    white INTEGER , 
    black INTEGER , 
    hispanic INTEGER , 
    asian INTEGER , 
    american_indian INTEGER , 
    pacific_islander INTEGER , 
    other_race INTEGER , 
    median_age FLOAT , 
    total_households INTEGER , 
    owner_occupied_homes_median_value INTEGER , 
    per_capita_income INTEGER , 
    median_household_income INTEGER , 
    below_poverty_line INTEGER, 
    foreign_born_population INTEGER, 
    state TEXT,
    congressional_district TEXT
);
CREATE TABLE places (
    year INTEGER , 
    name TEXT , 
    geo_id TEXT , 
    total_population INTEGER , 
    white INTEGER , 
    black INTEGER , 
    hispanic INTEGER , 
    asian INTEGER , 
    american_indian INTEGER , 
    pacific_islander INTEGER , 
    other_race INTEGER , 
    median_age FLOAT , 
    total_households INTEGER , 
    owner_occupied_homes_median_value INTEGER , 
    per_capita_income INTEGER , 
    median_household_income INTEGER , 
    below_poverty_line INTEGER, 
    foreign_born_population INTEGER, 
    state TEXT,
    place TEXT
);
CREATE INDEX "state_on_states" ON states(state);
CREATE INDEX "state_cd_on_cdistricts" ON congressional_districts(state, congressional_district);
CREATE INDEX "state_on_places" ON places(state);
CREATE INDEX "name_on_states" ON states(name);
CREATE INDEX "name_on_cdistricts" ON congressional_districts(name);
CREATE INDEX "name_on_places" ON places(name);
