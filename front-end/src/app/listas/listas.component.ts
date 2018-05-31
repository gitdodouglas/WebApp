import { Component, OnInit } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { AuthenticationService } from '../services/authentication.service'; // colocar em todos os compornentes
import { ListaService } from '../services/lista.service';
import { Lista } from '../lista';

@Component({
  selector: 'app-listas',
  templateUrl: './listas.component.html',
  styleUrls: ['./listas.component.css']
})
export class ListasComponent implements OnInit {

  listas: Lista[];

  constructor(private authentication: AuthenticationService,
              private listaService: ListaService
  ) { }

  ngOnInit() {
    this.authentication.checkStorage(); // usar essa fucao para checar se esta logado em todos os componentes
    this.getListas();
  }

  getListas(): void {
    this.listaService.getListas(this.authentication.getFromLocal('key'))
      .subscribe(listaas => {console.log(listaas['resp']); this.listas = listaas['resp']; });

  }

}
