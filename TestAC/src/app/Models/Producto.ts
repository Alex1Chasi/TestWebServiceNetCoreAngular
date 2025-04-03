export interface Producto {
    idProducto: number;         
    nombre: string;             
    descripcion: string | null; 
    categoria: string | null;   
    imagen: string | null;      
    precio: number;             
    stock: number;              
}
