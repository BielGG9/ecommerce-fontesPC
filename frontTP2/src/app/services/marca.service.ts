import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Marca } from "../models/marca.model";

@Injectable({
    providedIn: 'root'
})
export class MarcaService {
    private apiUrl = 'http://localhost:8081/marca';

    constructor(private http: HttpClient) { }

    findAll(): Observable<Marca[]> {
        return this.http.get<Marca[]>(this.apiUrl);
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