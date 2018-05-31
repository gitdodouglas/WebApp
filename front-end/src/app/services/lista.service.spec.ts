import { TestBed, inject } from '@angular/core/testing';

import { ListaService } from './lista.service';

describe('ListaService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ListaService]
    });
  });

  it('should be created', inject([ListaService], (service: ListaService) => {
    expect(service).toBeTruthy();
  }));
});
