-- create table anagni_civici readgin the contect from ./anagni_civici.parquet file
CREATE OR REPLACE TABLE anagni_civici  AS (
    SELECT * FROM read_parquet('/mnt/data/PROGRAMMING/AUTONOMO/GeoBeyond/Civici/anncsu-manager/qgisplugin/anncsu_manager/resources/data/anncsu-anagni-a269/anagni_civici.parquet')
)
