import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Marca } from "../models/marca.model";
import { HttpParams } from '@angular/common/http';
@Injectable({
    providedIn: 'root'
})
export class MarcaService {
    private apiUrl = 'http://localhost:8081/marca';

    constructor(private http: HttpClient) { }

    findAll(page: number = 0, pageSize: number = 10, nome: string = ''): Observable<Marca[]> {
        let params = new HttpParams()
            .set('page', page.toString())
            .set('pageSize', pageSize.toString());

        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<Marca[]>(this.apiUrl, { params });
    }

    count(nome: string = ''): Observable<number> {
        let params = new HttpParams();
        if (nome) {
            params = params.set('nome', nome);
        }
        return this.http.get<number>(`${this.apiUrl}/count`, { params });
    }

    findById(id: number): Observable<Marca> {
        return this.http.get<Marca>(`${this.apiUrl}/${id}`);
    }

    save(marca: Marca): Observable<Marca> {
        return this.http.post<Marca>(this.apiUrl, marca);
    }

    update(marca: Marca): Observable<Marca> {
        return this.http.put<Marca>(`${this.apiUrl}/${marca.id}`, marca);
    }

    delete(id: number): Observable<void> {
        return this.http.delete<void>(`${this.apiUrl}/${id}`);
    }
}