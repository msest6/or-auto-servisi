package fer.hr.or.autoservisi.controller;

import fer.hr.or.autoservisi.model.Atribut;
import fer.hr.or.autoservisi.model.ServisRedak;
import fer.hr.or.autoservisi.repository.ServisRepository;
import fer.hr.or.autoservisi.service.IzvozService;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * Krajnje točke za tablicu u datatable.html.
 *
 * Svi parametri su neobavezni:
 *   q       - traženi tekst (prazno = svi podaci)
 *   atribut - naziv atributa (npr. "model"); prazno = pretraga po svim atributima
 *
 * Primjeri:
 *   GET /api/servisi                         -> svi servisi
 *   GET /api/servisi?q=golf                  -> "golf" u bilo kojem atributu
 *   GET /api/servisi?q=golf&atribut=model    -> "golf" samo u modelu
 *   GET /api/servisi/csv?q=golf              -> isti rezultat kao CSV datoteka
 *   GET /api/servisi/json?q=golf             -> isti rezultat kao JSON datoteka
 */
@RestController
@RequestMapping("/api")
public class ServisController {

    private final ServisRepository repository;
    private final IzvozService izvoz;

    public ServisController(ServisRepository repository, IzvozService izvoz) {
        this.repository = repository;
        this.izvoz = izvoz;
    }

    /** Atributi za padajući izbornik u obrascu za filtriranje. */
    @GetMapping("/atributi")
    public List<Map<String, String>> atributi() {
        return Atribut.svi().stream()
                .map(a -> Map.of("naziv", a.getNaziv(), "oznaka", a.getOznaka()))
                .toList();
    }

    /** Filtrirani podaci za prikaz u tablici (jedan objekt = jedan redak tablice). */
    @GetMapping("/servisi")
    public List<ServisRedak> servisi(@RequestParam(required = false) String q,
                                     @RequestParam(required = false) String atribut) {
        return pretrazi(q, atribut);
    }

    /** Preuzimanje trenutnog (filtriranog) prikaza kao CSV. */
    @GetMapping("/servisi/csv")
    public ResponseEntity<byte[]> servisiCsv(@RequestParam(required = false) String q,
                                             @RequestParam(required = false) String atribut) {
        byte[] csv = izvoz.uCsv(pretrazi(q, atribut)).getBytes(StandardCharsets.UTF_8);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, privitak("auto_servisi_filtrirano.csv"))
                .contentType(new MediaType("text", "csv", StandardCharsets.UTF_8))
                .body(csv);
    }

    /** Preuzimanje trenutnog (filtriranog) prikaza kao JSON (centar -> automobili -> servisi). */
    @GetMapping("/servisi/json")
    public ResponseEntity<List<Map<String, Object>>> servisiJson(@RequestParam(required = false) String q,
                                                                 @RequestParam(required = false) String atribut) {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, privitak("auto_servisi_filtrirano.json"))
                .contentType(MediaType.APPLICATION_JSON)
                .body(izvoz.uJson(pretrazi(q, atribut)));
    }

    private List<ServisRedak> pretrazi(String q, String atribut) {
        Atribut a = null;
        if (atribut != null && !atribut.isBlank()) {
            a = Atribut.poNazivu(atribut)
                    .orElseThrow(() -> new IllegalArgumentException("Nepoznat atribut: " + atribut));
        }
        return repository.pretrazi(q, a);
    }

    private static String privitak(String nazivDatoteke) {
        return ContentDisposition.attachment().filename(nazivDatoteke).build().toString();
    }
}
