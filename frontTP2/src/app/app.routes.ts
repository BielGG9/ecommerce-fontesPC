import { Routes } from '@angular/router';
import { MarcaComponent } from './components/marca.component';
import { FonteComponent } from './components/fonte.component';
import { HomeComponent } from './components/home.component';
import { ModeloComponent } from './components/modelo.component';
import { DepartamentoComponent } from './components/departamento.component';
import { FuncionarioComponent } from './components/funcionario.component';
import { FornecedorComponent } from './components/fornecedor.component';
import { CadastroClienteComponent } from './components/cadastro-cliente.component';
import { LoginComponent } from './components/login.component';
import { RecuperarSenhaComponent } from './components/recuperar-senha.component';
import { PedidoComponent } from './components/pedido/pedido.component';
import { AdminDashboardComponent } from './components/admin-dashboard/admin-dashboard.component';
import { AuthService } from './services/auth.service';
import { canActivateAuthRole, canActivateUser } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'login', component: LoginComponent },
  { path: 'marca', component: MarcaComponent, canActivate: [canActivateAuthRole] },
  { path: 'fontes', component: FonteComponent, canActivate: [canActivateAuthRole] },
  { path: 'modelos', component: ModeloComponent, canActivate: [canActivateAuthRole] },
  { path: 'home', component: HomeComponent },
  { path: 'funcionarios', component: FuncionarioComponent, canActivate: [canActivateAuthRole] },
  { path: 'departamentos', component: DepartamentoComponent, canActivate: [canActivateAuthRole] }, 
  { path: 'fornecedores', component: FornecedorComponent, canActivate: [canActivateAuthRole] },
  { path: 'cadastro-cliente', component: CadastroClienteComponent },
  { path: 'recuperar-senha', component: RecuperarSenhaComponent },
  { path: 'admin', component: AdminDashboardComponent, canActivate: [canActivateAuthRole] },
  { path: 'admin/pedidos', component: PedidoComponent, canActivate: [canActivateAuthRole]},
  { path: 'carrinho', loadComponent: () => import('./components/carrinho/carrinho.component').then(c => c.CarrinhoComponent) },
  { path: 'checkout', loadComponent: () => import('./components/checkout/checkout.component').then(c => c.CheckoutComponent), canActivate: [canActivateUser] },
  { path: 'minha-conta', loadComponent: () => import('./components/perfil/perfil.component').then(c => c.PerfilComponent), canActivate: [canActivateUser] },
  
  // Rotas filhas da Minha Conta
  { path: 'minha-conta/meus-dados', loadComponent: () => import('./components/perfil/dados/dados.component').then(c => c.DadosComponent), canActivate: [canActivateUser] },
  { path: 'minha-conta/telefones', loadComponent: () => import('./components/perfil/telefones/telefones.component').then(c => c.TelefonesComponent), canActivate: [canActivateUser] },
  { path: 'minha-conta/enderecos', loadComponent: () => import('./components/perfil/enderecos/enderecos.component').then(c => c.EnderecosComponent), canActivate: [canActivateUser] },
  { path: 'minha-conta/cartoes', loadComponent: () => import('./components/perfil/cartoes/cartoes.component').then(c => c.CartoesComponent), canActivate: [canActivateUser] },
  
  // Rotas não implementadas ainda
  { path: 'minha-conta/pedidos', loadComponent: () => import('./components/perfil/perfil.component').then(c => c.PerfilComponent), canActivate: [canActivateUser] },
  { path: 'minha-conta/favoritos', loadComponent: () => import('./components/perfil/perfil.component').then(c => c.PerfilComponent), canActivate: [canActivateUser] }
];
