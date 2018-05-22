import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient) { }

  async getLogin(login: string, senha: string) {
    return await this.http.post('http://localhost:8080/login', [ login, senha ]).toPromise();
  }
}
