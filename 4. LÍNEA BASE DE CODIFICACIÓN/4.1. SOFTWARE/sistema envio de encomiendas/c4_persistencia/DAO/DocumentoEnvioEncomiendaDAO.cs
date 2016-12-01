using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.contratos;
using c3_dominio.entidades;
using System.Data.SqlClient;
using System.Data;
namespace c4_persistencia.DAO
{
    public class DocumentoEnvioEncomiendaDAO : IDocumentoEnvioEncomiendaDAO
    {
        private GestorDAOSQL gestorDAOSQL;
        public DocumentoEnvioEncomiendaDAO(GestorDAOSQL gestorDAOSQL)
        {
            this.gestorDAOSQL = gestorDAOSQL;
        }
        //Garcia ---
        public List<DocumentoEnvioEncomienda> reporte(string fecha, int idSucursalOrigen, int idSucursalDestino)
        {
            List<DocumentoEnvioEncomienda> listaDocumentoEnvioEncomienda = new List<DocumentoEnvioEncomienda>();
            DocumentoEnvioEncomienda documentoEnvioEncomienda;
            String sentenciaSQL = "select d.idDocumentoEnvio, rem.nombresCliente,rem.apellidosCliente, " +
                                "dest.nombresCliente,dest.apellidosCliente, " +
                                "so.nombreCiudad, sd.nombreCiudad, d.fechaSalida, d.estadoDocumento " +
                                "from DocumentoEnvioEncomienda d " +
                                "inner join Cliente rem on d.idRemitente = rem.idCliente " +
                                "inner join Cliente dest on d.idDestinatario = dest.idCliente " +
                                "inner join Sucursal so on d.idSucursalOrigen = so.idSucursal " +
                                "inner join Sucursal sd on d.idSucursalDestino = sd.idSucursal " +
                                //"where d.fechaSalida = '" + fecha + 
                                "where FORMAT(d.fechasalida,'yyyy-MM-dd', 'en-US') = '" + fecha +
                                "' and d.idSucursalOrigen = " + idSucursalOrigen +
                                " and d.idSucursalDestino = " + idSucursalDestino;
            try
            {
                SqlDataReader resultado = gestorDAOSQL.ejecutarConsulta(sentenciaSQL);
                while (resultado.Read())
                {
                    documentoEnvioEncomienda = crearObjetoDocumentoEnvioEncomienda(resultado);
                    listaDocumentoEnvioEncomienda.Add(documentoEnvioEncomienda);
                }
                resultado.Close();
                return listaDocumentoEnvioEncomienda;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        private DocumentoEnvioEncomienda crearObjetoDocumentoEnvioEncomienda(SqlDataReader resultado)
        {
            DocumentoEnvioEncomienda documentoEnvioEncomienda;
            documentoEnvioEncomienda = new DocumentoEnvioEncomienda();
            Cliente remitente;
            remitente = new Cliente();
            Cliente destinatario;
            destinatario = new Cliente();
            Sucursal origen;
            origen = new Sucursal();
            Sucursal destino;
            destino = new Sucursal();
            documentoEnvioEncomienda.idDocumentoEnvio = resultado.GetInt32(0);
            remitente.nombresCliente = resultado.GetString(1);
            remitente.apellidosCliente = resultado.GetString(2);
            documentoEnvioEncomienda.remitente = remitente;
            destinatario.nombresCliente = resultado.GetString(3);
            destinatario.apellidosCliente = resultado.GetString(4);
            documentoEnvioEncomienda.destinatario = destinatario;
            origen.nombreCiudad = resultado.GetString(5);
            documentoEnvioEncomienda.sucursalOrigen = origen;
            destino.nombreCiudad = resultado.GetString(6);
            documentoEnvioEncomienda.sucursalDestino = destino;
            documentoEnvioEncomienda.fechaSalida = resultado.GetDateTime(7);
            documentoEnvioEncomienda.estadoDocumento = resultado.GetString(8);
            return documentoEnvioEncomienda;
        }
        //Jacinto ---
        public int registraEncomienda(DocumentoEnvioEncomienda objEncomienda)
        {
            int filas = -1;
            SqlCommand cmd = null;
            SqlConnection cn = null;
            String xml = "";
            List<DetalleDocumentoEnvioEncomienda> lstDetalle = new List<DetalleDocumentoEnvioEncomienda>();
            lstDetalle = objEncomienda.listaDetalle;
            try
            {
                xml += "<root>";
                xml += "<Encomienda ";
                xml += "idDocumentoPago='" + objEncomienda.documentoPago.idDocumentoPago + "' ";
                xml += "serieDocumentoPago='" + objEncomienda.documentoPago.serie + "' ";
                xml += "numeroDocumentoPago='" + objEncomienda.documentoPago.numero + "' ";
                xml += "idRemitente='" + objEncomienda.remitente.idCliente + "' ";
                xml += "idDestinatario='" + objEncomienda.destinatario.idCliente + "' ";
                xml += "nombreResponsableRecojo='" + objEncomienda.nombreResponsableRecojo + "' ";
                xml += "dniResponsableRecojo='" + objEncomienda.dniResponsableRecojo + "' ";
                xml += "idSucursalOrigen='" + objEncomienda.sucursalOrigen.idSucursal + "' ";
                xml += "idSucursalDestino='" + objEncomienda.sucursalDestino.idSucursal + "' ";
                xml += "direccionDestino='" + objEncomienda.direccionDestino + "' ";
                xml += "aDomicilio='" + objEncomienda.aDomicilio + "' ";
                xml += "contraEntrega='" + objEncomienda.contraEntrega + "' ";
                xml += "estadoDocumento='" + objEncomienda.estadoDocumento + "' ";
                xml += "idUsuario='" + objEncomienda.usuario.idUsuario + "'>";

                for (int i = 0; i < lstDetalle.Count(); i++)
                {
                    xml += "<EncomiendaDetalle ";
                    xml += "descripcion='" + lstDetalle[i].descripcion + "' ";
                    xml += "precioVenta='" + lstDetalle[i].precioVenta + "' ";
                    xml += "cantidad='" + lstDetalle[i].cantidad + "' ";
                    xml += "/>";

                }
                xml += "</Encomienda>";
                xml += "</root>";
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("spRegistrarDocEnvioEncomienda", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@prmcadXML", xml);
                filas = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                return -1;
            }
            return filas;
        }
        //Narro ---
        public int registraEntrega(List<DocumentoEnvioEncomienda> lista)
        {
            int filas = -1;
            SqlCommand cmd = null;
            SqlConnection cn = null;
            String xml = "";
            try
            {
                xml += "<root>";
                for (int i = 0; i < lista.Count(); i++ )
                {
                    xml += "<Encomienda ";
                    xml += "idDocumentoEnvio='" + lista[i].idDocumentoEnvio + "' ";
                    xml += "idUsuarioEntrega='" + lista[i].usuarioEntrega.idUsuario + "' ";
                    /*la fecha se agrega desde el sql server*/
                    xml += "/>";
                }
                xml += "</root>";
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_registrarEntrega", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@prmstrCadXML", xml);
                filas = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                return -1;
            }
            return filas;
        }
        public int registraEntregaPago(List<DocumentoEnvioEncomienda> lista)
        {
            int filas = -1;
            SqlCommand cmd = null;
            SqlConnection cn = null;
            String xml = "";
            try
            {
                xml += "<root>";
                for (int i = 0; i < lista.Count(); i++)
                {
                    xml += "<Encomienda ";
                    xml += "idDocumentoEnvio='" + lista[i].idDocumentoEnvio + "' ";
                    xml += "idUsuarioEntrega='" + lista[i].usuarioEntrega.idUsuario + "' ";
                    /*la fecha se agrega desde el sql server*/
                    xml += "/>";
                }
                xml += "</root>";
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_registrarEntregaConPago", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@prmstrCadXML", xml);
                filas = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                return -1;
            }
            return filas;
        }
        public List<DocumentoEnvioEncomienda> buscarEncomiendaPorDNI(DocumentoEnvioEncomienda objDocumento)
        {
            List<DocumentoEnvioEncomienda> listaDocumento = new List<DocumentoEnvioEncomienda>();
            DocumentoEnvioEncomienda documento = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_buscarEncomiendaPorDNI", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("idSucursalDestino", objDocumento.sucursalDestino.idSucursal);
                cmd.Parameters.AddWithValue("dni", objDocumento.destinatario.documentoIdentidad);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    documento = GetDatos(dr);
                    listaDocumento.Add(documento);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return listaDocumento;
        }

        public List<DocumentoEnvioEncomienda> buscarEncomiendaPorNombre(DocumentoEnvioEncomienda objDocumento)
        {
            List<DocumentoEnvioEncomienda> listaDocumento = new List<DocumentoEnvioEncomienda>();
            DocumentoEnvioEncomienda documento = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_buscarEncomiendaPorNombre", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("idSucursalDestino", objDocumento.sucursalDestino.idSucursal);
                cmd.Parameters.AddWithValue("nombre", objDocumento.destinatario.nombresCliente);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    documento = GetDatos(dr);
                    listaDocumento.Add(documento);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return listaDocumento;
        }

        public DocumentoEnvioEncomienda GetDatos(SqlDataReader dr)
        {
            ClienteDAO clienteDAO = new ClienteDAO(gestorDAOSQL);
            SucursalDAO sucursalDAO = new SucursalDAO(gestorDAOSQL);
            DocumentoEnvioEncomienda objDocumento = new DocumentoEnvioEncomienda();

            objDocumento.idDocumentoEnvio = Convert.ToInt32(dr["idDocumentoEnvio"]);
                DocumentoPago objDocumentoPago = new DocumentoPago();
                objDocumentoPago.idDocumentoPago = Convert.ToInt32(dr["idDocumentoPago"]);
                objDocumentoPago.descripcion = dr["descripcionDocumentoPago"].ToString();
            objDocumento.documentoPago = objDocumentoPago;
            objDocumento.serieDocumentoPago = dr["serieDocumentoPago"].ToString();
            objDocumento.numeroDocumentoPago = dr["numeroDocumentoPago"].ToString();
            objDocumento.remitente = clienteDAO.buscarPorId(Convert.ToInt32(dr["idRemitente"]));
            objDocumento.destinatario = clienteDAO.buscarPorId(Convert.ToInt32(dr["idDestinatario"]));
            objDocumento.fechaSalida = Convert.ToDateTime(dr["fechaSalida"]);
            objDocumento.sucursalOrigen = sucursalDAO.buscarPorId(Convert.ToInt32(dr["idSucursalOrigen"]));
            objDocumento.sucursalDestino = sucursalDAO.buscarPorId(Convert.ToInt32(dr["idSucursalDestino"]));
            objDocumento.estadoDocumento = dr["estadoDocumento"].ToString();
            objDocumento.contraEntrega = Convert.ToBoolean(dr["contraEntrega"]);
            objDocumento.aDomicilio = Convert.ToBoolean(dr["aDomicilio"]);
            objDocumento.pagado = Convert.ToBoolean(dr["pagado"]);
            objDocumento.listaDetalle = buscarDetalleEncomienda(objDocumento.idDocumentoEnvio);
            return objDocumento;
        }

        public List<DetalleDocumentoEnvioEncomienda> buscarDetalleEncomienda(int idDocumentoEnvio)
        {
            List<DetalleDocumentoEnvioEncomienda> listaDetalle = new List<DetalleDocumentoEnvioEncomienda>();
            DetalleDocumentoEnvioEncomienda detalle = null;
            SqlCommand cmd = null;
            SqlDataReader dr = null;
            SqlConnection cn = null;
            try
            {
                cn = new SqlConnection();
                cn = gestorDAOSQL.abrirConexionSQL();
                cmd = new SqlCommand("sp_buscarDetalleEncomienda", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("idDocumentoEnvio", idDocumentoEnvio);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    detalle = GetDatosDetalle(dr);
                    listaDetalle.Add(detalle);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return listaDetalle;
        }

        DetalleDocumentoEnvioEncomienda GetDatosDetalle(SqlDataReader dr)
        {
            DetalleDocumentoEnvioEncomienda objDetalle = new DetalleDocumentoEnvioEncomienda();
            objDetalle.idDetalle = Convert.ToInt32(dr["idDetalle"]);
            objDetalle.descripcion = dr["descripcion"].ToString();
            objDetalle.precioVenta = Convert.ToDouble(dr["precioVenta"]);
            objDetalle.cantidad = Convert.ToInt32(dr["cantidad"]);
            return objDetalle;
        }
    }
}
