namespace WebAPIAC.Models
{
    public class Producto
    {
        public int IdProducto { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
        public string? Categoria { get; set; }
        public string? Imagen { get; set; } 
        public decimal Precio { get; set; }
        public int Stock { get; set; } = 0;
    }
}
