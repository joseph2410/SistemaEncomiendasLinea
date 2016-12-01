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
    public class ReporteEncomiendaServicio
    {
        private GestorDAOSQL gestorDAOSQL;
        private IDocumentoEnvioEncomiendaDAO documentoEnvioEncomiendaDAO;
        private ISucursalDAO sucursalDAO;

        public ReporteEncomiendaServicio()
        {
            gestorDAOSQL = new GestorDAOSQL();
            documentoEnvioEncomiendaDAO = new DocumentoEnvioEncomiendaDAO(gestorDAOSQL);
            sucursalDAO = new SucursalDAO(gestorDAOSQL);
        }

        public List<DocumentoEnvioEncomienda> reporte(string fecha, int idSucursalOrigen, int idSucursalDestino)
        {
            gestorDAOSQL.abrirConexionSQL();
            List<DocumentoEnvioEncomienda> listaDocumentoEnvioEncomienda = documentoEnvioEncomiendaDAO.reporte(fecha, idSucursalOrigen, idSucursalDestino);
            gestorDAOSQL.cerrarConexionSQL();
            return listaDocumentoEnvioEncomienda;
        }

        public List<Sucursal> listarSucursal(int idSucursalOrigen)
        {
            gestorDAOSQL.abrirConexionSQL();
            List<Sucursal> listaSucursal = sucursalDAO.listarSucursal();
            List<Sucursal> listaSucursalDestino = new List<Sucursal>();
            for (int i = 0; i < listaSucursal.Count(); i++)
            {
                if (listaSucursal[i].idSucursal != idSucursalOrigen)
                {
                    listaSucursalDestino.Add(listaSucursal[i]);
                }
            }
            gestorDAOSQL.cerrarConexionSQL();
            return listaSucursalDestino;
        }
    }
}
