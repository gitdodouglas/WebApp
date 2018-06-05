import { NgModule } from '@angular/core';
import { RouterModule, Routes, RouterState } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { MenuComponent } from './menu/menu.component';
import { CompartilhadasComponent } from './compartilhadas/compartilhadas.component';
import { ListasComponent } from './listas/listas.component';
import { ItensComponent } from './itens/itens.component';

const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'menu', component: MenuComponent },
  { path: 'compartilhadas', component: CompartilhadasComponent },
  { path: 'listas', component: ListasComponent },
  { path: 'itens/:id', component: ItensComponent }
];


@NgModule({
  imports: [ RouterModule.forRoot(routes)],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
