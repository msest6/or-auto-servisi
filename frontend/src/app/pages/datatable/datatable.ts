import { Component, computed, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

/** Jedan redak tablice = jedan servis s podacima centra i automobila (isto kao redak CSV-a). */
export interface ServisRedak {
  centar_id: number;
  centar_naziv: string;
  grad: string;
  adresa: string;
  telefon: string | null;
  email: string | null;
  web_stranica: string | null;
  godina_osnivanja: number | null;
  ovlasteni_za: string | null;
  ocjena: number | null;
  latitude: number | null;
  longitude: number | null;
  servis_id: number;
  datum: string;
  vrsta_usluge: string;
  mehanicar: string;
  kilometraza: number | null;
  cijena_eur: number | null;
  opis: string | null;
  automobil_id: number;
  registracija: string;
  marka: string;
  model: string;
  godina_proizvodnje: number | null;
  vrsta_goriva: string | null;
  snaga_kw: number | null;
  boja: string | null;
}

/** Atribut za padajući izbornik (dolazi s back-enda: GET /api/atributi). */
interface Atribut {
  naziv: keyof ServisRedak;
  oznaka: string;
}

/** Stupci koji se prikazuju u sažetom prikazu tablice. */
const OSNOVNI_STUPCI: (keyof ServisRedak)[] = [
  'datum',
  'centar_naziv',
  'grad',
  'registracija',
  'marka',
  'model',
  'vrsta_goriva',
  'vrsta_usluge',
  'mehanicar',
  'kilometraza',
  'cijena_eur',
];

@Component({
  selector: 'app-datatable',
  imports: [FormsModule, RouterLink],
  templateUrl: './datatable.html',
  styleUrl: './datatable.css',
})
export class DatatablePage {
  // ---- obrazac ----
  /** Tekst upisan u polje za pretragu. */
  readonly unos = signal('');
  /** Odabrani atribut; prazno = pretraga po svim atributima. */
  readonly odabraniAtribut = signal('');
  /** Prikaz svih 27 stupaca ili samo osnovnih. */
  readonly sviStupci = signal(false);

  // ---- podaci ----
  readonly atributi = signal<Atribut[]>([]);
  readonly redci = signal<ServisRedak[]>([]);
  readonly ucitavanje = signal(false);
  readonly greska = signal<string | null>(null);

  /** Filtar koji je zadnji primijenjen (iz njega se grade i poveznice za preuzimanje). */
  readonly primijenjeniFiltar = signal({ q: '', atribut: '' });

  /** Stupci tablice ovisno o odabranom prikazu. */
  readonly stupci = computed<Atribut[]>(() =>
    this.sviStupci()
      ? this.atributi()
      : OSNOVNI_STUPCI.map((n) => this.atributi().find((a) => a.naziv === n)).filter((a): a is Atribut => !!a),
  );

  /** Upitni dio URL-a s trenutnim filtrom, npr. "?q=golf&atribut=model". */
  private readonly upit = computed(() => {
    const { q, atribut } = this.primijenjeniFiltar();
    const parametri = new URLSearchParams();
    if (q) parametri.set('q', q);
    if (q && atribut) parametri.set('atribut', atribut);
    const s = parametri.toString();
    return s ? '?' + s : '';
  });

  /** Poveznice za preuzimanje trenutnog (filtriranog) prikaza. */
  readonly csvPoveznica = computed(() => '/api/servisi/csv' + this.upit());
  readonly jsonPoveznica = computed(() => '/api/servisi/json' + this.upit());

  /** Za prekid prethodnog zahtjeva ako korisnik pretraži ponovno prije nego stigne odgovor. */
  private kontroler?: AbortController;

  constructor() {
    this.ucitajAtribute();
    // tablica prikazuje sve podatke i prije primjene filtra
    this.dohvati('', '');
  }

  /** Slanje obrasca (gumb "Pretraži" ili Enter u polju za unos). */
  pretrazi(): void {
    this.dohvati(this.unos().trim(), this.odabraniAtribut());
  }

  /** Poništavanje filtra: povratak na početni prikaz svih podataka. */
  ponisti(): void {
    this.unos.set('');
    this.odabraniAtribut.set('');
    this.dohvati('', '');
  }

  /** Vrijednost ćelije za prikaz (null -> crtica, cijena s dvije decimale). */
  vrijednost(r: ServisRedak, stupac: keyof ServisRedak): string {
    const v = r[stupac];
    if (v === null || v === undefined || v === '') return '–';
    if (stupac === 'cijena_eur') return Number(v).toFixed(2);
    return String(v);
  }

  /** Brojčani stupci se poravnavaju udesno. */
  brojcani(stupac: keyof ServisRedak): boolean {
    return ['kilometraza', 'cijena_eur', 'snaga_kw', 'ocjena', 'latitude', 'longitude'].includes(stupac);
  }

  // ------------------------------------------------------------------
  // Asinkroni pozivi prema back-endu (fetch API)
  // ------------------------------------------------------------------

  private async ucitajAtribute(): Promise<void> {
    try {
      const odgovor = await fetch('/api/atributi');
      if (!odgovor.ok) throw new Error(await this.porukaGreske(odgovor));
      this.atributi.set(await odgovor.json());
    } catch (e) {
      this.greska.set(this.tekstGreske(e));
    }
  }

  /** Dohvaća filtrirane podatke iz baze preko back-enda: GET /api/servisi?q=...&atribut=... */
  private async dohvati(q: string, atribut: string): Promise<void> {
    this.kontroler?.abort();
    const kontroler = (this.kontroler = new AbortController());

    this.primijenjeniFiltar.set({ q, atribut });
    this.ucitavanje.set(true);
    this.greska.set(null);

    try {
      const odgovor = await fetch('/api/servisi' + this.upit(), { signal: kontroler.signal });
      if (!odgovor.ok) throw new Error(await this.porukaGreske(odgovor));
      this.redci.set(await odgovor.json());
    } catch (e) {
      if ((e as Error).name === 'AbortError') return; // zamijenjen novijim zahtjevom
      this.redci.set([]);
      this.greska.set(this.tekstGreske(e));
    } finally {
      if (this.kontroler === kontroler) this.ucitavanje.set(false);
    }
  }

  /** Back-end greške vraća kao JSON { status, poruka }. */
  private async porukaGreske(odgovor: Response): Promise<string> {
    try {
      const tijelo = await odgovor.json();
      return tijelo.poruka ?? `Greška ${odgovor.status}`;
    } catch {
      return `Greška ${odgovor.status}`;
    }
  }

  private tekstGreske(e: unknown): string {
    // fetch baca TypeError kad poslužitelj uopće nije dostupan
    if (e instanceof TypeError) {
      return 'Back-end nije dostupan. Provjeri radi li aplikacija na portu 8080.';
    }
    return (e as Error).message;
  }
}
