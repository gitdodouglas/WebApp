import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CompartilhadasComponent } from './compartilhadas.component';

describe('CompartilhadasComponent', () => {
  let component: CompartilhadasComponent;
  let fixture: ComponentFixture<CompartilhadasComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CompartilhadasComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CompartilhadasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
