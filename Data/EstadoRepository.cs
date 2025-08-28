using Microsoft.Data.SqlClient;
using webApiCore6.Models;

namespace webApiCore6.Data
{
    public class EstadoRepository
    {

        private readonly string _connectionString;

        public EstadoRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("EmpresaDb");
        }

        public async Task<IEnumerable<Estado>> GetEstados()
        {
            var estados = new List<Estado>();
            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SELECT IdEstado, Nombre FROM Estados", conn))
            {
                await conn.OpenAsync();
                using var reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    estados.Add(new Estado
                    {
                        IdEstado = reader.GetInt32(0),
                        Nombre = reader.GetString(1)
                    });
                }
            }
            return estados;
        }

    }
}
