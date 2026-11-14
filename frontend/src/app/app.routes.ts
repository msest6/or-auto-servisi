import { Routes } from '@angular/router';
import { IndexPage } from './pages/index/index';
import { DatatablePage } from './pages/datatable/datatable';

export const routes: Routes = [
  // Početna stranica (pages/index/index.html)
  { path: '', component: IndexPage, title: 'Auto servisi u Hrvatskoj' },
  // Tablica s filtriranjem (pages/datatable/datatable.html)
  { path: 'datatable', component: DatatablePage, title: 'Tablica podataka | Auto servisi u Hrvatskoj' },
  { path: '**', redirectTo: '' },
];
