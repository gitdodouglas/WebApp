import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './/app-routing.module';
import { LoginComponent } from './login/login.component';
import { HttpClientModule } from '@angular/common/http';
import { RegisterComponent } from './register/register.component';
import { MenuComponent } from './menu/menu.component';
import { ListasComponent } from './listas/listas.component';
import { CompartilhadasComponent } from './compartilhadas/compartilhadas.component';
import { StorageServiceModule } from 'angular-webstorage-service';
import { Interceptor } from './interceptor.module';
import { ItensComponent } from './itens/itens.component';
import { OrderModule } from 'ngx-order-pipe';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterComponent,
    MenuComponent,
    ListasComponent,
    CompartilhadasComponent,
    ItensComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    AppRoutingModule,
    StorageServiceModule,
    Interceptor,
    OrderModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
