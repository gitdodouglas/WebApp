import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor() { }

  getLogin(login: string, senha: string) {
    // return this.http.post<any>('api url',{username:login,password:senha})
  }

}
