import { Component, OnInit, Inject } from '@angular/core';
import { LoginService } from '../services/login.service';
import { WebStorageService, LOCAL_STORAGE } from 'angular-webstorage-service';
import { RouterModule, Router } from '@angular/router';
import { AuthenticationService } from '../services/authentication.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(
    private authentication: AuthenticationService,
    private loginService: LoginService,
    private router: Router ) { }

  ngOnInit() {
    // executar funcao que checa o storage, se tiver token redirecionar para menu principal
  }

  async login(email, senha) {
    console.log('email: ', email);
    console.log('senha: ', senha);
    const result = await this.loginService.getLogin(email, senha);
    console.log(result['resp']);
    this.authentication.saveInLocal('key', result['resp']);
    this.router.navigateByUrl('/listas');
  }


}
