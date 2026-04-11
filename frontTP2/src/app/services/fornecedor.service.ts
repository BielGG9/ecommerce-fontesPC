import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Fornecedor } from "../models/fornecedor.model";
import { HttpParams } from '@angular/common/http';
@Injectable({
    providedIn: 'root'
})
export class FornecedorService {
    private apiUrl = 'http://localhost:8081/fornecedores';

    constructor(private http: HttpClient) { }

    findAll(page: number = 0, pageSize: number = 10, nome: string = ''): Observable<Fornecedor[]> {
        let params = new HttpParams()
            .set('page', page.toString())
            .set('pageSize', pageSize.toString());

        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<Fornecedor[]>(this.apiUrl, { params });
    }

    count(nome: string = ''): Observable<number> {
        let params = new HttpParams();
        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<number>(`${this.apiUrl}/count`, { params });
    }

    findById(id: number): Observable<Fornecedor> {
        return this.http.get<Fornecedor>(`${this.apiUrl}/${id}`);
    }

    save(fornecedor: Fornecedor): Observable<Fornecedor> {
        return this.http.post<Fornecedor>(this.apiUrl, fornecedor);
    }

    update(fornecedor: Fornecedor): Observable<Fornecedor> {
        return this.http.put<Fornecedor>(`${this.apiUrl}/${fornecedor.id}`, fornecedor);
    }

    delete(id: number): Observable<void> {
        return this.http.delete<void>(`${this.apiUrl}/${id}`);
    }
}