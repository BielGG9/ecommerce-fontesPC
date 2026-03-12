import { Routes } from '@angular/router';
import { MarcaComponent } from './components/marca.component';
import { FonteComponent } from './components/fonte.component';
import { HomeComponent } from './components/home.component';
import { ModeloComponent } from './components/modelo.component';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'marca', component: MarcaComponent },
  { path: 'fontes', component: FonteComponent },
  { path: 'modelos', component: ModeloComponent }
];
