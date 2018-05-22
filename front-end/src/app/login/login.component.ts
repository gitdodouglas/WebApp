import { Component, OnInit } from '@angular/core';
import { LoginService } from '../login.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private loginService: LoginService) { }

  ngOnInit() {
  }

  async login(email, senha) {
    console.log('email: ', email);
    console.log('senha: ', senha);
    const result = await this.loginService.getLogin(email, senha);
    console.log(result);
  }

}
