import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { Lista } from '../lista';


@Injectable({
  providedIn: 'root'
})
export class ListaService {

  constructor(private http: HttpClient) { }

  getListas(key: string): Observable<Lista[]> {
    return this.http.get<Lista[]>('http://localhost:8080/listasUsuario');
  }

  createLista(nomeLista: string): Observable<Lista> {
    return this.http.post<Lista>('http://localhost:8080/cadastra/lista', { 'nome': nomeLista, 'total': 0.0 });
  }

  getLista(id: number): Observable<Lista> {
    return this.http.get<Lista>('http://localhost:8080/operacao/lista/' + id);
  }

}
