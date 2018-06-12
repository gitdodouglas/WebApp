import { Component, OnInit } from '@angular/core';
import { RegisterService } from '../services/register.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

  isModalActiveSuccess = false;

  constructor(private registerService: RegisterService) { }

  ngOnInit() {
  }

  async register(email, senha, nome) {
    console.log();
    console.log();
    const result = await this.registerService.postCadastro(email, senha, nome);
    console.log(result); // colocar o token no storage
    if(result != null) {
      this.toggleModalSuccess();
    }
  }

  toggleModalSuccess() {
      this.isModalActiveSuccess = !this.isModalActiveSuccess;
  }

}
