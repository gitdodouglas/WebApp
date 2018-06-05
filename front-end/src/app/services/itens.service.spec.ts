import { TestBed, inject } from '@angular/core/testing';

import { ItensService } from './itens.service';

describe('ItensService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ItensService]
    });
  });

  it('should be created', inject([ItensService], (service: ItensService) => {
    expect(service).toBeTruthy();
  }));
});
