import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { PedidoService } from '../../services/pedido.service';
import { Pedido } from '../../models/pedido.model';
import { DialogService } from '../../services/dialog.service';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ThemeService } from '../../services/theme.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-pedido',
  standalone: true,
  imports: [
    CommonModule,
    MatTableModule,
    MatButtonModule,
    MatIconModule,
    MatCardModule,
    RouterModule
  ],
  templateUrl: './pedido.component.html',
  styleUrls: ['./pedido.component.css']
})
export class PedidoComponent implements OnInit, OnDestroy {
  private pedidoService = inject(PedidoService);
  private dialogService = inject(DialogService);
  private router = inject(Router);
  private authService = inject(AuthService);
  private themeService = inject(ThemeService);
  private authSub!: Subscription;

  nomeUsuario: string | null = '';
  isCollapsed = false;
  get isDarkMode() {
    return this.themeService.isDarkMode();
  }

  menuItems = [
    {
      name: 'Dashboard',
      route: '/admin',
      icon: 'bi bi-speedometer2',
      description: 'Visão geral do sistema e relatórios rápidos.'
    },
    {
      name: 'Fontes',
      route: '/admin/fontes',
      icon: 'bi bi-pc-display',
      description: 'Gerencie o estoque e especificações técnicas de fontes.'
    },
    {
      name: 'Marcas',
      route: '/admin/marca',
      icon: 'bi bi-patch-check',
      description: 'Administre as marcas fabricantes de fontes.'
    },
    {
      name: 'Modelos',
      route: '/admin/modelos',
      icon: 'bi bi-cpu',
      description: 'Configure os modelos e linhas de produtos.'
    },
    {
      name: 'Fornecedores',
      route: '/admin/fornecedores',
      icon: 'bi bi-truck',
      description: 'Gerencie os fornecedores de produtos e estoque.'
    },
    {
      name: 'Funcionários',
      route: '/admin/funcionarios',
      icon: 'bi bi-person-badge',
      description: 'Gerencie a equipe e acessos ao sistema.'
    },
    {
      name: 'Departamentos',
      route: '/admin/departamentos',
      icon: 'bi bi-building',
      description: 'Organize os departamentos da empresa.'
    },
    {
      name: 'Pedidos',
      route: '/admin/pedidos',
      icon: 'bi bi-cart-check',
      description: 'Acompanhe e gerencie os pedidos dos clientes.'
    }
  ];

  toggleSidebar() {
    this.isCollapsed = !this.isCollapsed;
  }

  toggleTheme() {
    this.themeService.toggleTheme();
  }

  sair() {
    this.authService.limparSessao();
    this.router.navigate(['/login']);
  }

  pedidos: Pedido[] = [];
  colunasExibidas: string[] = ['id', 'dataHora', 'cliente', 'valorTotal', 'acoes'];

  ngOnInit(): void {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.nomeUsuario = nome;
    });
    this.carregarPedidos();
  }

  ngOnDestroy(): void {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  carregarPedidos(): void {
    this.pedidoService.findAll().subscribe({
      next: (dados) => {
        this.pedidos = dados;
      },
      error: (err) => {
        console.error('Erro ao carregar os pedidos', err);
      }
    });
  }

  excluirPedido(id: number | undefined): void {
    if (id && confirm('Tem certeza que deseja apagar este pedido? Todos os itens dele serão apagados também (Composição)!')) {
      this.pedidoService.delete(id).subscribe({
        next: () => {
          this.carregarPedidos(); // Recarrega a tabela após apagar
        },
        error: (err) => {
          console.error('Erro ao excluir pedido', err);
        }
      });
    }
  }

  verItens(pedido: Pedido): void {
    // Para já, vamos apenas mostrar um alerta com a quantidade de itens.
    // Depois podemos criar um modal (Dialog) bonito para listar os itens!
    this.dialogService.showInfo(`Este pedido possui ${pedido.itens?.length || 0} itens. O valor total é R$ ${pedido.valorTotal}`, 'Detalhes do Pedido');
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}