import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { Item } from '../item';
import { Produto } from '../produto';

@Injectable({
  providedIn: 'root'
})
export class ItensService {

  constructor(private http: HttpClient) { }

  getItens(idLista): Observable<Item[]> {
    return this.http.get<Item[]>('http://localhost:8080/itensLista/' + idLista);
  }

  getProdutos(idlista): Observable<Produto[]> {
    return this.http.get<Produto[]>('http://localhost:8080/recupera/produto/' + idlista);
  }

  async compartilha(email, listaid) {
    return await this.http.post('http://localhost:8080/cLista/' + listaid + '/' + email, {}).toPromise();
  }

  async alteraLista(nomeListNova, idLista) {
    return await this.http.patch('http://localhost:8080/operacao/nomelista/' + idLista + '/' + nomeListNova, {}).toPromise();
  }

  colocaProdutoLista(vlunitario, qtditem, descricao, listaid, produtoid ): Observable<Item> {
    // tslint:disable-next-line:max-line-length
    const data = '{"vlunitario":' + vlunitario + ', "qtditem":' + qtditem + ', "descricao":"' + descricao + '","listaid":' + listaid + ', "produtoid":' + produtoid + ' }';
    console.log(data);
    return this.http.post<Item>('http://localhost:8080/cadastra/itemProduto', data);
  }
  deleteItem(item): Observable<Item> {
    return this.http.delete<Item>('http://localhost:8080/operacao/item/' + item['listaId'] + '/' + item['produtoId'], {} );
  }
}
