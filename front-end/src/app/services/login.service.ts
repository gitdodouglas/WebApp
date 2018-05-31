import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient) { }

  async getLogin(login: string, senha: string) {
    // console.log('https://reqres.in/api/login');
    // return await this.http.post('https://reqres.in/api/login', { 'email': login, 'password': senha }).toPromise();
    return await this.http.post('http://localhost:8080/login', [ login, senha ]).toPromise();
  }

  async logout(key: string) {
    const deslogado = await this.http.post('http://localhost:8080/logout', { key } ).toPromise();
    // se deslogou entao redirecionar pro login
  }


}
