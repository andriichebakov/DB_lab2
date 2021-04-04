DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Registered;
DROP TABLE IF EXISTS Institution;
DROP TABLE IF EXISTS Location;


CREATE TABLE Location (
    loc_id SERIAL PRIMARY KEY,
    Type VARCHAR(255),
    Region VARCHAR(255),
    City VARCHAR(255),
    Area VARCHAR(255)
);


CREATE TABLE Institution (
    EOName VARCHAR(255) PRIMARY KEY,
    Type VARCHAR(255),
    loc_id SERIAL REFERENCES Location(loc_id),
    Parent VARCHAR(255)
);


CREATE TABLE Registered (
    OutID VARCHAR(255) PRIMARY KEY,
    Birth INT,
	Sex VARCHAR(255),
    loc_id SERIAL REFERENCES Location(loc_id),
    Status VARCHAR(255),
    Profile VARCHAR(255),
    Language VARCHAR(255),
    EOName VARCHAR(255) REFERENCES Institution(EOName)
);


CREATE TABLE Results (
    OutID VARCHAR(255) REFERENCES Registered(OutID),
    Test VARCHAR(255),
    Year INT,
    Lang VARCHAR(255),
    Result VARCHAR(255),
    DPALevel VARCHAR(255),
    Ball100 REAL,
    Ball12 REAL,
    Ball REAL,
    AdaptScale VARCHAR(255),
    TestPoint VARCHAR(255) REFERENCES Institution(EOName),
    PRIMARY KEY(OutID, Test, Year)
);
