using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace c3_dominio.entidades
{
    public class DocumentoPago
    {
        private int _idDocumentoPago;
        private string _serie;
        private string _numero;
        private string _descripcion;
        private bool _activo;
        
        public int idDocumentoPago
        {
            get { return _idDocumentoPago; }
            set { _idDocumentoPago = value; }
        }
        public string serie
        {
            get { return _serie; }
            set { _serie = value; }
        }
        public string numero
        {
            get { return _numero; }
            set { _numero = value; }
        }
        public string descripcion
        {
            get { return _descripcion; }
            set { _descripcion = value; }
        }
        public bool activo
        {
            get { return _activo; }
            set { _activo = value; }
        }
    }
}
