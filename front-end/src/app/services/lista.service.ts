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
    const listas = this.http.get<Lista[]>('http://localhost:8080/listasUsuario/' + key);
    return listas;
  //  return LISTAS;
  }

/*
   getListas(key: string) {
    const aaa = this.http.get<Lista[]>('http://localhost:8080/listasUsuario/' + key).toPromise();
    console.log(aaa);
    return aaa;
  }
*/

}
