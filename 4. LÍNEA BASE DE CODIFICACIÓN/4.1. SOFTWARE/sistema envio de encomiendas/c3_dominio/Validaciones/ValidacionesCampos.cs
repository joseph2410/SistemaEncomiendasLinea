using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;

namespace c3_dominio.Validaciones
{
   public  class ValidacionesCampos
    {
       public static bool soloNumeros(string cadena) {
           String Expresion = "^[0-9]+$";
           Regex regularExpresion= new Regex(Expresion);
           return (regularExpresion.IsMatch(cadena));
       }
       public static bool validarRUC(string cadena)
       {
           String Expresion = "^[0-9]{11}$";

           Regex regularExpresion = new Regex(Expresion);
           return (regularExpresion.IsMatch(cadena));
       }
       public static bool soloLetras(string cadena)
       {
           String Expresion = "^[a-zA-Z áéíóúÁÉÍÓÚÑñ]+$";

           Regex regularExpresion = new Regex(Expresion);
           return (regularExpresion.IsMatch(cadena));
       }
    }
}
