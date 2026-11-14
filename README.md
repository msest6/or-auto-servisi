# Auto servisi u Hrvatskoj

Otvoreni skup podataka o servisnim centrima za automobile u Hrvatskoj, automobilima koji su u njima servisirani i servisima koji su na njima obavljeni. Za svaki servisni centar navedeni su lokacija (grad, adresa i geografske koordinate), kontakt podaci, godina osnivanja, marka za koju je ovlašten te prosječna ocjena korisnika. Za svaki automobil navedeni su registracija i osnovni tehnički podaci, a za svaki servis datum, vrsta usluge, mehaničar, kilometraža vozila, cijena i kratak opis radova.

Između servisnih centara i automobila postoji veza više-na-više (N:N): jedan centar servisira više automobila, a jedan automobil može biti servisiran više puta i u različitim centrima. Svaki pojedini servis povezuje točno jedan centar i jedan automobil. Skup je nastao u sklopu laboratorijskih vježbi iz kolegija Otvoreno računarstvo na FER-u.

> **Napomena:** podaci su izmišljeni i služe isključivo u obrazovne svrhe. Nazivi centara, kontakti, mehaničari, registracije i automobili ne odgovaraju stvarnim osobama, tvrtkama ni vozilima.

## Metapodaci

| Metapodatak | Vrijednost |
|---|---|
| **Naziv skupa** | Auto servisi u Hrvatskoj |
| **Autor** | Matej Šest |
| **Licencija** | [Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.hr) |
| **Verzija** | 2.0 |
| **Datum objave** | 2026-11-09 |
| **Jezik podataka** | hrvatski |
| **Formati** | CSV, JSON |
| **Kodiranje znakova** | UTF-8 |
| **Broj servisnih centara** | 10 |
| **Broj automobila** | 20 |
| **Broj servisa** | 37 |
| **Broj atributa** | 27 (12 za servisni centar, 8 za automobil, 7 za servis) |
| **Geografska pokrivenost** | Republika Hrvatska (Zagreb, Split, Rijeka, Osijek, Zadar, Varaždin, Pula, Slavonski Brod) |
| **Vremenska pokrivenost** | servisi obavljeni od rujna 2025. do listopada 2026. |
| **Izvor podataka** | izmišljeni podaci, uneseni ručno |
| **Baza podataka** | PostgreSQL 18 |
| **Ključne riječi** | automobili, auto servis, servisni centar, vozila, održavanje vozila, Hrvatska |

## Datoteke

| Datoteka | Opis |
|---|---|
| `auto_servisi.csv` | Skup podataka u formatu CSV. Jedan redak predstavlja jedan servis, uz podatke servisnog centra koji ga je obavio i automobila koji je servisiran. Prvi redak sadrži nazive stupaca. |
| `auto_servisi.json` | Skup podataka u formatu JSON (struktura je opisana niže). |
| `auto_servisi_dump.sql` | Dump PostgreSQL baze podataka (struktura i podaci) izrađen alatom `pg_dump`. |
| `export.sql` | SQL skripta za `psql` koja iz baze generira datoteke CSV i JSON. |
| `export.bat` | Windows skripta koja pokreće izvoz u CSV i JSON te izrađuje dump baze. |
| `LICENSE` | Tekst licencije CC BY 4.0. |

## Struktura podataka

U bazi su podaci spremljeni u tri tablice:

```
servisni_centar (1) ──< servis >── (1) automobil
```

Tablica `servis` je vezna tablica koja ostvaruje vezu N:N i sadrži vlastite atribute (datum, mehaničar, kilometraža...).

**JSON** je polje servisnih centara. Svaki centar sadrži polje `automobili` s automobilima koje je servisirao, pri čemu se svaki automobil unutar jednog centra navodi samo jednom. Svaki automobil sadrži polje `servisi` sa servisima obavljenima na njemu u tom centru, poredanima po datumu:

```json
[
  {
    "id": 1,
    "naziv": "Auto Centar Horvat",
    "grad": "Zagreb",
    "...": "...",
    "automobili": [
      {
        "id": 1,
        "registracija": "ZG-1234-AB",
        "marka": "Volkswagen",
        "model": "Golf",
        "...": "...",
        "servisi": [
          { "id": 1, "datum": "2025-09-10", "vrsta_usluge": "veliki servis", "...": "..." },
          { "id": 2, "datum": "2026-09-14", "vrsta_usluge": "mali servis", "...": "..." }
        ]
      }
    ]
  }
]
```

Automobil servisiran u više centara pojavljuje se pod svakim od tih centara.

**CSV** je ravna tablica u kojoj jedan redak predstavlja jedan servis, pa se podaci centra i automobila ponavljaju u svakom retku u kojem se pojavljuju.

## Opis atributa

Nazivi atributa jednaki su u JSON-u i CSV-u, osim identifikatora i naziva centra: u CSV-u su, kako bi se razlikovali unutar istog retka, nazvani `centar_id`, `centar_naziv`, `servis_id` i `automobil_id`, dok se u JSON-u unutar svakog objekta zovu `id` i `naziv`.

### Servisni centar

| Atribut | Tip | Opis |
|---|---|---|
| `id` | cijeli broj | Jedinstveni identifikator servisnog centra |
| `naziv` | tekst | Naziv servisnog centra |
| `grad` | tekst | Grad u kojem se centar nalazi |
| `adresa` | tekst | Ulica i kućni broj |
| `telefon` | tekst | Kontakt telefon u međunarodnom formatu |
| `email` | tekst | Kontakt adresa e-pošte |
| `web_stranica` | tekst | Adresa web stranice; prazno (`null`) ako centar nema stranicu |
| `godina_osnivanja` | cijeli broj | Godina u kojoj je centar osnovan |
| `ovlasteni_za` | tekst | Marka za koju je centar ovlašten ili `sve marke` za neovisne servise |
| `ocjena` | decimalni broj | Prosječna ocjena korisnika na ljestvici od 1.0 do 5.0 |
| `latitude` | decimalni broj | Geografska širina lokacije centra (WGS 84) |
| `longitude` | decimalni broj | Geografska dužina lokacije centra (WGS 84) |

### Automobil

| Atribut | Tip | Opis |
|---|---|---|
| `id` | cijeli broj | Jedinstveni identifikator automobila |
| `registracija` | tekst | Registarska oznaka vozila (jedinstvena) |
| `marka` | tekst | Proizvođač automobila |
| `model` | tekst | Model automobila |
| `godina_proizvodnje` | cijeli broj | Godina proizvodnje |
| `vrsta_goriva` | tekst | Jedno od: `benzin`, `dizel`, `hibrid`, `električni`, `plin` |
| `snaga_kw` | cijeli broj | Snaga motora u kilovatima (kW) |
| `boja` | tekst | Boja vozila |

### Servis

| Atribut | Tip | Opis |
|---|---|---|
| `id` | cijeli broj | Jedinstveni identifikator servisa |
| `datum` | datum | Datum obavljanja servisa u formatu `GGGG-MM-DD` (ISO 8601) |
| `vrsta_usluge` | tekst | Jedno od: `mali servis`, `veliki servis`, `zamjena guma`, `dijagnostika`, `popravak kočnica`, `klima servis`, `tehnički pregled` |
| `mehanicar` | tekst | Ime i prezime mehaničara koji je obavio servis |
| `kilometraza` | cijeli broj | Prijeđeni kilometri vozila u trenutku servisa |
| `cijena_eur` | decimalni broj | Cijena servisa u eurima |
| `opis` | tekst | Kratak opis obavljenih radova |

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

## Promjene u odnosu na verziju 1.0

- Veza između centara i automobila promijenjena je iz 1:N u N:N uvođenjem tablice `servis`.
- Tablica `servis` iz verzije 1.0 preimenovana je u `servisni_centar`.
- Automobilu je dodan atribut `registracija`, a atributi `kilometraza` i `datum_zadnjeg_servisa` premješteni su u servis (kao `kilometraza` i `datum`).
- Dodani su atributi servisa: `vrsta_usluge`, `mehanicar`, `cijena_eur` i `opis`.
- Promijenjena je struktura JSON-a (centar → automobili → servisi) i CSV-a (jedan redak = jedan servis).

## Licencija

Skup podataka objavljen je pod licencijom [Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.hr). Podatke smijete slobodno dijeliti, prilagođavati i koristiti u bilo koje svrhe, uključujući komercijalne, uz uvjet da navedete autora.