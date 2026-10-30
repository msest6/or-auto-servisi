# Auto servisi u Hrvatskoj

Otvoreni skup podataka o auto servisima u Hrvatskoj i automobilima koje održavaju. Za svaki servis navedeni su lokacija (grad, adresa i geografske koordinate), kontakt podaci, godina osnivanja, marka za koju je ovlašten te prosječna ocjena korisnika. Uz svaki servis vezan je popis automobila koje servisira, s osnovnim tehničkim podacima i datumom zadnjeg servisa.

Skup podataka sadrži vezu roditelj-dijete između entiteta: jedan servis održava više automobila (veza 1:N). Nastao je u sklopu 1. laboratorijske vježbe iz kolegija Otvoreno računarstvo na FER-u.

> **Napomena:** podaci su izmišljeni i služe isključivo u obrazovne svrhe. Nazivi servisa, kontakti i automobili ne odgovaraju stvarnim osobama ni tvrtkama.

## Metapodaci

| Metapodatak | Vrijednost |
|---|---|
| **Naziv skupa** | Auto servisi u Hrvatskoj |
| **Autor** | Matej Šest |
| **Licencija** | [Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.hr) |
| **Verzija** | 1.0 |
| **Datum objave** | 2026-10-30 |
| **Jezik podataka** | hrvatski |
| **Formati** | CSV, JSON |
| **Kodiranje znakova** | UTF-8 |
| **Broj servisa** | 10 |
| **Broj automobila** | 31 |
| **Broj atributa** | 21 (12 za servis, 9 za automobil) |
| **Geografska pokrivenost** | Republika Hrvatska (Zagreb, Split, Rijeka, Osijek, Zadar, Varaždin, Pula, Slavonski Brod) |
| **Vremenska pokrivenost** | datumi zadnjeg servisa od ožujka do listopada 2026. |
| **Izvor podataka** | izmišljeni podaci, uneseni ručno |
| **Baza podataka** | PostgreSQL 18 |
| **Ključne riječi** | automobili, auto servis, vozila, održavanje vozila, Hrvatska |

## Datoteke

| Datoteka | Opis |
|---|---|
| `auto_servisi.csv` | Skup podataka u formatu CSV. Jedan redak predstavlja jedan automobil, a podaci servisa koji ga održava ponavljaju se u svakom retku. Prvi redak sadrži nazive stupaca. |
| `auto_servisi.json` | Skup podataka u formatu JSON. Polje objekata servisa, a svaki servis sadrži ugniježđeno polje `automobili`. |
| `auto_servisi_dump.sql` | Dump PostgreSQL baze podataka (struktura i podaci) izrađen alatom `pg_dump`. |
| `export.sql` | SQL skripta za `psql` koja iz baze generira datoteke CSV i JSON. |
| `export.bat` | Windows skripta koja pokreće izvoz u CSV i JSON te izrađuje dump baze. |
| `LICENSE` | Tekst licencije CC BY 4.0. |

## Opis atributa

### Servis

| Atribut (JSON) | Stupac (CSV) | Tip | Opis |
|---|---|---|---|
| `id` | `servis_id` | cijeli broj | Jedinstveni identifikator servisa |
| `naziv` | `servis_naziv` | tekst | Naziv auto servisa |
| `grad` | `grad` | tekst | Grad u kojem se servis nalazi |
| `adresa` | `adresa` | tekst | Ulica i kućni broj |
| `telefon` | `telefon` | tekst | Kontakt telefon u međunarodnom formatu |
| `email` | `email` | tekst | Kontakt adresa e-pošte |
| `web_stranica` | `web_stranica` | tekst | Adresa web stranice; prazno (`null`) ako servis nema stranicu |
| `godina_osnivanja` | `godina_osnivanja` | cijeli broj | Godina u kojoj je servis osnovan |
| `ovlasteni_za` | `ovlasteni_za` | tekst | Marka za koju je servis ovlašten ili `sve marke` za neovisne servise |
| `ocjena` | `ocjena` | decimalni broj | Prosječna ocjena korisnika na ljestvici od 1.0 do 5.0 |
| `latitude` | `latitude` | decimalni broj | Geografska širina lokacije servisa (WGS 84) |
| `longitude` | `longitude` | decimalni broj | Geografska dužina lokacije servisa (WGS 84) |

### Automobil

| Atribut (JSON) | Stupac (CSV) | Tip | Opis |
|---|---|---|---|
| `id` | `automobil_id` | cijeli broj | Jedinstveni identifikator automobila |
| `marka` | `marka` | tekst | Proizvođač automobila |
| `model` | `model` | tekst | Model automobila |
| `godina_proizvodnje` | `godina_proizvodnje` | cijeli broj | Godina proizvodnje |
| `vrsta_goriva` | `vrsta_goriva` | tekst | Jedno od: `benzin`, `dizel`, `hibrid`, `električni`, `plin` |
| `snaga_kw` | `snaga_kw` | cijeli broj | Snaga motora u kilovatima (kW) |
| `kilometraza` | `kilometraza` | cijeli broj | Prijeđeni kilometri u trenutku zadnjeg servisa |
| `boja` | `boja` | tekst | Boja vozila |
| `datum_zadnjeg_servisa` | `datum_zadnjeg_servisa` | datum | Datum zadnjeg servisa u formatu `GGGG-MM-DD` (ISO 8601) |

## Generiranje datoteka

Datoteke CSV i JSON te dump baze generiraju se automatski iz PostgreSQL baze `auto_servisi`:

```
export.bat
```

ili ručno iz naredbenog retka:

```
psql -h localhost -U postgres -d auto_servisi -f export.sql
pg_dump -h localhost -U postgres --no-owner --no-privileges -f auto_servisi_dump.sql auto_servisi
```

Bazu je moguće vratiti iz dumpa u praznu bazu naredbom:

```
psql -h localhost -U postgres -d auto_servisi -f auto_servisi_dump.sql
```

## Licencija

Skup podataka objavljen je pod licencijom [Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.hr). Podatke smijete slobodno dijeliti, prilagođavati i koristiti u bilo koje svrhe, uključujući komercijalne, uz uvjet da navedete autora.