import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { appsettings } from '../Settings/appsettings';
import { Producto } from '../Models/Producto';
import { ResponseAPI } from '../Models/ResponseAPI';

@Injectable({
  providedIn: 'root'
})
export class ProductoService {
  private http = inject(HttpClient);
  private apiUrl:string = appsettings.apiUrl + "Producto";

  constructor() { }

  lista(){
    return this.http.get<Producto[]>(this.apiUrl);
  }
  obtener(id:number){
    return this.http.get<Producto>(`${this.apiUrl}/${id}`);
  }

  crear(objeto:Producto){
    return this.http.post<ResponseAPI>(this.apiUrl,objeto);
  }

  editar(objeto:Producto){
    return this.http.put<ResponseAPI>(this.apiUrl,objeto);
  }

  eliminar(id:number){
    return this.http.delete<ResponseAPI>(`${this.apiUrl}/${id}`);
  }

}
