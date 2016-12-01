using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
namespace c3_dominio.contratos
{
    public interface IClienteDAO
    {
        //Capcha ---
        Cliente BuscarCliente(Int32 IdCliente);
        List<Cliente> ListarClientes();
        int RegistrarCliente(Cliente c);
        int ActualizarCliente(Cliente c);
        int EliminarCliente(Int32 IdCliente);
        // Jacinto ---
        Cliente buscarClientePorDocIdentidad(String _documentoIdentidad);
        // Narro ---
        Cliente buscarPorId(int id);
        //aqui van las declaraciones prototipo
    }
}
