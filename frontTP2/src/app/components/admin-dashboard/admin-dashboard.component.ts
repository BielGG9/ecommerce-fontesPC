import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.css']
})
export class AdminDashboardComponent implements OnInit, OnDestroy {
  private router = inject(Router);
  private authService = inject(AuthService);
  private authSub!: Subscription;

  nomeUsuario: string | null = '';

  // Controle do estado da Sidebar
  isCollapsed = false;
  // Controle de Tema Claro/Escuro
  isDarkMode = false;

  ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.nomeUsuario = nome;
    });
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  sair() {
    this.authService.limparSessao();
    this.router.navigate(['/login']);
  }

  // Organização do menu em um array para facilitar a manutenção
  menuItems = [
    {
      name: 'Dashboard',
      route: '/admin',
      icon: 'bi bi-speedometer2',
      description: 'Visão geral do sistema e relatórios rápidos.'
    },
    {
      name: 'Fontes',
      route: '/fontes',
      icon: 'bi bi-pc-display',
      description: 'Gerencie o estoque e especificações técnicas de fontes.'
    },
    {
      name: 'Marcas',
      route: '/marca',
      icon: 'bi bi-patch-check',
      description: 'Administre as marcas fabricantes de fontes.'
    },
    {
      name: 'Modelos',
      route: '/modelos',
      icon: 'bi bi-cpu',
      description: 'Configure os modelos e linhas de produtos.'
    },
    {
      name: 'Fornecedores',
      route: '/fornecedores',
      icon: 'bi bi-truck',
      description: 'Gerencie os fornecedores de produtos e estoque.'
    },
    {
      name: 'Funcionários',
      route: '/funcionarios',
      icon: 'bi bi-person-badge',
      description: 'Gerencie a equipe e acessos ao sistema.'
    },
    {
      name: 'Departamentos',
      route: '/departamentos',
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

  // Dados para os cards de resumo estatístico do topo
  stats = [
    { title: 'Total Fontes', value: '1.245', icon: 'bi bi-lightning-charge', colorClass: 'text-primary', bgColor: 'bg-primary-subtle' },
    { title: 'Marcas', value: '38', icon: 'bi bi-tags', colorClass: 'text-success', bgColor: 'bg-success-subtle' },
    { title: 'Vendas Mensais', value: 'R$ 45.200', icon: 'bi bi-graph-up-arrow', colorClass: 'text-warning', bgColor: 'bg-warning-subtle' },
    { title: 'Novos Clientes', value: '156', icon: 'bi bi-people', colorClass: 'text-info', bgColor: 'bg-info-subtle' }
  ];

  // Alterna a sidebar entre expandida e colapsada
  toggleSidebar() {
    this.isCollapsed = !this.isCollapsed;
  }

  // Alterna entre tema claro e escuro
  toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
  }
}
