package fer.hr.or.autoservisi.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Pretvara iznimke u jednostavne JSON poruke umjesto zadanih
 * Spring stranica s greškom (aplikacija se pritom ne ruši).
 */
@RestControllerAdvice
public class GreskeHandler {

    private static final Logger log = LoggerFactory.getLogger(GreskeHandler.class);

    /** Neispravan parametar, npr. nepoznat atribut za filtriranje. */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> neispravanZahtjev(IllegalArgumentException e) {
        return odgovor(HttpStatus.BAD_REQUEST, e.getMessage());
    }

    /** Baza nije dostupna, kriva lozinka, greška u upitu... */
    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<Map<String, Object>> baza(DataAccessException e) {
        log.error("Greška pri pristupu bazi", e);
        return odgovor(HttpStatus.SERVICE_UNAVAILABLE, "Greška pri pristupu bazi podataka.");
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> ostalo(Exception e) {
        // Spring greške koje već nose HTTP status (404 nepostojeća putanja,
        // 405 kriva metoda, ResponseStatusException iz kontrolera...)
        if (e instanceof ErrorResponse er) {
            String poruka = er.getBody().getDetail();
            return odgovor(er.getStatusCode(), poruka != null ? poruka : e.getMessage());
        }
        log.error("Neočekivana greška", e);
        return odgovor(HttpStatus.INTERNAL_SERVER_ERROR, "Došlo je do neočekivane greške.");
    }

    private static ResponseEntity<Map<String, Object>> odgovor(HttpStatusCode status, String poruka) {
        Map<String, Object> tijelo = new LinkedHashMap<>();
        tijelo.put("status", status.value());
        tijelo.put("poruka", poruka);
        return ResponseEntity.status(status).body(tijelo);
    }
}
