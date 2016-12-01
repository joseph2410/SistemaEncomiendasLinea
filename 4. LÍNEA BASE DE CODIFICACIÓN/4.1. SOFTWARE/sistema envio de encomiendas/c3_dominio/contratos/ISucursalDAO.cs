using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
namespace c3_dominio.contratos
{
    public interface ISucursalDAO
    {
        //Garcia ---
        List<Sucursal> listarSucursal();
        //Narro ---
        Sucursal buscarPorId(int id);

        //Jacinto ---
        List<Sucursal> listarSucursalOrigen(int idSucursalUsuario);
        List<Sucursal> listarSucursalDestino(int idSucursalOrigen);
    }
}
