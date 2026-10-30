\encoding UTF8

CREATE TEMP VIEW izvoz_csv AS
SELECT
    s.id                     AS servis_id,
    s.naziv                  AS servis_naziv,
    s.grad,
    s.adresa,
    s.telefon,
    s.email,
    s.web_stranica,
    s.godina_osnivanja,
    s.ovlasteni_za,
    s.ocjena,
    s.latitude,
    s.longitude,
    a.id                     AS automobil_id,
    a.marka,
    a.model,
    a.godina_proizvodnje,
    a.vrsta_goriva,
    a.snaga_kw,
    a.kilometraza,
    a.boja,
    a.datum_zadnjeg_servisa
FROM servis s
JOIN automobil a ON a.servis_id = s.id
ORDER BY s.id, a.id;

\copy (SELECT * FROM izvoz_csv) TO 'auto_servisi.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')

CREATE TEMP VIEW izvoz_json AS
SELECT E'[\n' || string_agg(
    json_build_object(
        'id',                s.id,
        'naziv',             s.naziv,
        'grad',              s.grad,
        'adresa',            s.adresa,
        'telefon',           s.telefon,
        'email',             s.email,
        'web_stranica',      s.web_stranica,
        'godina_osnivanja',  s.godina_osnivanja,
        'ovlasteni_za',      s.ovlasteni_za,
        'ocjena',            s.ocjena,
        'latitude',          s.latitude,
        'longitude',         s.longitude,
        'automobili', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id',                     a.id,
                    'marka',                  a.marka,
                    'model',                  a.model,
                    'godina_proizvodnje',     a.godina_proizvodnje,
                    'vrsta_goriva',           a.vrsta_goriva,
                    'snaga_kw',               a.snaga_kw,
                    'kilometraza',            a.kilometraza,
                    'boja',                   a.boja,
                    'datum_zadnjeg_servisa',  a.datum_zadnjeg_servisa
                ) ORDER BY a.id
            ), '[]'::json)
            FROM automobil a
            WHERE a.servis_id = s.id
        )
    )::text, E',\n' ORDER BY s.id
) || E'\n]' AS podaci
FROM servis s;

\pset tuples_only on
\pset format unaligned
\o auto_servisi.json
SELECT podaci FROM izvoz_json;
\o
\pset tuples_only off
\pset format aligned

\echo 'Gotovo: auto_servisi.csv i auto_servisi.json'