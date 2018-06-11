import { Component, OnInit } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { AuthenticationService } from '../services/authentication.service'; // colocar em todos os compornentes
import { LoginService } from '../services/login.service';
import { CompartilhadasService } from '../services/compartilhadas.service';
import { Compartilhada } from '../compartilhada';
import { OrderPipe } from 'ngx-order-pipe';

@Component({
  selector: 'app-compartilhadas',
  templateUrl: './compartilhadas.component.html',
  styleUrls: ['./compartilhadas.component.css']
})
export class CompartilhadasComponent implements OnInit {

  listas: Compartilhada[];
  isModalActiveOpcoes = false;
  order = 'nome';
  reverse = false;

  constructor(private authentication: AuthenticationService,
              private compartilhadasService: CompartilhadasService,
              private orderPipe: OrderPipe,
              private router: Router,
              private loginService: LoginService
  ) { }

  ngOnInit() {
    this.authentication.checkStorage(); // usar essa fucao para checar se esta logado em todos os componentes
    this.getListas();
  }

  getListas(): void {
    this.compartilhadasService.getListas(this.authentication.getFromLocal('key'))
      .subscribe(listaas => {console.log(listaas['resp']); this.listas = listaas['resp']; });
  }

  toggleModalOpcoes() {
      this.isModalActiveOpcoes = !this.isModalActiveOpcoes;
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
