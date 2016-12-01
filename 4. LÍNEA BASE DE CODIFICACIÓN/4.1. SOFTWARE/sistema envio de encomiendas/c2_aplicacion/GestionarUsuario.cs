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
    public class GestionarUsuario
    {
        private GestorDAOSQL gestorDAOSQL;
        private IUsuarioDAO usuarioDAO;

        public GestionarUsuario()
        {
            gestorDAOSQL = new GestorDAOSQL();
            usuarioDAO = new UsuarioDAO(gestorDAOSQL);
        }

        public Usuario VerificarAcceso(String Usuario, String Clave)
        {
            Usuario objUsuario = null;
            objUsuario = usuarioDAO.verificarAcceso(Usuario, Clave);
            gestorDAOSQL.cerrarConexionSQL();
            return objUsuario;
        }
    }
}
