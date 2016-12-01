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
    public class PrecioBaseDAO : IPrecioBaseDAO
    {
        GestorDAOSQL gestorDAOSQL;
        public PrecioBaseDAO(GestorDAOSQL gestorDAOSQL)
        {
            this.gestorDAOSQL = gestorDAOSQL;
        }

        public List<PrecioBase> listarPrecioBase(int idsucursalOrigen, int idSucursalDestino)
        {
            SqlCommand cmd = null;
            SqlConnection con = null;
            SqlDataReader dr = null;
            List<PrecioBase> lista = null;
            PrecioBase objPrecioBase;
            try
            {
                con = new SqlConnection();
                con = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spListarPrecioBase", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("prmIdSucursalOrigen", idsucursalOrigen);
                cmd.Parameters.AddWithValue("prmIdSucursalDestino", idSucursalDestino);
                dr = cmd.ExecuteReader();
                lista = new List<PrecioBase>();
                while (dr.Read())
                {
                    objPrecioBase = obtenerPrecioBase(dr);
                    lista.Add(objPrecioBase);
                }
            }
            catch (Exception)
            {
                throw;
            }
            return lista;
        }

        public PrecioBase obtenerPrecioBase(SqlDataReader dr)
        {
            PrecioBase objPrecioBase = new PrecioBase();

            objPrecioBase.idPrecioBase = Convert.ToInt32(dr["idPrecioBase"]);
            objPrecioBase.descripcion = Convert.ToString(dr["descripcion"]);
            objPrecioBase.precio = Convert.ToDecimal(dr["precio"]);
            return objPrecioBase;
        }
    }
}
