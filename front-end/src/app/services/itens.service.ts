import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { Item } from '../item';

@Injectable({
  providedIn: 'root'
})
export class ItensService {

  constructor(private http: HttpClient) { }

  getItens(idLista): Observable<Item[]> {
    return this.http.get<Item[]>('http://localhost:8080/itensLista/' + idLista);
  }
}
