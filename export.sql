\encoding UTF8

CREATE TEMP VIEW izvoz_csv AS
SELECT
    c.id               AS centar_id,
    c.naziv            AS centar_naziv,
    c.grad,
    c.adresa,
    c.telefon,
    c.email,
    c.web_stranica,
    c.godina_osnivanja,
    c.ovlasteni_za,
    c.ocjena,
    c.latitude,
    c.longitude,
    s.id               AS servis_id,
    s.datum,
    s.vrsta_usluge,
    s.mehanicar,
    s.kilometraza,
    s.cijena_eur,
    s.opis,
    a.id               AS automobil_id,
    a.registracija,
    a.marka,
    a.model,
    a.godina_proizvodnje,
    a.vrsta_goriva,
    a.snaga_kw,
    a.boja
FROM servisni_centar c
JOIN servis    s ON s.centar_id    = c.id
JOIN automobil a ON a.id           = s.automobil_id
ORDER BY c.id, s.datum, s.id;

\copy (SELECT * FROM izvoz_csv) TO 'auto_servisi.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')

CREATE TEMP VIEW izvoz_json AS
SELECT E'[\n' || string_agg(
    json_build_object(
        'id',                c.id,
        'naziv',             c.naziv,
        'grad',              c.grad,
        'adresa',            c.adresa,
        'telefon',           c.telefon,
        'email',             c.email,
        'web_stranica',      c.web_stranica,
        'godina_osnivanja',  c.godina_osnivanja,
        'ovlasteni_za',      c.ovlasteni_za,
        'ocjena',            c.ocjena,
        'latitude',          c.latitude,
        'longitude',         c.longitude,
        'automobili', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id',                  a.id,
                    'registracija',        a.registracija,
                    'marka',               a.marka,
                    'model',               a.model,
                    'godina_proizvodnje',  a.godina_proizvodnje,
                    'vrsta_goriva',        a.vrsta_goriva,
                    'snaga_kw',            a.snaga_kw,
                    'boja',                a.boja,
                    'servisi', (
                        SELECT json_agg(
                            json_build_object(
                                'id',            s.id,
                                'datum',         s.datum,
                                'vrsta_usluge',  s.vrsta_usluge,
                                'mehanicar',     s.mehanicar,
                                'kilometraza',   s.kilometraza,
                                'cijena_eur',    s.cijena_eur,
                                'opis',          s.opis
                            ) ORDER BY s.datum, s.id
                        )
                        FROM servis s
                        WHERE s.centar_id = c.id
                          AND s.automobil_id = a.id
                    )
                ) ORDER BY a.id
            ), '[]'::json)
            FROM automobil a
            WHERE EXISTS (
                SELECT 1 FROM servis s
                WHERE s.centar_id = c.id AND s.automobil_id = a.id
            )
        )
    )::text, E',\n' ORDER BY c.id
) || E'\n]' AS podaci
FROM servisni_centar c;

\pset tuples_only on
\pset format unaligned
\o auto_servisi.json
SELECT podaci FROM izvoz_json;
\o
\pset tuples_only off
\pset format aligned

\echo 'Gotovo: auto_servisi.csv i auto_servisi.json'