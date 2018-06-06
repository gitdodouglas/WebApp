import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

import { ItensService } from '../services/itens.service';
import { ListaService } from '../services/lista.service';
import { Item } from '../item';
import { Lista } from '../lista';

@Component({
  selector: 'app-itens',
  templateUrl: './itens.component.html',
  styleUrls: ['./itens.component.css']
})
export class ItensComponent implements OnInit {

  lista: Lista;
  itens: Item[];
  isModalActiveAdd = false;
  isModalActiveOpcoes = false;
  isModalActiveNome = false;
  isModalActiveShare = false;

  constructor(
    private route: ActivatedRoute,
    private itensService: ItensService,
    private location: Location,
    private listaService: ListaService
  ) { }

  ngOnInit() {
    this.getLista();
    this.getItens();
  }

  getItens(): void {
    const id = +this.route.snapshot.paramMap.get('id');
    this.itensService.getItens(id)
      .subscribe(itens => this.itens = itens['resp']['produtoLista']);
  }

  getLista(): void {
    const id = +this.route.snapshot.paramMap.get('id');
    this.listaService.getLista(id)
      .subscribe(lista => { lista['resp']['id'] = id; this.lista = lista['resp']; });
  }

  toggleModalAdd() {
      this.isModalActiveAdd = !this.isModalActiveAdd;
  }

  toggleModalOpcoes() {
      this.isModalActiveOpcoes = !this.isModalActiveOpcoes;
  }

  toggleModalNome() {
      this.isModalActiveNome = !this.isModalActiveNome;
  }

  toggleModalShare() {
      this.isModalActiveShare = !this.isModalActiveShare;
  }

  locationBack() {
    this.location.back();
  }

}
