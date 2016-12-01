using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.entidades;
namespace c3_dominio.contratos
{
    public interface IUsuarioDAO
    {
        Usuario verificarAcceso(String usuario, String clave);
    }
}
