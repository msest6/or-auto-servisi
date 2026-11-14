package fer.hr.or.autoservisi.model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Jedan redak tablice: jedan servis zajedno s podacima servisnog centra
 * koji ga je obavio i automobila koji je servisiran (isto kao jedan redak CSV-a).
 * U JSON-u se nazivi polja pišu snake_case (centar_id, centar_naziv...).
 */
public record ServisRedak(
        // servisni centar
        Integer centarId,
        String centarNaziv,
        String grad,
        String adresa,
        String telefon,
        String email,
        String webStranica,
        Integer godinaOsnivanja,
        String ovlasteniZa,
        BigDecimal ocjena,
        BigDecimal latitude,
        BigDecimal longitude,
        // servis
        Integer servisId,
        LocalDate datum,
        String vrstaUsluge,
        String mehanicar,
        Integer kilometraza,
        BigDecimal cijenaEur,
        String opis,
        // automobil
        Integer automobilId,
        String registracija,
        String marka,
        String model,
        Integer godinaProizvodnje,
        String vrstaGoriva,
        Integer snagaKw,
        String boja
) {
}
