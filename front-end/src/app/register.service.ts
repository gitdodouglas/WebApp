import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class RegisterService {

  constructor(private http: HttpClient) { }

  async postCadastro(login: string, senha: string, nome: string) {
    return await this.http.post('http://localhost:8080/register', {
      'email': login,
      'senha': senha,
      'nome': nome,
      'token': ''
    }).toPromise();
  }

}
