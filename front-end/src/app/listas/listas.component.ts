import { Component, OnInit } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { AuthenticationService } from '../services/authentication.service'; // colocar em todos os compornentes
import { ListaService } from '../services/lista.service';
import { LoginService } from '../services/login.service';
import { Lista } from '../lista';
import { OrderPipe } from 'ngx-order-pipe';

@Component({
  selector: 'app-listas',
  templateUrl: './listas.component.html',
  styleUrls: ['./listas.component.css']
})
export class ListasComponent implements OnInit {

  listas: Lista[];
  isModalActiveAdd = false;
  isModalActiveOpcoes = false;
  order = 'nome';
  reverse = false;

  constructor(private authentication: AuthenticationService,
              private listaService: ListaService,
              private orderPipe: OrderPipe,
              private router: Router,
              private loginService: LoginService
  ) { }

  ngOnInit() {
    this.authentication.checkStorage(); // usar essa fucao para checar se esta logado em todos os componentes
    this.getListas();
  }

  getListas(): void {
    this.listaService.getListas(this.authentication.getFromLocal('key'))
      .subscribe(listaas => {console.log(listaas['resp']); this.listas = listaas['resp']; });
  }

  toggleModalAdd() {
      this.isModalActiveAdd = !this.isModalActiveAdd;
  }

  toggleModalOpcoes() {
      this.isModalActiveOpcoes = !this.isModalActiveOpcoes;
  }

  salvarLista(nomeLista) {
    // validar
    this.listaService.createLista(nomeLista.trim())
      .subscribe(lista => { console.log(lista); this.listas.push(lista); this.router.navigate(['/itens/' + lista.id]); });
    this.toggleModalAdd();
  }

  logout() {
    const token = this.authentication.getFromLocal('key');
    this.loginService.logout(token);
    this.router.navigate(['']);
  }

  setOrder(value: string) {
    if (this.order === value) {
      this.reverse = !this.reverse;
    }
    this.order = value;
  }

}
