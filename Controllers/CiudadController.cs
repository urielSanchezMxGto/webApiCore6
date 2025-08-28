using Microsoft.AspNetCore.Mvc;
using webApiCore6.Data;
using webApiCore6.Models;

namespace webApiCore6.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CiudadController : ControllerBase
    {

        private readonly CiudadRepository _repo;

        public CiudadController(CiudadRepository repo)
        {
            _repo = repo;
        }

        [HttpGet("Ciudades/{idEstado}")]
        public async Task<ActionResult<IEnumerable<Ciudad>>> GetCiudades(int idEstado)
        {
            var ciudades = await _repo.GetCiudadesByEstado(idEstado);
            return Ok(ciudades);
        }

    }
}
