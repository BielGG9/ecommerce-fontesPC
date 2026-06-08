import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-cadastro-cliente',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './cadastro-cliente.component.html',
  styleUrl: './cadastro-cliente.component.css'
})
export class CadastroClienteComponent {
  nome = '';
  email = '';
  senha = '';
  isLoading = false;

  constructor(private http: HttpClient, private router: Router) {}

  criarContaRapida() {
    this.isLoading = true;
    const payload = { 
      nome: this.nome, 
      email: this.email, 
      senha: this.senha 
    };

    // Aponta para o endpoint do Quarkus
    this.http.post('http://localhost:8080/clientes/cadastro-expresso', payload)
      .subscribe({
        next: (res: any) => {
          // Salva os dados do usuário na sessão (simulando login automático)
          localStorage.setItem('currentUser', JSON.stringify(res));
          
          // Redireciona direto para a vitrine inicial
          this.router.navigate(['/']);
        },
        error: (err) => {
          console.error('Erro no cadastro expresso:', err);
          alert('Erro ao criar conta. Verifique os dados.');
          this.isLoading = false;
        },
        complete: () => {
          this.isLoading = false;
        }
      });
  }
}
