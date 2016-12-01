using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using c2_aplicacion;
using c3_dominio.contratos;
using c3_dominio.entidades;
using System.Data;

namespace c1_presentacion
{
    public partial class frmRegistrarEnvio : System.Web.UI.Page
    {
        #region variables globales
        EnvioEncomiendaServicio objEnvioEncomiendaServicio = new EnvioEncomiendaServicio();
        List<Sucursal> listaSucursalOrigen = new List<Sucursal>();
        List<Sucursal> listaSucursalDestino = new List<Sucursal>();
        List<PrecioBase> listaPrecioBase = new List<PrecioBase>();
        DocumentoEnvioEncomienda objDocumentoEnvioEncomienda = new DocumentoEnvioEncomienda();
        DetalleDocumentoEnvioEncomienda objDetalleDocumentoEnvioEncomienda = new DetalleDocumentoEnvioEncomienda();
        DocumentoPago objDocumentoPago = new DocumentoPago();



        private static double IGV = 0;
        private static int idSucursalOrigen;
        private static int idSucursalDestino;
        private static int idRemitente;
        private static int idDestinatario;
        private static double recargoServicioDomicilio;

        private double precioVenta;
        private static double subtotal;
        private static double total;
        private static Boolean adomicilio;
        private static Boolean contraentrega;
        private static int idUsuario;
        private static int idDocumentoPago;
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Usuario objUsuario = new Usuario();
                objUsuario = (Usuario)Session["usuario"];

                idUsuario = objUsuario.idUsuario;
                int idSucursalUsuario = objUsuario.sucursal.idSucursal;

                cargarSucursalOrigen(idSucursalUsuario);

                idSucursalOrigen = Int32.Parse(cboSucursalOrigen.SelectedValue);

                cargarSucursalesDestino(idSucursalOrigen);

                int itemSucursalDestino = cboSucursalDestino.Items.Count;
                if (itemSucursalDestino > 0)
                {
                    idSucursalDestino = Int32.Parse(cboSucursalDestino.SelectedValue);

                    cargarPrecioBase(idSucursalUsuario, idSucursalDestino);

                    lblPrecioBase.Text = cboPrecioBase.SelectedValue;

                    serieDocumentoPago("BOLETA", idSucursalOrigen);

                    if (Session["detalleEncomienda"] == null)
                    {
                        construyeTabla();
                    }

                    lblIGV.Text = Convert.ToString(IGV);

                    total = objDetalleDocumentoEnvioEncomienda.calcularImporteTotal();
                    llenarCamposCalculados();
                }
                else
                {
                    Response.Redirect("index.aspx");
                    Response.Write("<script> alert('NO LE HAN SIDO ASIGNADOS SUCURSALES DESTINO')</script>");



                }

            }

        }

        protected void cboSucursalDestino_SelectedIndexChanged(object sender, EventArgs e)
        {
            idSucursalOrigen = Int32.Parse(cboSucursalOrigen.SelectedValue);
            idSucursalDestino = Int32.Parse(cboSucursalDestino.SelectedValue);

            cargarPrecioBase(idSucursalOrigen, idSucursalDestino);

            lblPrecioBase.Text = cboPrecioBase.SelectedValue;
        }

        protected void cboPrecioBase_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblPrecioBase.Text = cboPrecioBase.SelectedValue;
        }

        protected void btnBuscarRemitente_Click(object sender, EventArgs e)
        {
            Cliente objCliente = new Cliente();
            objCliente.documentoIdentidad = txtNroDocumentoRemitente.Text;

            objDocumentoEnvioEncomienda.remitente = objCliente;
            if (objDocumentoEnvioEncomienda.remitente.comprobarDocumentoIdentidad())
            {
                objCliente = objEnvioEncomiendaServicio.buscarClientePorDocIdentidad(txtNroDocumentoRemitente.Text);

                if (objCliente != null)
                {
                    if (objDocumentoEnvioEncomienda.remitente.comprobarCopiaDocumentoIdentidad(txtNroDocumentoDestinatario.Text))
                    {
                        idRemitente = objCliente.idCliente;
                        txtNombresRemitente.Text = objCliente.nombresCliente + " " + objCliente.apellidosCliente;
                    }
                    else
                    {
                        Response.Write("<script>alert('DUPLICIDAD EN LOS DOCUMENTOS DE IDENTIDAD')</script>");
                        txtNombresRemitente.Text = "";
                        txtNroDocumentoRemitente.Text = "";
                    }
                }
                else
                {
                    idRemitente = 0;
                    txtNombresRemitente.Text = "CLIENTE NO REGISTRADO";
                }
            }
            else
            {
                Response.Write("<script>alert('DOCUMENTO DE IDENTIDAD DEL REMITENTE NO ES VALIDO')</script>");
            }
        }

        protected void btnBuscarDestinatario_Click(object sender, EventArgs e)
        {
            Cliente objClienteDestinatario = null;
            objClienteDestinatario = new Cliente();
            objClienteDestinatario.documentoIdentidad = txtNroDocumentoDestinatario.Text;

            objDocumentoEnvioEncomienda.destinatario = objClienteDestinatario;

            if (objDocumentoEnvioEncomienda.destinatario.comprobarDocumentoIdentidad())
            {
                objClienteDestinatario = objEnvioEncomiendaServicio.buscarClientePorDocIdentidad(txtNroDocumentoDestinatario.Text);

                if (objClienteDestinatario != null)
                {
                    if (objDocumentoEnvioEncomienda.destinatario.comprobarCopiaDocumentoIdentidad(txtNroDocumentoRemitente.Text))
                    {
                        if (objDocumentoEnvioEncomienda.destinatario.validarRUC())
                        {
                            habilitarResponsableEntrega();
                        }

                        idDestinatario = objClienteDestinatario.idCliente;
                        txtNombresDestinatario.Text = objClienteDestinatario.nombresCliente + " " + objClienteDestinatario.apellidosCliente;
                    }
                    else
                    {
                        Response.Write("<script>alert('DUPLICIDAD EN LOS DOCUMENTOS DE IDENTIDAD')</script>");
                        txtNombresDestinatario.Text = "";
                        txtNroDocumentoDestinatario.Text = "";
                        deshabilitarResponsableEntrega();
                    }
                }
                else
                {
                    idDestinatario = 0;
                    txtNombresDestinatario.Text = "CLIENTE NO REGISTRADO";
                    deshabilitarResponsableEntrega();
                }
            }
            else
            {
                Response.Write("<script>alert('DOCUMENTO DE IDENTIDAD DEL DESTINATARIO NO ES VALIDO')</script>");
            }
        }

        protected void cbkADomicilio_CheckedChanged(object sender, EventArgs e)
        {
            if (cbkADomicilio.Checked)
            {
                txtDomicilioDestinatario.ReadOnly = false;
                recargoServicioDomicilio = 0.15;
                adomicilio = true;

            }
            else
            {
                adomicilio = false;
                txtDomicilioDestinatario.ReadOnly = true;
                recargoServicioDomicilio = 0;
            }
            objDetalleDocumentoEnvioEncomienda.igv = IGV;
            objDetalleDocumentoEnvioEncomienda.recargoDomicilio = recargoServicioDomicilio;
            total = objDetalleDocumentoEnvioEncomienda.calcularImporteTotal();
            llenarCamposCalculados();

        }
        public void cargarSucursalesDestino(int idSucursalOrigen)
        {
            listaSucursalDestino = objEnvioEncomiendaServicio.listarSucursalDestino(idSucursalOrigen);
            cboSucursalDestino.DataSource = listaSucursalDestino;
            cboSucursalDestino.DataTextField = "nombreCiudad";
            cboSucursalDestino.DataValueField = "idSucursal";
            cboSucursalDestino.DataBind();
        }

        public void cargarSucursalOrigen(int idSucursalUsuario)
        {
            listaSucursalOrigen = objEnvioEncomiendaServicio.listarSucursalOrigen(idSucursalUsuario);
            cboSucursalOrigen.DataSource = listaSucursalOrigen;
            cboSucursalOrigen.DataTextField = "nombreCiudad";
            cboSucursalOrigen.DataValueField = "idSucursal";
            cboSucursalOrigen.DataBind();
        }

        public void cargarPrecioBase(int idSucursalOrigen, int idSucursalDestino)
        {
            listaPrecioBase = objEnvioEncomiendaServicio.listarPrecioBase(idSucursalOrigen, idSucursalDestino);
            cboPrecioBase.DataSource = listaPrecioBase;
            cboPrecioBase.DataTextField = "descripcion";
            cboPrecioBase.DataValueField = "Precio";
            cboPrecioBase.DataBind();
        }

        public void habilitarResponsableEntrega()
        {
            txtDNIResponsable.ReadOnly = false;
            txtNombreResponsable.ReadOnly = false;
        }
        public void deshabilitarResponsableEntrega()
        {
            txtDNIResponsable.ReadOnly = true;
            txtNombreResponsable.ReadOnly = true;
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {

            if (objDetalleDocumentoEnvioEncomienda.comprobarNumero(txtCantidad.Text) && !txtDescripcion.Text.Equals(""))
            {
                int cantidad = Convert.ToInt32(txtCantidad.Text);
                double precioUnitario = Convert.ToDouble(cboPrecioBase.SelectedValue);


                //DetalleDocumentoEnvioEncomienda objDetalleEnvioEncomienda = new DetalleDocumentoEnvioEncomienda();

                objDetalleDocumentoEnvioEncomienda.cantidad = cantidad;
                objDetalleDocumentoEnvioEncomienda.precioVenta = (double)precioUnitario;//error se casteaba en decimal, lo cambie a double

                precioVenta = objDetalleDocumentoEnvioEncomienda.calcularImporteVenta();
                if (Session["detalleEncomienda"] == null)
                {
                    construyeTabla();
                }
                DataTable dt = new DataTable();
                dt = (DataTable)Session["detalleEncomienda"];
                DataRow dr = dt.NewRow();
                dr["CANTIDAD"] = cantidad;
                dr["DESCRIPCION"] = txtDescripcion.Text;
                dr["UNIDAD MEDIDA"] = cboPrecioBase.SelectedItem;
                dr["PRECIO UNITARIO"] = precioUnitario.ToString("#0.00");
                dr["PRECIO VENTA"] = precioVenta.ToString("#0.00");
                dt.Rows.Add(dr);
                dtgDetaalleEncomienda.DataSource = dt;
                dtgDetaalleEncomienda.DataBind();
                Session["detalleEncomienda"] = dt;
                subtotal = objDetalleDocumentoEnvioEncomienda.CalcularSubtotal();
                objDetalleDocumentoEnvioEncomienda.igv = IGV;
                objDetalleDocumentoEnvioEncomienda.recargoDomicilio = recargoServicioDomicilio;
                total = objDetalleDocumentoEnvioEncomienda.calcularImporteTotal();
                llenarCamposCalculados();
                limpiarCamposDetalle();
            }
            else
            {
                Response.Write("<script>alert('LA CANTIDAD DEBE SER SOLO NUMEROS')</script>");
                limpiarCamposDetalle();
            }

        }
        public void construyeTabla()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CANTIDAD", typeof(int));
            dt.Columns.Add("DESCRIPCION", typeof(string));
            dt.Columns.Add("UNIDAD MEDIDA", typeof(string));
            dt.Columns.Add("PRECIO UNITARIO", typeof(decimal));
            dt.Columns.Add("PRECIO VENTA", typeof(decimal));
            Session["detalleEncomienda"] = dt;
        }

        protected void cboDocumento_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboDocumento.SelectedIndex == 1)
            {
                IGV = 0.18;
                serieDocumentoPago("FACTURA", idSucursalOrigen);
            }
            else
            {
                IGV = 0;
                serieDocumentoPago("BOLETA", idSucursalOrigen);

            }

            objDetalleDocumentoEnvioEncomienda.igv = IGV;
            objDetalleDocumentoEnvioEncomienda.recargoDomicilio = recargoServicioDomicilio;
            total = objDetalleDocumentoEnvioEncomienda.calcularImporteTotal();
            llenarCamposCalculados();

        }

        protected void btnRegistrarEnvioEncomienda_Click(object sender, EventArgs e)
        {
            DocumentoEnvioEncomienda objDocumentoEnvioEncomienda = new DocumentoEnvioEncomienda();
            DetalleDocumentoEnvioEncomienda objDetalleEnvioEncomienda = null;
            DocumentoPago objDocumentoPago = new DocumentoPago();
            Cliente objClienteRemitente = new Cliente();
            Cliente objClienteDestinatario = new Cliente();
            Sucursal objSucursalOrigen = new Sucursal();
            Sucursal objSucursalDestino = new Sucursal();

            Usuario objUsuario = new Usuario();


            List<DetalleDocumentoEnvioEncomienda> lista = new List<DetalleDocumentoEnvioEncomienda>();

            objDocumentoPago.idDocumentoPago = idDocumentoPago;
            objDocumentoPago.serie = txtNroSerie.Text;
            objDocumentoPago.numero = txtNroCorrelativo.Text;
            objDocumentoEnvioEncomienda.documentoPago = objDocumentoPago;

            objClienteRemitente.idCliente = idRemitente;
            objDocumentoEnvioEncomienda.remitente = objClienteRemitente;

            objClienteDestinatario.idCliente = idDestinatario;
            objClienteDestinatario.documentoIdentidad = txtNroDocumentoDestinatario.Text;
            objDocumentoEnvioEncomienda.destinatario = objClienteDestinatario;

            objDocumentoEnvioEncomienda.nombreResponsableRecojo = txtNombreResponsable.Text;
            objDocumentoEnvioEncomienda.dniResponsableRecojo = txtDNIResponsable.Text;

            objSucursalOrigen.idSucursal = idSucursalOrigen;
            objDocumentoEnvioEncomienda.sucursalOrigen = objSucursalOrigen;

            objSucursalDestino.idSucursal = idSucursalDestino;
            objDocumentoEnvioEncomienda.sucursalDestino = objSucursalDestino;

            objDocumentoEnvioEncomienda.direccionDestino = txtDomicilioDestinatario.Text;
            objDocumentoEnvioEncomienda.aDomicilio = adomicilio;
            objDocumentoEnvioEncomienda.contraEntrega = contraentrega;
            objDocumentoEnvioEncomienda.estadoDocumento = "POR ENTREGAR";

            objUsuario.idUsuario = idUsuario;
            objDocumentoEnvioEncomienda.usuario = objUsuario;


            foreach (GridViewRow row in dtgDetaalleEncomienda.Rows)
            {
                objDetalleEnvioEncomienda = new DetalleDocumentoEnvioEncomienda();

                objDetalleEnvioEncomienda.cantidad = Int32.Parse(row.Cells[0].Text);
                objDetalleEnvioEncomienda.descripcion = row.Cells[1].Text;
                objDetalleEnvioEncomienda.precioVenta = double.Parse(row.Cells[3].Text);//error, al castear con decimal

                lista.Add(objDetalleEnvioEncomienda);

            }
            objDocumentoEnvioEncomienda.listaDetalle = lista;

            if (objDocumentoEnvioEncomienda.validarDatosEnvioEmpresa() || objDocumentoEnvioEncomienda.envioDomicilio())
            {
                int registrado = objEnvioEncomiendaServicio.registraEncomienda(objDocumentoEnvioEncomienda);

                if (registrado > 0)
                {
                    Response.Write("<script>alert('documento registado con exito')</script>");
                    serieDocumentoPago("boleta", idSucursalOrigen);
                    cboDocumento.SelectedIndex = 0;
                    limpiarTodoCampos();
                }
                else
                {
                    Response.Write("<script>alert('documento no ha sido registrado')</script>");
                    cboDocumento.SelectedIndex = 0;
                    serieDocumentoPago("boleta", idSucursalOrigen);
                }

            }
            else
            {
                Response.Write("<script>alert('no ha pasado la validacion')</script>");
            }
        }

        protected void cbkContraEntrega_CheckedChanged(object sender, EventArgs e)
        {
            if (cbkContraEntrega.Checked)
            {
                contraentrega = true;
            }
            else
            {
                contraentrega = false;
            }
        }

        protected void dtgDetaalleEncomienda_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
        }

        protected void dtgDetaalleEncomienda_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "QUITAR")
                {
                    int index = Convert.ToInt32(e.CommandArgument);
                    DataTable tb = new DataTable();
                    tb = (DataTable)Session["detalleEncomienda"];

                    tb.Rows.RemoveAt(index);
                    Session["detalleEncomienda"] = tb;

                    dtgDetaalleEncomienda.DataSource = tb;
                    dtgDetaalleEncomienda.DataBind();
                    recalcularMontos();
                }
            }
            catch (Exception)
            {
                limpiarTodoCampos();
            }

        }
        public void limpiarCamposDetalle()
        {
            txtCantidad.Text = "";
            txtDescripcion.Text = "";
        }
        public void llenarCamposCalculados()
        {
            lblIGV.Text = IGV.ToString("#0.00");
            lblSubTotal.Text = subtotal.ToString("#0.00");
            lblImporteTotal.Text = total.ToString("#0.00");
        }

        public void recalcularMontos()
        {
            subtotal = 0;
            objDetalleDocumentoEnvioEncomienda.subtotal = 0;
            DataTable dt = new DataTable();
            dt = (DataTable)Session["detalleEncomienda"];
            foreach (DataRow fila in dt.Rows)
            {
                objDetalleDocumentoEnvioEncomienda.cantidad = Convert.ToInt32(fila["CANTIDAD"].ToString());
                objDetalleDocumentoEnvioEncomienda.precioVenta = Convert.ToDouble(fila["PRECIO UNITARIO"].ToString());//error al castear, se casteaba con decimal
                subtotal = objDetalleDocumentoEnvioEncomienda.CalcularSubtotal();
            }
            objDetalleDocumentoEnvioEncomienda.igv = IGV;
            objDetalleDocumentoEnvioEncomienda.recargoDomicilio = recargoServicioDomicilio;
            total = objDetalleDocumentoEnvioEncomienda.calcularImporteTotal();
            llenarCamposCalculados();
            limpiarCamposDetalle();
        }
        public void serieDocumentoPago(String tipoDocumento, int idSucursal)
        {

            objDocumentoPago = objEnvioEncomiendaServicio.ultimoNumeroDocPago(tipoDocumento, idSucursal);

            idDocumentoPago = objDocumentoPago.idDocumentoPago;
            txtNroSerie.Text = objDocumentoPago.serie;
            txtNroCorrelativo.Text = objDocumentoPago.numero;

        }
        public void limpiarTodoCampos()
        {
            txtNroDocumentoRemitente.Text = "";
            txtNombresRemitente.Text = "";
            txtNroDocumentoDestinatario.Text = "";
            txtNombresDestinatario.Text = "";
            idRemitente = 0;
            idDestinatario = 0;
            txtDNIResponsable.Text = "";
            txtNombreResponsable.Text = "";
            txtDomicilioDestinatario.Text = "";
            txtCantidad.Text = "";
            txtDescripcion.Text = "";

            Session["detalleEncomienda"] = null;
            DataTable dt = new DataTable();
            dt = (DataTable)Session["detalleEncomienda"];

            dtgDetaalleEncomienda.DataSource = dt;
            dtgDetaalleEncomienda.DataBind();

            lblIGV.Text = "0.00";
            lblSubTotal.Text = "0.00";
            lblImporteTotal.Text = "0.00";
            subtotal = 0;
            objDetalleDocumentoEnvioEncomienda.subtotal = 0;
        }

        protected void btnLimpiarCampos_Click(object sender, EventArgs e)
        {
            limpiarTodoCampos();
        }

        protected void btnAgregarRemitente_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmMantenedorCliente.aspx");
        }

        protected void btnAgregarDestinatario_Click(object sender, EventArgs e)
        {
            Response.Redirect("frmMantenedorCliente.aspx");
        }
    }
}