using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace c4_persistencia.DAO
{
    public class GestorDAOSQL
    {
        SqlConnection conexion;
        SqlTransaction transaccion;

        public GestorDAOSQL() { }

        public SqlConnection abrirConexionSQL()
        {
            try
            {
                conexion = new SqlConnection();
                conexion.ConnectionString = "Data Source=.; Initial Catalog=SISTEMA_ENVIOS;Integrated Security=true";
                conexion.Open();
            }
            catch (Exception e)
            {
                throw e;
            }
            return conexion;
        }
        public void cerrarConexionSQL()
        {
            try
            {
                conexion.Close();
            }
            catch (Exception e)
            {
                throw e;
            }

        }

        public void iniciarTransaccion()
        {
            try
            {
                conexion.Open();
                transaccion = conexion.BeginTransaction();
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public void terminarTransaccion()
        {
            try
            {
                transaccion.Commit();
                conexion.Close();
            }
            catch (Exception e)
            {

                throw e;
            }
        }

        public void cancelarTransaccion()
        {
            try
            {
                transaccion.Rollback();
                conexion.Close();
            }
            catch (Exception e)
            {

                throw e;
            }
        }

        public SqlDataReader ejecutarConsulta(String sentenciaSQL)
        {

            try
            {
                SqlCommand comando = obtenerComandoSQL(sentenciaSQL);
                SqlDataReader resultado = comando.ExecuteReader();
                return resultado;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public SqlCommand obtenerComandoSQL(String sentenciaSQL)
        {
            try
            {
                SqlCommand comando = conexion.CreateCommand();
                if (transaccion != null)
                {
                    comando.Transaction = transaccion;
                }
                comando.CommandText = sentenciaSQL;
                comando.CommandType = CommandType.Text;
                return comando;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
