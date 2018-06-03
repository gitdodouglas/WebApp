import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { Compartilhada } from '../compartilhada';


@Injectable({
  providedIn: 'root'
})
export class CompartilhadasService {

  constructor(private http: HttpClient) { }

  getListas(key: string): Observable<Compartilhada[]> {
    const listas = this.http.get<Compartilhada[]>('http://localhost:8080/listasCompart');
    return listas;
  }

}
