using Microsoft.Data.SqlClient;
using webApiCore6.Models;

namespace webApiCore6.Data
{
    public class CiudadRepository
    {

        private readonly string _connectionString;

        public CiudadRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("EmpresaDb");
        }

        public async Task<IEnumerable<Ciudad>> GetCiudadesByEstado(int idEstado)
        {
            var ciudades = new List<Ciudad>();
            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SELECT IdCiudad, Nombre, IdEstado FROM Ciudades WHERE IdEstado = @IdEstado", conn))
            {
                cmd.Parameters.AddWithValue("@IdEstado", idEstado);
                await conn.OpenAsync();
                using var reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    ciudades.Add(new Ciudad
                    {
                        IdCiudad = reader.GetInt32(0),
                        Nombre = reader.GetString(1),
                        IdEstado = reader.GetInt32(2)
                    });
                }
            }
            return ciudades;
        }

    }
}
