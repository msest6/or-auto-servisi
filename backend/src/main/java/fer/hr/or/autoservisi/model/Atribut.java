package fer.hr.or.autoservisi.model;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

/**
 * Atributi po kojima se može filtrirati.
 * Svaki atribut ima naziv (isti kao stupac u CSV-u), oznaku za prikaz
 * u padajućem izborniku i SQL izraz nad kojim se pretražuje.
 *
 * SQL izraz se nikad ne sastavlja iz korisničkog unosa: korisnik šalje samo
 * naziv atributa, a izraz se uzima iz ove liste (zaštita od SQL injectiona).
 */
public enum Atribut {

    CENTAR_ID("centar_id", "ID centra", "c.id"),
    CENTAR_NAZIV("centar_naziv", "Naziv centra", "c.naziv"),
    GRAD("grad", "Grad", "c.grad"),
    ADRESA("adresa", "Adresa", "c.adresa"),
    TELEFON("telefon", "Telefon", "c.telefon"),
    EMAIL("email", "E-pošta", "c.email"),
    WEB_STRANICA("web_stranica", "Web stranica", "c.web_stranica"),
    GODINA_OSNIVANJA("godina_osnivanja", "Godina osnivanja", "c.godina_osnivanja"),
    OVLASTENI_ZA("ovlasteni_za", "Ovlašteni za", "c.ovlasteni_za"),
    OCJENA("ocjena", "Ocjena", "c.ocjena"),
    LATITUDE("latitude", "Geografska širina", "c.latitude"),
    LONGITUDE("longitude", "Geografska dužina", "c.longitude"),

    SERVIS_ID("servis_id", "ID servisa", "s.id"),
    DATUM("datum", "Datum servisa", "s.datum"),
    VRSTA_USLUGE("vrsta_usluge", "Vrsta usluge", "s.vrsta_usluge"),
    MEHANICAR("mehanicar", "Mehaničar", "s.mehanicar"),
    KILOMETRAZA("kilometraza", "Kilometraža", "s.kilometraza"),
    CIJENA_EUR("cijena_eur", "Cijena (EUR)", "s.cijena_eur"),
    OPIS("opis", "Opis", "s.opis"),

    AUTOMOBIL_ID("automobil_id", "ID automobila", "a.id"),
    REGISTRACIJA("registracija", "Registracija", "a.registracija"),
    MARKA("marka", "Marka", "a.marka"),
    MODEL("model", "Model", "a.model"),
    GODINA_PROIZVODNJE("godina_proizvodnje", "Godina proizvodnje", "a.godina_proizvodnje"),
    VRSTA_GORIVA("vrsta_goriva", "Vrsta goriva", "a.vrsta_goriva"),
    SNAGA_KW("snaga_kw", "Snaga (kW)", "a.snaga_kw"),
    BOJA("boja", "Boja", "a.boja");

    private final String naziv;
    private final String oznaka;
    private final String sqlIzraz;

    Atribut(String naziv, String oznaka, String sqlIzraz) {
        this.naziv = naziv;
        this.oznaka = oznaka;
        this.sqlIzraz = sqlIzraz;
    }

    public String getNaziv() {
        return naziv;
    }

    public String getOznaka() {
        return oznaka;
    }

    public String getSqlIzraz() {
        return sqlIzraz;
    }

    public static Optional<Atribut> poNazivu(String naziv) {
        return Arrays.stream(values())
                .filter(a -> a.naziv.equals(naziv))
                .findFirst();
    }

    public static List<Atribut> svi() {
        return List.of(values());
    }
}
