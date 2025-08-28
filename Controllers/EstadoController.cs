using Microsoft.AspNetCore.Mvc;
using webApiCore6.Data;
using webApiCore6.Models;

namespace webApiCore6.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EstadoController : ControllerBase
    {

        private readonly EstadoRepository _repo;

        public EstadoController(EstadoRepository repo)
        {
            _repo = repo;
        }

        [HttpGet("Estados")]
        public async Task<ActionResult<IEnumerable<Estado>>> GetEstados()
        {
            var estados = await _repo.GetEstados();
            return Ok(estados);
        }

    }
}
