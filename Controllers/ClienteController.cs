using Microsoft.AspNetCore.Mvc;
using webApiCore6.Data;
using webApiCore6.Models;

namespace webApiCore6.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ClienteController : ControllerBase
    {

        private readonly ClienteRepository _repo;

        public ClienteController(ClienteRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Cliente>>> GetClientes()
        {
            var clientes = await _repo.GetClientes();
            return Ok(clientes);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Cliente>> GetCliente(int id)
        {
            var clientes = await _repo.GetClientes(id);
            var cliente = clientes.FirstOrDefault();
            if (cliente == null)
                return NotFound();
            return Ok(cliente);
        }

        [HttpPost]
        public async Task<ActionResult> CrearCliente([FromBody] Cliente cliente)
        {
            var nuevoId = await _repo.InsertarCliente(cliente);
            return CreatedAtAction(nameof(GetCliente), new { id = nuevoId }, cliente);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> ActualizarCliente(int id, [FromBody] Cliente cliente)
        {
            if (id != cliente.IdCliente)
                return BadRequest();
            var mensaje = await _repo.ActualizarCliente(cliente);
            return Ok(new { Mensaje = mensaje });
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> EliminarCliente(int id)
        {
            var mensaje = await _repo.EliminarCliente(id);
            return Ok(new { Mensaje = mensaje });
        }

    }
}
