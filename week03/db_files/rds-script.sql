CREATE
DATABASE os_aws_cource;

CREATE TABLE solar_system
(
    id     integer PRIMARY KEY,
    name   varchar(40),
    radius varchar(40)
);

INSERT INTO solar_system
VALUES (0, 'Sun', '695000');
INSERT INTO solar_system
VALUES (1, 'Mercury', '2439.7 +- 1.0');
INSERT INTO solar_system
VALUES (2, 'Venus', '6051.8 +- 1.0');
INSERT INTO solar_system
VALUES (3, 'Earth', '6371.00 +- 0.01');
INSERT INTO solar_system
VALUES (4, 'Mars', '3389.508 +- 0.003');
INSERT INTO solar_system
VALUES (5, 'Jupiter', '69911 +- 6*');
INSERT INTO solar_system
VALUES (6, 'Saturn', '58232 +- 6*');
INSERT INTO solar_system
VALUES (7, 'Uranus', '25362 +- 7*');
INSERT INTO solar_system
VALUES (8, 'Neptune', '24622 ± 19*');

SELECT *
FROM solar_system;