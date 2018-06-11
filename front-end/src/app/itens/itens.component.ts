import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

import { ItensService } from '../services/itens.service';
import { ListaService } from '../services/lista.service';
import { Item } from '../item';
import { Lista } from '../lista';
import { Produto } from '../produto';
import { OrderPipe } from 'ngx-order-pipe';


@Component({
  selector: 'app-itens',
  templateUrl: './itens.component.html',
  styleUrls: ['./itens.component.css']
})
export class ItensComponent implements OnInit {

  lista: Lista;
  itens: Item[];
  produtos: Produto[];
  isModalActiveAdd = false;
  isModalActiveOpcoes = false;
  isModalActiveNome = false;
  isModalActiveShare = false;
  idProduto: number;
  order = 'nome';
  reverse = false;

  constructor(
    private route: ActivatedRoute,
    private itensService: ItensService,
    private location: Location,
    private listaService: ListaService,
    private orderPipe: OrderPipe
  ) { }

  ngOnInit() {
    this.getLista();
    this.getItens();
    // this.getProdutos();
  }

  getItens(): void {
    const id = +this.route.snapshot.paramMap.get('id');
    this.itensService.getItens(id)
      .subscribe(itens => {console.log(itens); this.itens = itens['resp']['produtoLista']; });
  }

  getLista(): void {
    const id = +this.route.snapshot.paramMap.get('id');
    this.listaService.getLista(id)
      .subscribe(lista => { lista['resp']['id'] = id; this.lista = lista['resp']; });
  }

  getProdutos(): void {
    const idLista = document.querySelector('#idLista').textContent;
    console.log(idLista);
    this.itensService.getProdutos(idLista)
      .subscribe(produtos => {console.log(produtos); this.produtos = produtos['resp']; });
  }

  pegaId(idProduto): void {
    this.idProduto = idProduto;
  }

  adicionaProduto(qtd, vl, desc) {
    const idLista = document.querySelector('#idLista').textContent;
    this.itensService.colocaProdutoLista(vl, qtd, desc, idLista, this.idProduto)
      .subscribe(produtoNovo => {console.log(produtoNovo); this.itens.push(produtoNovo['resp'][0]); });
    this.toggleModalAdd();
  }

  removeItem(item: Item): void {
    console.log(item);
    this.itens = this.itens.filter(i => i !== item);
    this.itensService.deleteItem(item).subscribe(); // arrumar o JSON para encaixar certo na classe ITEM
  }

  async compartilharLista(email) {
    const idLista = document.querySelector('#idLista').textContent;
    const result = await this.itensService.compartilha(email, idLista);
    alert(result['resp']);
    this.toggleModalShare();
  }


  async alterarLista(nomeNovaLista) {
    const idLista = document.querySelector('#idLista').textContent;
    const result = await this.itensService.alteraLista(nomeNovaLista, idLista);
    alert(result['resp']);
    this.toggleModalNome();
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

  setOrder(value: string) {
    if (this.order === value) {
      this.reverse = !this.reverse;
    }
    this.order = value;
  }

  getTotal() {
    let total = 0;
    this.itens.forEach((item) => {
      total += item.vlunitario * item.qtditem;
    });
    return total;
  }

}
