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
    public class DocumentoPagoDAO : IDocumentoPagoDAO
    {
        GestorDAOSQL gestorDAOSQL;
        public DocumentoPagoDAO(GestorDAOSQL gestorDAOSQL)
        {
            this.gestorDAOSQL = gestorDAOSQL;
        }
        public DocumentoPago ultimoNumeroDocPago(String tipoDocumento, int idSucursal)
        {
            DocumentoPago objDocumentoPago = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spDevolverUltimoNroDcoumento", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@prmTipoDoc", tipoDocumento);
                cmd.Parameters.AddWithValue("@prmIdSucursal", idSucursal);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    objDocumentoPago = GetDatos(dr);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return objDocumentoPago;
        }
        public DocumentoPago GetDatos(SqlDataReader dr)
        {
            DocumentoPago objDocumentoPago = new DocumentoPago();
            objDocumentoPago.idDocumentoPago = Convert.ToInt32(dr["iddocumentoPago"]);
            objDocumentoPago.serie = Convert.ToString(dr["serie"]);
            objDocumentoPago.numero = Convert.ToString(dr["numero"]);
            return objDocumentoPago;
        }
    }
}
