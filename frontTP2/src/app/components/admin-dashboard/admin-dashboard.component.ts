import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { DashboardService } from '../../services/dashboard.service';
import { ThemeService } from '../../services/theme.service';
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
  private dashboardService = inject(DashboardService);
  private themeService = inject(ThemeService);
  private authSub!: Subscription;

  nomeUsuario: string | null = '';
  estatisticas: any = null;

  // Controle do estado da Sidebar
  isCollapsed = false;
  // Controle de Tema Claro/Escuro
  get isDarkMode() {
    return this.themeService.isDarkMode();
  }

  ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.nomeUsuario = nome;
    });

    // Chamada HTTP comentada temporariamente para fins de apresentação/mock
    /*
    this.dashboardService.getEstatisticas().subscribe({
      next: (dados) => {
        this.estatisticas = dados;
      },
      error: (err) => {
        console.error('Erro ao carregar estatísticas do dashboard:', err);
      }
    });
    */

    // Geração de dados simulados (Mock) com valores aleatórios e realistas
    const randomFontes = Math.floor(Math.random() * (150 - 50 + 1)) + 50;
    const randomMarcas = Math.floor(Math.random() * (30 - 10 + 1)) + 10;
    const randomVendas = Math.floor(Math.random() * (12000 - 3000 + 1)) + 3000;
    const randomClientes = Math.floor(Math.random() * (60 - 15 + 1)) + 15;

    this.estatisticas = {
      totalFontes: randomFontes,
      totalMarcas: randomMarcas,
      vendasMensais: randomVendas,
      novosClientes: randomClientes,
      // Suporte à versão mais recente com chaves de métricas diárias
      vendasDiarias: randomVendas,
      quantidadeVendasDiarias: randomClientes
    };
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
    this.themeService.toggleTheme();
  }
}
