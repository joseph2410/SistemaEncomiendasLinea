using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
namespace c3_dominio.contratos
{
    public interface IDocumentoEnvioEncomiendaDAO
    {
        /* --- Garcia --- */
        List<DocumentoEnvioEncomienda> reporte(String fecha, int idSucursalOrigen, int idSucursalDestino);

        /* --- Jacinto --- */
        int registraEncomienda(DocumentoEnvioEncomienda objDocumentoEnvioEncomienda);

        /* --- Narro ---*/
        List<DocumentoEnvioEncomienda> buscarEncomiendaPorDNI(DocumentoEnvioEncomienda objDocumento);
        List<DocumentoEnvioEncomienda> buscarEncomiendaPorNombre(DocumentoEnvioEncomienda objDocumento);
        int registraEntrega(List<DocumentoEnvioEncomienda> lista);
        int registraEntregaPago(List<DocumentoEnvioEncomienda> lista);
    }
}
