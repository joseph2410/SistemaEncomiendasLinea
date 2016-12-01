using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace c3_dominio.entidades
{
    public class Usuario
    {
        private int _idUsuario;
        private string _usuario;
        private string _clave;
        private string _nombreUsuario;
        private string _apellidosUsuario;
        private string _documentoIdentidad;
        private string _direccion;
        private string _telefono;
        private string _cargo;
        private Sucursal _sucursal;
        private bool _activo;
	    
        public int idUsuario
        {
            get { return _idUsuario; }
            set{_idUsuario = value;}
        }
        public string usuario
        {
            get { return _usuario; }
            set { _usuario = value; }
        }
        public string clave
        {
            get { return _clave; }
            set { _clave = value; }
        }
        public string nombreUsuario
        {
            get { return _nombreUsuario; }
            set { _nombreUsuario = value; }
        }
        public string apellidosUsuario
        {
            get { return _apellidosUsuario; }
            set { _apellidosUsuario = value; }
        }
        public string documentoIdentidad
        {
            get { return _documentoIdentidad; }
            set { _documentoIdentidad = value; }
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
        public string cargo
        {
            get { return _cargo; }
            set { _cargo = value; }
        }
        public Sucursal sucursal
        {
            get { return _sucursal; }
            set { _sucursal = value; }
        }
        public bool activo
        {
            get { return _activo; }
            set { _activo = value; }
        }

        public Boolean EsActivo()
        {
            if (this._activo == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
