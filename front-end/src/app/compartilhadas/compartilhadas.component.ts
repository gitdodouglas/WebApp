import { Component, OnInit } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { AuthenticationService } from '../services/authentication.service'; // colocar em todos os compornentes
import { CompartilhadasService } from '../services/compartilhadas.service';
import { Compartilhada } from '../compartilhada';

@Component({
  selector: 'app-compartilhadas',
  templateUrl: './compartilhadas.component.html',
  styleUrls: ['./compartilhadas.component.css']
})
export class CompartilhadasComponent implements OnInit {

  listas: Compartilhada[];

  constructor(private authentication: AuthenticationService,
              private compartilhadasService: CompartilhadasService
  ) { }

  ngOnInit() {
    this.authentication.checkStorage(); // usar essa fucao para checar se esta logado em todos os componentes
    this.getListas();
  }

  getListas(): void {
    this.compartilhadasService.getListas(this.authentication.getFromLocal('key'))
      .subscribe(listaas => {console.log(listaas['resp']); this.listas = listaas['resp']; });

  }

}
