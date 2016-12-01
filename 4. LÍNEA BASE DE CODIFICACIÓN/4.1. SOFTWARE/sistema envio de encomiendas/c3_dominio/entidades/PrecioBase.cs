using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace c3_dominio.entidades
{
    public class PrecioBase
    {
        private int _idPrecioBase;
        private Sucursal _sucursalOrigen;
        private Sucursal _sucursalDestino;
        private String _descripcion;
        private Decimal _precio;
        private Boolean _activo;

        public int idPrecioBase
        {
            get { return _idPrecioBase; }
            set { _idPrecioBase = value; }
        }
        public Sucursal sucursalOrigen
        {
            get { return _sucursalOrigen; }
            set { _sucursalOrigen = value; }
        }
        public Sucursal sucursalDestino
        {
            get { return _sucursalDestino; }
            set { _sucursalDestino = value; }
        }
        public String descripcion
        {
            get { return _descripcion; }
            set { _descripcion = value; }
        }
        public Decimal precio
        {
            get { return _precio; }
            set { _precio = value; }
        }
        public Boolean activo
        {
            get { return _activo; }
            set { _activo = value; }
        }


    }
}
