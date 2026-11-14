package fer.hr.or.autoservisi.repository;

import fer.hr.or.autoservisi.model.Atribut;
import fer.hr.or.autoservisi.model.ServisRedak;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Čitanje servisa iz baze uz filtriranje.
 * Svaki redak rezultata = jedan servis + njegov centar + njegov automobil.
 */
@Repository
public class ServisRepository {

    private static final String SELECT = """
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
            JOIN servis    s ON s.centar_id = c.id
            JOIN automobil a ON a.id        = s.automobil_id
            """;

    private static final String ORDER_BY = " ORDER BY c.id, s.datum, s.id";

    private static final RowMapper<ServisRedak> MAPPER = (rs, i) -> new ServisRedak(
            rs.getObject("centar_id", Integer.class),
            rs.getString("centar_naziv"),
            rs.getString("grad"),
            rs.getString("adresa"),
            rs.getString("telefon"),
            rs.getString("email"),
            rs.getString("web_stranica"),
            rs.getObject("godina_osnivanja", Integer.class),
            rs.getString("ovlasteni_za"),
            rs.getBigDecimal("ocjena"),
            rs.getBigDecimal("latitude"),
            rs.getBigDecimal("longitude"),
            rs.getObject("servis_id", Integer.class),
            rs.getObject("datum", LocalDate.class),
            rs.getString("vrsta_usluge"),
            rs.getString("mehanicar"),
            rs.getObject("kilometraza", Integer.class),
            rs.getBigDecimal("cijena_eur"),
            rs.getString("opis"),
            rs.getObject("automobil_id", Integer.class),
            rs.getString("registracija"),
            rs.getString("marka"),
            rs.getString("model"),
            rs.getObject("godina_proizvodnje", Integer.class),
            rs.getString("vrsta_goriva"),
            rs.getObject("snaga_kw", Integer.class),
            rs.getString("boja")
    );

    private final JdbcTemplate jdbc;

    public ServisRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /**
     * Vraća servise koji odgovaraju filtru.
     *
     * @param tekst   traženi tekst; prazan ili null = bez filtra (svi podaci)
     * @param atribut atribut po kojem se traži; null = pretraga po svim atributima (wildcard)
     */
    public List<ServisRedak> pretrazi(String tekst, Atribut atribut) {
        if (tekst == null || tekst.isBlank()) {
            return jdbc.query(SELECT + ORDER_BY, MAPPER);
        }

        // %tekst% -> sadrži tekst bilo gdje; znakovi % i _ iz unosa traže se doslovno
        String uzorak = "%" + escapeLike(tekst.trim()) + "%";

        // Svaki atribut se pretvara u tekst, pa se i brojevi i datumi
        // mogu pretraživati (npr. "2026-09" ili "4.6"); ILIKE ne razlikuje velika i mala slova
        List<Atribut> poKojima = atribut == null ? Atribut.svi() : List.of(atribut);
        String where = poKojima.stream()
                .map(a -> "CAST(" + a.getSqlIzraz() + " AS TEXT) ILIKE ?")
                .collect(Collectors.joining(" OR ", " WHERE (", ")"));

        List<Object> parametri = new ArrayList<>();
        poKojima.forEach(a -> parametri.add(uzorak));

        return jdbc.query(SELECT + where + ORDER_BY, MAPPER, parametri.toArray());
    }

    private static String escapeLike(String s) {
        return s.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }
}
