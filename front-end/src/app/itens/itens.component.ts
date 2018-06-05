import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

import { ItensService } from '../services/itens.service';
import { Item } from '../item';

@Component({
  selector: 'app-itens',
  templateUrl: './itens.component.html',
  styleUrls: ['./itens.component.css']
})
export class ItensComponent implements OnInit {

  itens: Item[];

  constructor(
    private route: ActivatedRoute,
    private itensService: ItensService,
    private location: Location
  ) { }

  ngOnInit() {
    this.getItens();
  }

  getItens(): void {
    const id = +this.route.snapshot.paramMap.get('id');
    this.itensService.getItens(id)
      .subscribe(itens => this.itens = itens['resp']['produtoLista']);
  }

}
