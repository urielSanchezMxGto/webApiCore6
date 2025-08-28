using Microsoft.Data.SqlClient;
using System.Data;
using webApiCore6.Models;

namespace webApiCore6.Data
{
    public class ClienteRepository
    {

        private readonly string _connectionString;

        public ClienteRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("EmpresaDb");
        }

        public async Task<IEnumerable<Cliente>> GetClientes(int? id = null)
        {
            var clientes = new List<Cliente>();
            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("sp_CRUD_Clientes", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Accion", "SELECT");
                cmd.Parameters.AddWithValue("@IdCliente", (object?)id ?? DBNull.Value);
                await conn.OpenAsync();
                using var reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    clientes.Add(new Cliente
                    {
                        IdCliente = reader.GetInt32(reader.GetOrdinal("IdCliente")),
                        Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                        Direccion = reader["Direccion"].ToString(),
                        CodigoPostal = reader["CodigoPostal"].ToString(),
                        Ciudad = reader["Ciudad"].ToString(),
                        Estado = reader["Estado"].ToString(),
                        IdCiudad = reader.GetInt32(reader.GetOrdinal("IdCiudad")),
                        IdEstado = reader.GetInt32(reader.GetOrdinal("IdEstado"))
                    });
                }
            }
            return clientes;
        }

        public async Task<int> InsertarCliente(Cliente cliente)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_CRUD_Clientes", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Accion", "INSERT");
            cmd.Parameters.AddWithValue("@Nombre", cliente.Nombre);
            cmd.Parameters.AddWithValue("@Direccion", cliente.Direccion ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@CodigoPostal", cliente.CodigoPostal ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdCiudad", cliente.IdCiudad);
            await conn.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(result);
        }

        public async Task<string> ActualizarCliente(Cliente cliente)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_CRUD_Clientes", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Accion", "UPDATE");
            cmd.Parameters.AddWithValue("@IdCliente", cliente.IdCliente);
            cmd.Parameters.AddWithValue("@Nombre", cliente.Nombre);
            cmd.Parameters.AddWithValue("@Direccion", cliente.Direccion ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@CodigoPostal", cliente.CodigoPostal ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdCiudad", cliente.IdCiudad);
            await conn.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result?.ToString() ?? "Actualización realizada";
        }

        public async Task<string> EliminarCliente(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_CRUD_Clientes", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Accion", "DELETE");
            cmd.Parameters.AddWithValue("@IdCliente", id);
            await conn.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result?.ToString() ?? "Eliminación realizada";
        }

    }
}
