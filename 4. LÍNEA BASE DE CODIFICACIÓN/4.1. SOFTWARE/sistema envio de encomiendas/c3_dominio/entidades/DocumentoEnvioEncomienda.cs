using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using c3_dominio.Validaciones;
namespace c3_dominio.entidades
{
    public class DocumentoEnvioEncomienda
    {
        private int _idDocumentoEnvio;
        private DocumentoPago _documentoPago;
        private string _serieDocumentoPago;
        private string _numeroDocumentoPago;
        private Cliente _remitente;
        private Cliente _destinatario;
        private DateTime _fechaSalida;
        private DateTime _fechaEntrega;
        private string _nombreResponsableRecojo;
        private string _dniResponsableRecojo;
        private Sucursal _sucursalOrigen;
        private Sucursal _sucursalDestino;
        private string _direccionDestino;
        private bool _aDomicilio;
        private bool _contraEntrega;
        private string _estadoDocumento;
        private Usuario _usuario;
        private Usuario _usuarioEntrega;
        private bool _activo;
        private List<DetalleDocumentoEnvioEncomienda> _listaDetalle;
        private DetalleDocumentoEnvioEncomienda _detalleDocumentoEnvioEncomienda;
        private double _monto;
        private bool _pagado;

        public DetalleDocumentoEnvioEncomienda detalleEnvioEncomienda
        {

            get { return _detalleDocumentoEnvioEncomienda; }
            set { _detalleDocumentoEnvioEncomienda = value; }

        }
        public void calcularMonto()
        {
            double subtotal = 0.00;
            for (int i = 0; i < _listaDetalle.Count(); i++)
            {
                subtotal += (_listaDetalle[i].precioVenta * (double)_listaDetalle[i].cantidad);
            }
            if (_aDomicilio) { subtotal = subtotal + (subtotal * 0.15); }
            if (documentoPago.descripcion == "FACTURA") _monto = subtotal + (subtotal * 0.18);
            else _monto = subtotal;
        }

        public bool documentoClienteDestinatarioInvalido()
        {
            if(_destinatario.documentoIdentidad.Length != 8 || _destinatario.documentoIdentidad.Length != 11 )
            {
                return !(ValidacionesCampos.soloNumeros(_destinatario.documentoIdentidad));
            }
            return true;
        }

        public bool nombreClienteDestinatarioInvalido()
        {
            if (_destinatario.nombresCliente.Length < 5
                || _destinatario.nombresCliente.Length > 25
                || _destinatario.nombresCliente == null) return true;
            else return false;
        }

        public int idDocumentoEnvio
        {
            get { return _idDocumentoEnvio; }
            set { _idDocumentoEnvio = value; }
        }
        public DocumentoPago documentoPago
        {
            get { return _documentoPago; }
            set { _documentoPago = value; }
        }
        public string serieDocumentoPago
        {
            get { return _serieDocumentoPago; }
            set { _serieDocumentoPago = value; }
        }
        public string numeroDocumentoPago
        {
            get { return _numeroDocumentoPago; }
            set { _numeroDocumentoPago = value; }
        }
        public Cliente remitente
        {
            get { return _remitente; }
            set { _remitente = value; }
        }
        public Cliente destinatario
        {
            get { return _destinatario; }
            set { _destinatario = value; }
        }
        public DateTime fechaSalida
        {
            get { return _fechaSalida; }
            set { _fechaSalida = value; }
        }
        public DateTime fechaEntrega
        {
            get { return _fechaEntrega; }
            set { _fechaEntrega = value; }
        }
        public string nombreResponsableRecojo
        {
            get { return _nombreResponsableRecojo; }
            set { _nombreResponsableRecojo = value; }
        }
        public string dniResponsableRecojo
        {
            get { return _dniResponsableRecojo; }
            set { _dniResponsableRecojo = value; }
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
        public string direccionDestino
        {
            get { return _direccionDestino; }
            set { _direccionDestino = value; }
        }
        public bool aDomicilio
        {
            get { return _aDomicilio; }
            set { _aDomicilio = value; }
        }
        public bool contraEntrega
        {
            get { return _contraEntrega; }
            set { _contraEntrega = value; }
        }
        public string estadoDocumento
        {
            get { return _estadoDocumento; }
            set { _estadoDocumento = value; }
        }
        public Usuario usuario
        {
            get { return _usuario; }
            set { _usuario = value; }
        }
        public Usuario usuarioEntrega
        {
            get { return _usuarioEntrega; }
            set { _usuarioEntrega = value; }
        }
        public bool pagado
        {
            get { return _pagado; }
            set { _pagado = value; }
        }

        public bool activo
        {
            get { return _activo; }
            set { _activo = value; }
        }

        public List<DetalleDocumentoEnvioEncomienda> listaDetalle
        {
            get { return _listaDetalle; }
            set { _listaDetalle = value; }
        }

        public double monto
        {
            get { return _monto; }
            set { _monto = value; }
        }

        public Boolean validarDatosEnvioEmpresa()
        {
                bool resultado = false;
            if (_remitente.idCliente != 0 && _destinatario.idCliente != 0 && _listaDetalle.Count > 0)
            {
                if (_destinatario.documentoIdentidad.Length == 11)
                {
                    if (_dniResponsableRecojo != "" && _nombreResponsableRecojo != "")
                    {
                        if (soloNumerosDniResponsable() && _dniResponsableRecojo.Length == 8)
                        {
                            resultado = true;
                        }
                        else
                        {
                            resultado = false;
                        }
                    }
                    else
                    {
                        resultado = false;
                    }
                }
                else
                {
                    resultado = true;
                }
            }
            return resultado;
        }

        public Boolean envioDomicilio()
        {
            bool resultado = false;
            if (_remitente.idCliente != 0 && _destinatario.idCliente != 0 && _listaDetalle.Count > 0)
            {
                if (_aDomicilio == true)
                {
                    if (_direccionDestino.Equals(""))
                    {
                        resultado = false;
                    }
                    else
                    {
                        resultado = true;
                    }
                }

            }
            return resultado;
        }
        public Boolean soloNumerosDniResponsable()
        {
            if (ValidacionesCampos.soloNumeros(_dniResponsableRecojo))
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
