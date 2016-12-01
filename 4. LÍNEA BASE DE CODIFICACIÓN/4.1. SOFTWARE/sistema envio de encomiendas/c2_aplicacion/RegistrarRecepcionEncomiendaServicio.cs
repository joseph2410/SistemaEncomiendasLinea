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
    public class RegistrarRecepcionEncomiendaServicio
    {
        private GestorDAOSQL gestorDAOSQL;
        private IDocumentoEnvioEncomiendaDAO documentoEnvioEncomiendaDAO;

        public RegistrarRecepcionEncomiendaServicio()
        {
            gestorDAOSQL = new GestorDAOSQL();
            documentoEnvioEncomiendaDAO = new DocumentoEnvioEncomiendaDAO(gestorDAOSQL);
        }

        public int registraEntrega(List<DocumentoEnvioEncomienda> lista)
        {
            int filas = documentoEnvioEncomiendaDAO.registraEntrega(lista);
            gestorDAOSQL.cerrarConexionSQL();
            return filas;
        }

        public int registraEntregaPago(List<DocumentoEnvioEncomienda> lista)
        {
            int filas = documentoEnvioEncomiendaDAO.registraEntregaPago(lista);
            gestorDAOSQL.cerrarConexionSQL();
            return filas;
        }

        public List<DocumentoEnvioEncomienda> buscarEncomiendaPorDNI(DocumentoEnvioEncomienda objDocumento)
        {
            List<DocumentoEnvioEncomienda> listaDocumentos = null;
            try
            {
                listaDocumentos = documentoEnvioEncomiendaDAO.buscarEncomiendaPorDNI(objDocumento);
                gestorDAOSQL.cerrarConexionSQL();
                calcularMontos(listaDocumentos);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return listaDocumentos;
        }

        public List<DocumentoEnvioEncomienda> buscarEncomiendaPorNombre(DocumentoEnvioEncomienda objDocumento)
        {
            List<DocumentoEnvioEncomienda> listaDocumentos = null;
            try
            {
                listaDocumentos = documentoEnvioEncomiendaDAO.buscarEncomiendaPorNombre(objDocumento);
                gestorDAOSQL.cerrarConexionSQL();
                calcularMontos(listaDocumentos);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return listaDocumentos;
        }

        public void calcularMontos(List<DocumentoEnvioEncomienda> lista)
        {
            for(int i=0;i<lista.Count();i++)
            {
                lista[i].calcularMonto();
            }
        }

    }
}
