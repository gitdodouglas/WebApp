import { Component, OnInit } from '@angular/core';
import { RegisterService } from '../services/register.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

  constructor(private registerService: RegisterService) { }

  ngOnInit() {
  }

  async register(email, senha, nome) {
    console.log();
    console.log();
    const result = await this.registerService.postCadastro(email, senha, nome);
    console.log(result);
  }

}
