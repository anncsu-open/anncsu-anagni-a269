-- create geocoded_anncsu as clone of anncsu
CREATE OR REPLACE TABLE geocoded_anncsu AS
SELECT *
FROM anncsu;

-- SELCT ALL PROGRESSIVO_ACCESSO from geocoding_ancsu that are not in geocoding_results_kml
SELECT "PROGRESSIVO_ACCESSO"
FROM geocoded_anncsu
WHERE "PROGRESSIVO_ACCESSO" NOT IN (
    SELECT "PROGRESSIVO_ACCESSO"
    FROM geocoding_results_kml
);

-- checkl that all ids are in goecoded_anncsu_no_kml_solved (should be 0)
with ids AS (
    SELECT "PROGRESSIVO_ACCESSO"
    FROM geocoded_anncsu
    WHERE "PROGRESSIVO_ACCESSO" NOT IN (
        SELECT "PROGRESSIVO_ACCESSO"
        FROM geocoding_results_kml
    )
)
select "PROGRESSIVO_ACCESSO"
from ids
where "PROGRESSIVO_ACCESSO" NOT IN (
    SELECT "PROGRESSIVO_ACCESSO"
    FROM geocoded_anncsu_no_kml_solved
);

-- set geocoded_anncsu coordinates get from geocoding_results_kml that match on PROGRESSIVO_ACCESSO
UPDATE geocoded_anncsu AS g
SET "COORD_X_COMUNE" = k."Longitude",
    "COORD_Y_COMUNE" = k."Latitude"
FROM geocoding_results_kml AS k
WHERE g."PROGRESSIVO_ACCESSO" = k."PROGRESSIVO_ACCESSO";

-- check remaining not geocoded (should be 310)
SELECT COUNT(*)
FROM geocoded_anncsu
WHERE "COORD_X_COMUNE" IS NULL
    OR "COORD_Y_COMUNE" IS NULL;

-- update geocoded_anncsu coordinates get from geocoded_anncsu_no_kml_solved that match on PROGRESSIVO_ACCESSO
UPDATE geocoded_anncsu AS g
SET "COORD_X_COMUNE" = s."COORD_X_COMUNE",
    "COORD_Y_COMUNE" = s."COORD_Y_COMUNE"
FROM geocoded_anncsu_no_kml_solved AS s
WHERE g."PROGRESSIVO_ACCESSO" = s."PROGRESSIVO_ACCESSO";

-- check remaining not geocoded (should be 0 now)
SELECT COUNT(*)
FROM geocoded_anncsu
WHERE "COORD_X_COMUNE" IS NULL
    OR "COORD_Y_COMUNE" IS NULL;
