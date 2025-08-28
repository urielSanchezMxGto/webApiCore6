namespace webApiCore6.Models
{
    public class Cliente
    {

        public int IdCliente { get; set; }
        public string? Nombre { get; set; }
        public string? Direccion { get; set; }
        public string? CodigoPostal { get; set; }
        public string? Ciudad { get; set; }
        public string? Estado { get; set; }
        public int IdCiudad { get; set; }

        public int IdEstado { get; set; }

    }
}
