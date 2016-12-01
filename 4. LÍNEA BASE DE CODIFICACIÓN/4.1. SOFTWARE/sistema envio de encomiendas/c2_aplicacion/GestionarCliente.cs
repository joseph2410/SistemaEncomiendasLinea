using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c4_persistencia.DAO;
using c3_dominio.contratos;
using c3_dominio.entidades;

namespace c2_aplicacion
{
    public class GestionarCliente
    {
        private GestorDAOSQL gestorDAOSQL;
        private IClienteDAO clienteDAO;         
        public GestionarCliente()
        {
            gestorDAOSQL = new GestorDAOSQL();
            clienteDAO = new ClienteDAO(gestorDAOSQL); 
        }

        public Cliente BuscarCliente(Int32 IdCliente)
        {
            
            Cliente objCliente = null;
            objCliente = clienteDAO.BuscarCliente(IdCliente);
            gestorDAOSQL.cerrarConexionSQL();
            return objCliente;
        }

        public List<Cliente> ListarClientes()
        {
         
         List<Cliente> listado = clienteDAO.ListarClientes();
         gestorDAOSQL.cerrarConexionSQL();
         return listado;
         
        }

        public int RegistrarCliente(Cliente c)
        {
            int registro = clienteDAO.RegistrarCliente(c);
            gestorDAOSQL.cerrarConexionSQL();
            return registro;
        }

        public int ActualizarCliente(Cliente c)
        {
            int actualizar = clienteDAO.ActualizarCliente(c);
            gestorDAOSQL.cerrarConexionSQL();
            return actualizar;
        }

        public int EliminarCliente(Int32 IdCliente)
        {
            int eliminar = clienteDAO.EliminarCliente(IdCliente);
            gestorDAOSQL.cerrarConexionSQL();
            return eliminar;
        }
    }
}
