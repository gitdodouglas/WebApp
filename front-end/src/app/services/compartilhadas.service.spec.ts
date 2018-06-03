import { TestBed, inject } from '@angular/core/testing';

import { CompartilhadasService } from './compartilhadas.service';

describe('CompartilhadasService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [CompartilhadasService]
    });
  });

  it('should be created', inject([CompartilhadasService], (service: CompartilhadasService) => {
    expect(service).toBeTruthy();
  }));
});
