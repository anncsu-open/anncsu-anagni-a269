-- this sql assume that the table anagni_civici already exist and is populated with the data from the anagni_civici.parquet file
-- imported with import_anagni_civici.sql.
-- the sql will read the kml file and extract the geocode for each address in the anagni_civici table and update the table with the geocode
-- the kml file is located at ...
CREATE OR REPLACE TABLE geocoding_results_kml AS (
    SELECT
        A."PROGRESSIVO_ACCESSO",
        A."ODONIMO",
        A."CIVICO",
        A."ESPONENTE",
        AC."Toponimo",
        AC."Civico",
        AC."Latitude",
        AC."Longitude"
    FROM
        anncsu A
    JOIN
        anagni_civici AC
    ON
        A."ODONIMO" = AC."Toponimo" AND
        A."CIVICO" || COALESCE(A."ESPONENTE", '') = AC."Civico"
)

CREATE OR REPLACE TABLE not_kml_geocoded_anncsu AS (
    SELECT
        A.*
    FROM
        anncsu A
    ANTI JOIN
        anagni_civici AC
    ON
        A."ODONIMO" = AC."Toponimo" AND
        A."CIVICO" || COALESCE(A."ESPONENTE", '') = AC."Civico"
);



