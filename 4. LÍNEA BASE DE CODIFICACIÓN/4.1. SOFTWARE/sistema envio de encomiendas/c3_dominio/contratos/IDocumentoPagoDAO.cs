using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
namespace c3_dominio.contratos
{
    public interface IDocumentoPagoDAO
    {
        DocumentoPago ultimoNumeroDocPago(String tipoDocumento, int idSucursal);
    }
}
