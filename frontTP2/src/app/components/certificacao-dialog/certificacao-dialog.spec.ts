import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CertificacaoDialog } from './certificacao-dialog';

describe('CertificacaoDialog', () => {
  let component: CertificacaoDialog;
  let fixture: ComponentFixture<CertificacaoDialog>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CertificacaoDialog]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CertificacaoDialog);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
