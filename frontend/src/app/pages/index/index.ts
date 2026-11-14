import { Component, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RouterLink } from '@angular/router';

/** Jedan red u tablici opisa atributa (čita se iz schema.json). */
interface OpisAtributa {
  naziv: string;
  tip: string;
  opis: string;
}

/** Atributi jednog entiteta (servisni centar, automobil ili servis). */
interface Entitet {
  naslov: string;
  opis: string;
  atributi: OpisAtributa[];
}

/** Dio JSON Scheme koji nam treba (samo ključne riječi koje koristimo). */
interface SchemaCvor {
  title?: string;
  description?: string;
  type?: string | string[];
  format?: string;
  enum?: (string | null)[];
  properties?: Record<string, SchemaCvor>;
  items?: SchemaCvor;
}

@Component({
  selector: 'app-index',
  imports: [RouterLink],
  templateUrl: './index.html',
  styleUrl: './index.css',
})
export class IndexPage {
  private readonly http = inject(HttpClient);

  /** Metapodaci skupa (isti kao u README.md). */
  readonly metapodaci: [string, string][] = [
    ['Naziv skupa', 'Auto servisi u Hrvatskoj'],
    ['Autor', 'Matej Šest'],
    ['Licencija', 'Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0)'],
    ['Verzija', '2.0'],
    ['Datum objave', '2026-11-14'],
    ['Jezik podataka', 'hrvatski'],
    ['Formati', 'CSV, JSON'],
    ['Shema podataka', 'JSON Schema (draft-07), datoteka schema.json'],
    ['Kodiranje znakova', 'UTF-8'],
    ['Broj servisnih centara', '10'],
    ['Broj automobila', '20'],
    ['Broj servisa', '37'],
    ['Broj atributa', '27 (12 za servisni centar, 8 za automobil, 7 za servis)'],
    ['Geografska pokrivenost', 'Republika Hrvatska (Zagreb, Split, Rijeka, Osijek, Zadar, Varaždin, Pula, Slavonski Brod)'],
    ['Vremenska pokrivenost', 'servisi obavljeni od rujna 2025. do listopada 2026.'],
    ['Izvor podataka', 'izmišljeni podaci, uneseni ručno'],
    ['Baza podataka', 'PostgreSQL 18'],
    ['Ključne riječi', 'automobili, auto servis, servisni centar, vozila, održavanje vozila, Hrvatska'],
  ];

  /** Primjer strukture JSON datoteke. */
  readonly primjerJson = `[
  {
    "id": 1,
    "naziv": "Auto Centar Horvat",
    "grad": "Zagreb",
    ...
    "automobili": [
      {
        "id": 1,
        "registracija": "ZG-1234-AB",
        "marka": "Volkswagen",
        "model": "Golf",
        ...
        "servisi": [
          { "id": 1, "datum": "2025-09-10", "vrsta_usluge": "veliki servis", ... },
          { "id": 2, "datum": "2026-09-14", "vrsta_usluge": "mali servis", ... }
        ]
      }
    ]
  }
]`;

  /** Opisi atributa učitani iz schema.json (strojno čitljivih metapodataka). */
  readonly entiteti = signal<Entitet[]>([]);
  readonly greskaSheme = signal<string | null>(null);

  constructor() {
    this.http.get<SchemaCvor>('/data/schema.json').subscribe({
      next: (shema) => this.entiteti.set(this.izShema(shema)),
      error: () =>
        this.greskaSheme.set(
          'Opis atributa nije moguće učitati. Provjeri radi li back-end na portu 8080 i postoji li datoteka schema.json.',
        ),
    });
  }

  /** Iz JSON Scheme izvlači opise atributa za sve tri razine: centar -> automobil -> servis. */
  private izShema(shema: SchemaCvor): Entitet[] {
    const centar = shema.items!;
    const automobil = centar.properties!['automobili'].items!;
    const servis = automobil.properties!['servisi'].items!;

    return [centar, automobil, servis].map((cvor) => ({
      naslov: cvor.title ?? '',
      opis: cvor.description ?? '',
      atributi: Object.entries(cvor.properties ?? {})
        // ugniježđena polja (automobili, servisi) nisu atributi nego veze
        .filter(([, p]) => !this.tipovi(p).includes('array'))
        .map(([naziv, p]) => ({ naziv, tip: this.opisTipa(p), opis: p.description ?? '' })),
    }));
  }

  private tipovi(p: SchemaCvor): string[] {
    return Array.isArray(p.type) ? p.type : p.type ? [p.type] : [];
  }

  private opisTipa(p: SchemaCvor): string {
    const tipovi = this.tipovi(p);
    const glavni = tipovi.find((t) => t !== 'null');
    let tekst =
      p.format === 'date'
        ? 'datum'
        : glavni === 'integer'
          ? 'cijeli broj'
          : glavni === 'number'
            ? 'decimalni broj'
            : 'tekst';

    if (p.enum) {
      tekst += ': ' + p.enum.filter((v) => v !== null).join(', ');
    }
    if (tipovi.includes('null')) {
      tekst += ' (može biti prazno)';
    }
    return tekst;
  }
}
