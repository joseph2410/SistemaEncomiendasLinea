using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
using c3_dominio.contratos;
using System.Data.SqlClient;
using System.Data;

namespace c4_persistencia.DAO
{
    public class UsuarioDAO : IUsuarioDAO
    {
        GestorDAOSQL gestorDAOSQL;
        public UsuarioDAO(GestorDAOSQL gestorDAOSQL)
        {
            this.gestorDAOSQL = gestorDAOSQL;
        }

        public Usuario verificarAcceso(String usuario, String clave)
        {
            Usuario objUsuario = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spIniciarSesion", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("prmUsuario", usuario);
                cmd.Parameters.AddWithValue("prmClave", clave);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    objUsuario = GetDatos(dr);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return objUsuario;
        }
        public Usuario GetDatos(SqlDataReader dr)
        {
            Usuario objUsuario = new Usuario();
            Sucursal objSucursal = new Sucursal();
                objSucursal.nombreCiudad = Convert.ToString(dr["nombreCiudad"]);
                objSucursal.direccion = Convert.ToString(dr["SDireccion"]); 
            objUsuario.idUsuario = Convert.ToInt32(dr["idUsuario"]);
            objUsuario.usuario = Convert.ToString(dr["usuario"]);
            objUsuario.clave = Convert.ToString(dr["clave"]);
            objUsuario.nombreUsuario = Convert.ToString(dr["nombreUsuario"]);
            objUsuario.apellidosUsuario = Convert.ToString(dr["apellidosUsuario"]);
            objUsuario.documentoIdentidad = Convert.ToString(dr["documentoIdentidad"]);
            objUsuario.direccion = Convert.ToString(dr["direccion"]);
            objUsuario.telefono = Convert.ToString(dr["telefono"]);
            objUsuario.cargo = Convert.ToString(dr["cargo"]);
            objSucursal.idSucursal = Convert.ToInt32(dr["idSucursal"]);
            objUsuario.sucursal = objSucursal;
            objUsuario.activo = Convert.ToBoolean(dr["activo"]);
            return objUsuario;
        }
    }
}
