import { Component, OnInit, Inject, Injectable } from '@angular/core';
import { WebStorageService, LOCAL_STORAGE } from 'angular-webstorage-service';
import { RouterModule, Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  public data: any = [];

  constructor(
    @Inject(LOCAL_STORAGE) private storage: WebStorageService,
    private router: Router) { }

  saveInLocal(key, val): void {
    console.log('recieved= key:' + key + 'value:' + val);
    this.storage.set(key, val);
    this.data[key] = this.storage.get(key);
   }

   getFromLocal(key): string {
    console.log('recieved= key:' + key);
    return this.storage.get(key);
   }

   checkStorage(): void {
    if ((this.getFromLocal('key')) === '') {
      this.router.navigateByUrl('/login');
    }
   }

}
