import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Departamento } from "../models/departamento.model";
import { HttpParams } from '@angular/common/http';
@Injectable({
    providedIn: 'root'
})
export class DepartamentoService {
    private apiUrl = 'http://localhost:8081/departamentos';

    constructor(private http: HttpClient) { }

    findAll(page: number = 0, pageSize: number = 10, nome: string = ''): Observable<Departamento[]> {
        let params = new HttpParams()
            .set('page', page.toString())
            .set('pageSize', pageSize.toString());

        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<Departamento[]>(this.apiUrl, { params });
    }

    count(nome: string = ''): Observable<number> {
        let params = new HttpParams();
        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<number>(`${this.apiUrl}/count`, { params });
    }

    findById(id: number): Observable<Departamento> {
        return this.http.get<Departamento>(`${this.apiUrl}/${id}`);
    }

    save(departamento: Departamento): Observable<Departamento> {
        return this.http.post<Departamento>(this.apiUrl, departamento);
    }

    update(departamento: Departamento): Observable<Departamento> {
        return this.http.put<Departamento>(`${this.apiUrl}/${departamento.id}`, departamento);
    }

    delete(id: number): Observable<void> {
        return this.http.delete<void>(`${this.apiUrl}/${id}`);
    }
}