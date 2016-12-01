using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.Validaciones;

namespace c3_dominio.entidades
{
    public class DetalleDocumentoEnvioEncomienda
    {
        private int _idDetalle;
        //private int _idDocumentoEnvio;
        private string _descripcion;
        private double _precioVenta;
        private int _cantidad;
        private double _igv;
        private double _recargoDomicilio;
        public static double _subtotal;
        public int idDetalle
        {
            get { return _idDetalle; }
            set { _idDetalle = value; }
        }
        public string descripcion
        {
            get { return _descripcion; }
            set { _descripcion = value; }
        }
        public double precioVenta
        {
            get { return _precioVenta; }
            set { _precioVenta = value; }
        }
        public int cantidad
        {
            get { return _cantidad; }
            set { _cantidad = value; }
        }
        public double igv
        {
            get { return _igv; }
            set { _igv = value; }
        }

        public double recargoDomicilio
        {
            get { return _recargoDomicilio; }
            set { _recargoDomicilio = value; }

        }

        public double subtotal
        {
            get { return _subtotal; }
            set { _subtotal = value; }

        }

        public double calcularImporteVenta()
        {
            return Convert.ToDouble(_precioVenta) * _cantidad;

        }
        public double CalcularSubtotal()
        {
            return _subtotal = _subtotal + calcularImporteVenta();
        }

        public double calcularImporteTotal()
        {
            double subtotalConRecargoDomicilio = _subtotal + (_subtotal * _recargoDomicilio);

            double totalIGV = subtotalConRecargoDomicilio * _igv;

            return subtotalConRecargoDomicilio + totalIGV;
        }

        public Boolean comprobarNumero(String cadena)
        {
            if (ValidacionesCampos.soloNumeros(cadena))
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
