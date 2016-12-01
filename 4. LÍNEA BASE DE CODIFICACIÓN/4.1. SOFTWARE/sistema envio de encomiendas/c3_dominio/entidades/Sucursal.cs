using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace c3_dominio.entidades
{
    public class Sucursal
    {
        private int _idSucursal;
        private string _nombreCiudad;
        private string _direccion;
        private string _telefono;
        private bool _activo;
	
        public int idSucursal
        {
            get { return _idSucursal; }
            set { _idSucursal = value; }
        }
        public string nombreCiudad
        {
            get { return _nombreCiudad; }
            set { _nombreCiudad = value; }
        }
        public string direccion
        {
            get { return _direccion; }
            set { _direccion = value; }
        }
        public string telefono
        {
            get { return _telefono; }
            set { _telefono = value; }
        }
        public bool activo
        {
            get { return _activo; }
            set { _activo = value; }
        }
    }
}
