package fer.hr.or.autoservisi.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

/**
 * Poslužuje cjelokupni skup podataka i shemu izravno s datotečnog sustava
 * (datoteke koje generira export.bat), za poveznice u index.html:
 *   GET /data/auto_servisi.csv
 *   GET /data/auto_servisi.json
 *   GET /data/schema.json
 * Dopuštene su samo ove tri datoteke.
 */
@RestController
public class DatotekaController {

    private static final Map<String, MediaType> DATOTEKE = Map.of(
            "auto_servisi.csv", new MediaType("text", "csv", StandardCharsets.UTF_8),
            "auto_servisi.json", MediaType.APPLICATION_JSON,
            "schema.json", MediaType.APPLICATION_JSON);

    private final Path mapa;

    public DatotekaController(@Value("${app.data-dir}") String dataDir) {
        this.mapa = Path.of(dataDir).toAbsolutePath().normalize();
    }

    @GetMapping("/data/{naziv}")
    public ResponseEntity<Resource> datoteka(@PathVariable String naziv) {
        MediaType tip = DATOTEKE.get(naziv);
        if (tip == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Datoteka ne postoji: " + naziv);
        }
        Path putanja = mapa.resolve(naziv);
        if (!Files.isRegularFile(putanja)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "Datoteka " + naziv + " nije pronađena u " + mapa + " (pokreni export.bat)");
        }
        return ResponseEntity.ok()
                .contentType(tip)
                .body(new FileSystemResource(putanja));
    }
}
