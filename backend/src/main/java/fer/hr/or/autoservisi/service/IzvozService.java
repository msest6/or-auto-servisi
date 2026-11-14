package fer.hr.or.autoservisi.service;

import fer.hr.or.autoservisi.model.ServisRedak;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Pretvara (filtrirane) retke u CSV i JSON istog oblika kao
 * auto_servisi.csv i auto_servisi.json koje generira export.sql.
 */
@Service
public class IzvozService {

    private static final List<String> CSV_ZAGLAVLJE = List.of(
            "centar_id", "centar_naziv", "grad", "adresa", "telefon", "email",
            "web_stranica", "godina_osnivanja", "ovlasteni_za", "ocjena",
            "latitude", "longitude",
            "servis_id", "datum", "vrsta_usluge", "mehanicar", "kilometraza",
            "cijena_eur", "opis",
            "automobil_id", "registracija", "marka", "model",
            "godina_proizvodnje", "vrsta_goriva", "snaga_kw", "boja");

    // ------------------------------------------------------------------
    // CSV: jedan redak = jedan servis
    // ------------------------------------------------------------------

    public String uCsv(List<ServisRedak> redci) {
        StringBuilder sb = new StringBuilder();
        sb.append(String.join(",", CSV_ZAGLAVLJE)).append('\n');
        for (ServisRedak r : redci) {
            sb.append(Stream.of(
                    r.centarId(), r.centarNaziv(), r.grad(), r.adresa(), r.telefon(), r.email(),
                    r.webStranica(), r.godinaOsnivanja(), r.ovlasteniZa(), r.ocjena(),
                    r.latitude(), r.longitude(),
                    r.servisId(), r.datum(), r.vrstaUsluge(), r.mehanicar(), r.kilometraza(),
                    r.cijenaEur(), r.opis(),
                    r.automobilId(), r.registracija(), r.marka(), r.model(),
                    r.godinaProizvodnje(), r.vrstaGoriva(), r.snagaKw(), r.boja()
            ).map(IzvozService::csvVrijednost).collect(Collectors.joining(",")));
            sb.append('\n');
        }
        return sb.toString();
    }

    /** null -> prazno; vrijednost sa zarezom, navodnikom ili novim retkom ide u navodnike. */
    private static String csvVrijednost(Object v) {
        if (v == null) {
            return "";
        }
        String s = v instanceof BigDecimal bd ? bd.toPlainString() : v.toString();
        if (s.contains(",") || s.contains("\"") || s.contains("\n") || s.contains("\r")) {
            return "\"" + s.replace("\"", "\"\"") + "\"";
        }
        return s;
    }

    // ------------------------------------------------------------------
    // JSON: centar -> automobili -> servisi
    // ------------------------------------------------------------------

    public List<Map<String, Object>> uJson(List<ServisRedak> redci) {
        // centri redom kojim dolaze (redci su poredani po id-u centra)
        Map<Integer, Map<String, Object>> centri = new LinkedHashMap<>();
        // za svaki centar: automobili poredani po id-u
        Map<Integer, TreeMap<Integer, Map<String, Object>>> automobiliCentra = new LinkedHashMap<>();

        for (ServisRedak r : redci) {
            centri.computeIfAbsent(r.centarId(), id -> centar(r));
            Map<String, Object> automobil = automobiliCentra
                    .computeIfAbsent(r.centarId(), id -> new TreeMap<>())
                    .computeIfAbsent(r.automobilId(), id -> automobil(r));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> servisi = (List<Map<String, Object>>) automobil.get("servisi");
            servisi.add(servis(r));
        }

        centri.forEach((id, centar) ->
                centar.put("automobili", new ArrayList<>(automobiliCentra.get(id).values())));

        return new ArrayList<>(centri.values());
    }

    // LinkedHashMap čuva redoslijed ključeva, isti kao u schema.json i export.sql

    private static Map<String, Object> centar(ServisRedak r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.centarId());
        m.put("naziv", r.centarNaziv());
        m.put("grad", r.grad());
        m.put("adresa", r.adresa());
        m.put("telefon", r.telefon());
        m.put("email", r.email());
        m.put("web_stranica", r.webStranica());
        m.put("godina_osnivanja", r.godinaOsnivanja());
        m.put("ovlasteni_za", r.ovlasteniZa());
        m.put("ocjena", r.ocjena());
        m.put("latitude", r.latitude());
        m.put("longitude", r.longitude());
        return m;
    }

    private static Map<String, Object> automobil(ServisRedak r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.automobilId());
        m.put("registracija", r.registracija());
        m.put("marka", r.marka());
        m.put("model", r.model());
        m.put("godina_proizvodnje", r.godinaProizvodnje());
        m.put("vrsta_goriva", r.vrstaGoriva());
        m.put("snaga_kw", r.snagaKw());
        m.put("boja", r.boja());
        m.put("servisi", new ArrayList<Map<String, Object>>());
        return m;
    }

    private static Map<String, Object> servis(ServisRedak r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.servisId());
        m.put("datum", r.datum());
        m.put("vrsta_usluge", r.vrstaUsluge());
        m.put("mehanicar", r.mehanicar());
        m.put("kilometraza", r.kilometraza());
        m.put("cijena_eur", r.cijenaEur());
        m.put("opis", r.opis());
        return m;
    }
}
