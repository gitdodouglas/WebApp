import { Component, OnInit, Inject } from '@angular/core';
import { LoginService } from '../login.service';
import { WebStorageService, LOCAL_STORAGE } from 'angular-webstorage-service';
import { RouterModule, Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  public data: any = [];

  constructor(
    @Inject(LOCAL_STORAGE) private storage: WebStorageService,
    private loginService: LoginService,
    private router: Router ) { }

  ngOnInit() {
  }

  async login(email, senha) {
    console.log('email: ', email);
    console.log('senha: ', senha);
    const result = await this.loginService.getLogin(email, senha);
    console.log(result['resp']);
    this.saveInLocal('key', result['resp']);
    this.router.navigateByUrl('/menu');
  }

  saveInLocal(key, val): void {
    console.log('recieved= key:' + key + 'value:' + val);
    this.storage.set(key, val);
    this.data[key] = this.storage.get(key);
   }

   getFromLocal(key): void {
    console.log('recieved= key:' + key);
    this.data[key] = this.storage.get(key);
    console.log(this.data);
   }
}
