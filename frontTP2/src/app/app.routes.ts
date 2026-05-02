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
import { canActivateAuthRole } from './guards/auth.guard';

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
];
