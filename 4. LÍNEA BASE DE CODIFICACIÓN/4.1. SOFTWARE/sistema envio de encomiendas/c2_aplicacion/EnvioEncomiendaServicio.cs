using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
using c3_dominio.contratos;
using c4_persistencia.DAO;
using c4_persistencia;

namespace c2_aplicacion
{
    public class EnvioEncomiendaServicio
    {
        private GestorDAOSQL gestorDAOSQL;
        private ISucursalDAO sucursalDAO;
        private IPrecioBaseDAO precioBaseDAO;
        private IClienteDAO clienteDAO;
        private IDocumentoEnvioEncomiendaDAO DocumentoEnvioEncomiendaDAO;
        private IDocumentoPagoDAO DocumentoPagoDAO;
        public EnvioEncomiendaServicio()
        {
            gestorDAOSQL = new GestorDAOSQL();
            sucursalDAO = new SucursalDAO(gestorDAOSQL);
            precioBaseDAO = new PrecioBaseDAO(gestorDAOSQL);
            clienteDAO = new ClienteDAO(gestorDAOSQL);
            DocumentoEnvioEncomiendaDAO = new DocumentoEnvioEncomiendaDAO(gestorDAOSQL);
            DocumentoPagoDAO = new DocumentoPagoDAO(gestorDAOSQL);
        }

        public List<Sucursal> listarSucursalOrigen(int idSucursalUsuario)
        {
            List<Sucursal> listaSucursal = sucursalDAO.listarSucursalOrigen(idSucursalUsuario);
            gestorDAOSQL.cerrarConexionSQL();
            return listaSucursal;
        }
        public List<Sucursal> listarSucursalDestino(int idSucursalOrigen)
        {
            List<Sucursal> listaSucursalDestino = sucursalDAO.listarSucursalDestino(idSucursalOrigen);
            gestorDAOSQL.cerrarConexionSQL();
            return listaSucursalDestino;
        }

        public List<PrecioBase> listarPrecioBase(int idSucursalOrigen, int idSucursaDestino)
        {
            List<PrecioBase> listaPrecioBase = precioBaseDAO.listarPrecioBase(idSucursalOrigen, idSucursaDestino);
            gestorDAOSQL.cerrarConexionSQL();
            return listaPrecioBase;
        }
        public Cliente buscarClientePorDocIdentidad(String _documentoIdentidad)
        {
            Cliente objCliente = null;
            objCliente = clienteDAO.buscarClientePorDocIdentidad(_documentoIdentidad);
            gestorDAOSQL.cerrarConexionSQL();
            return objCliente;
        }

        public int registraEncomienda(DocumentoEnvioEncomienda objDocumentoEnvioEncomienda)
        {
            int filas = DocumentoEnvioEncomiendaDAO.registraEncomienda(objDocumentoEnvioEncomienda);
            gestorDAOSQL.cerrarConexionSQL();
            return filas;
        }
        public DocumentoPago ultimoNumeroDocPago(String tipoDocumento, int idSucursal)
        {
            DocumentoPago objDocumentoPago = null;
            objDocumentoPago = DocumentoPagoDAO.ultimoNumeroDocPago(tipoDocumento, idSucursal);
            gestorDAOSQL.cerrarConexionSQL();
            return objDocumentoPago;
        }
    }
}
