import { Component, OnInit } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { AuthenticationService } from '../authentication.service'; // colocar em todos os compornentes

@Component({
  selector: 'app-listas',
  templateUrl: './listas.component.html',
  styleUrls: ['./listas.component.css']
})
export class ListasComponent implements OnInit {

  constructor(private authentication: AuthenticationService) { }

  ngOnInit() {
    this.authentication.checkStorage(); // usar essa fucao para checar se esta logado em todos os componentes
  }

}
