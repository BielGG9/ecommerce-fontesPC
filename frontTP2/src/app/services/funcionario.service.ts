import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Funcionario } from "../models/funcionario.model";
import { HttpParams } from '@angular/common/http';
@Injectable({
    providedIn: 'root'
})
export class FuncionarioService {
    private apiUrl = 'http://localhost:8081/funcionarios';

    constructor(private http: HttpClient) { }

    findAll(page: number = 0, pageSize: number = 10, nome: string = ''): Observable<Funcionario[]> {
        let params = new HttpParams()
            .set('page', page.toString())
            .set('pageSize', pageSize.toString());

        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<Funcionario[]>(this.apiUrl, { params });
    }

    count(nome: string = ''): Observable<number> {
        let params = new HttpParams();
        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<number>(`${this.apiUrl}/count`, { params });
    }

    findById(id: number): Observable<Funcionario> {
        return this.http.get<Funcionario>(`${this.apiUrl}/${id}`);
    }

    save(funcionario: Funcionario): Observable<Funcionario> {
        return this.http.post<Funcionario>(this.apiUrl, funcionario);
    }

    update(funcionario: Funcionario): Observable<Funcionario> {
        return this.http.put<Funcionario>(`${this.apiUrl}/${funcionario.id}`, funcionario);
    }

    delete(id: number): Observable<void> {
        return this.http.delete<void>(`${this.apiUrl}/${id}`);
    }
}