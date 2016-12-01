using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.Validaciones;

namespace c3_dominio.entidades
{
    public class Cliente
    {
        private int _idCliente;
        private string _nombresCliente;
        private string _apellidosCliente;
        private string _documentoIdentidad;
        private string _direccion;
        private string _telefono;
        private bool _activo;

        public int idCliente
        {
            get { return _idCliente; }
            set { _idCliente = value; }
        }
        public string nombresApellidosCliente
        {
            get { return _nombresCliente + " " + _apellidosCliente; }
        }
        public string nombresCliente
        {
            get { return _nombresCliente; }
            set { _nombresCliente = value; }
        }
        public string apellidosCliente
        {
            get { return _apellidosCliente; }
            set { _apellidosCliente = value; }
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
        public bool activo
        {
            get { return _activo; }
            set { _activo = value; }

        }


        public Boolean NombreInvalido()
        {
            if (_nombresCliente.Length == 0 || _nombresCliente.Length > 25)
            {
                return true;
            }
            else if (ValidacionesCampos.soloLetras(_nombresCliente))
                return false;

            else
                return true;
        }

        public Boolean ApellidoInvalido()
        {
            if (_apellidosCliente.Length == 0 || _apellidosCliente.Length > 25)
            {
                return true;
            }
            else if (ValidacionesCampos.soloLetras(_apellidosCliente))
                return false;

            return true;
        }

        public Boolean DocumentoInvalido()
        {
            if (_documentoIdentidad.Length == 0 || _documentoIdentidad.Length > 11)
            {
                return true;
            }
            else if (ValidacionesCampos.soloNumeros(_documentoIdentidad))
                return false;

            return true;
        }

        public Boolean TelefonoInvalido()
        {
            if (_telefono.Length == 0 || _telefono.Length > 20)
            {
                return true;
            }
            else if (ValidacionesCampos.soloNumeros(_telefono))
                return false;

            return true;
        }

        //jjp

        public Boolean comprobarDocumentoIdentidad()
        {
            if (ValidacionesCampos.soloNumeros(_documentoIdentidad))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public Boolean comprobarCopiaDocumentoIdentidad(String nroDocumento)
        {
            if (this._documentoIdentidad.Equals(nroDocumento))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        public Boolean validarRUC()
        {
            if (ValidacionesCampos.validarRUC(_documentoIdentidad))
            {
                return true;
            }
            else { return false; }
        }
    }
}
