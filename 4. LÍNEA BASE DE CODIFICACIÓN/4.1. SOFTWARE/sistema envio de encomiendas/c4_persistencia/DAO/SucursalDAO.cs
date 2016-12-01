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
    public class SucursalDAO : ISucursalDAO
    {
        private GestorDAOSQL gestorDAOSQL;
        public SucursalDAO(GestorDAOSQL gestorDAOSQL)
        {
            this.gestorDAOSQL = gestorDAOSQL;
        }
        //Garcia ---
        public List<Sucursal> listarSucursal()
        {
            List<Sucursal> listaSucursal = new List<Sucursal>();
            Sucursal sucursal;
            String sentenciaSQL = "select idSucursal, nombreCiudad from Sucursal";
            try
            {
                SqlDataReader resultado = gestorDAOSQL.ejecutarConsulta(sentenciaSQL);
                while (resultado.Read())
                {
                    sucursal = crearObjetoSucursal(resultado);
                    listaSucursal.Add(sucursal);
                }
                resultado.Close();
                return listaSucursal;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        private Sucursal crearObjetoSucursal(SqlDataReader resultado)
        {
            Sucursal sucursal;
            sucursal = new Sucursal();
            sucursal.idSucursal = resultado.GetInt32(0);
            sucursal.nombreCiudad = resultado.GetString(1);
            return sucursal;
        }
        //Narro ---
        public Sucursal buscarPorId(int id)
        {
            Sucursal sucursal = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_buscarSucursalPorId", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("idSucursal", id);
                dr = cmd.ExecuteReader();
                if(dr.Read())
                {
                    sucursal = GetDatos(dr);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return sucursal;
        }
        Sucursal GetDatos(SqlDataReader dr)
        {
            Sucursal objSucursal = new Sucursal();
            objSucursal.idSucursal = Convert.ToInt32(dr["idSucursal"]);
            objSucursal.nombreCiudad = dr["nombreCiudad"].ToString();
            objSucursal.direccion = dr["direccion"].ToString();
            objSucursal.telefono = dr["telefono"].ToString();
            objSucursal.activo = Convert.ToBoolean(dr["activo"].ToString());
            return objSucursal;
        }
        
        //Jacinto ---
        public List<Sucursal> listarSucursalOrigen(int idSucursalUsuario)
        {
            SqlCommand cmd = null;
            SqlConnection con = null;
            SqlDataReader dr = null;
            List<Sucursal> lista = null;
            Sucursal objSucursal = null;
            try
            {
                con = new SqlConnection();
                con = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spListarSucursalOrigen", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("prmIdSucursalUsuario", idSucursalUsuario);
                dr = cmd.ExecuteReader();
                lista = new List<Sucursal>();
                while (dr.Read())
                {
                    objSucursal = obtenerSucursal(dr);
                    lista.Add(objSucursal);
                }
            }
            catch (Exception)
            {
                throw;
            }
            return lista;
        }

        public List<Sucursal> listarSucursalDestino(int idSucursalOrigen)
        {
            SqlCommand cmd = null;
            SqlConnection con = null;
            SqlDataReader dr = null;
            List<Sucursal> lista = null;
            Sucursal objSucursal;
            try
            {
                con = new SqlConnection();
                con = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spListarSucursalDestino", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("prmIdSucursalOrigen", idSucursalOrigen);
                dr = cmd.ExecuteReader();
                lista = new List<Sucursal>();
                while (dr.Read())
                {
                    objSucursal = obtenerSucursalDestino(dr);
                    lista.Add(objSucursal);
                }
            }
            catch (Exception)
            {
                throw;
            }
            return lista;
        }

        public Sucursal obtenerSucursalDestino(SqlDataReader dr)
        {
            Sucursal objSucursal = new Sucursal();

            objSucursal.idSucursal = Convert.ToInt32(dr["idSucursalDestino"]);
            objSucursal.nombreCiudad = Convert.ToString(dr["ciudadDestino"]);

            return objSucursal;
        }

        public Sucursal obtenerSucursal(SqlDataReader dr)
        {
            Sucursal objSucursal = new Sucursal();

            objSucursal.idSucursal = Convert.ToInt32(dr["idSucursal"]);
            objSucursal.nombreCiudad = Convert.ToString(dr["nombreCiudad"]);
            objSucursal.direccion = Convert.ToString(dr["direccion"]);
            objSucursal.telefono = Convert.ToString(dr["telefono"]);
            objSucursal.activo = Convert.ToBoolean(dr["activo"]);

            return objSucursal;
        }
    }
}
