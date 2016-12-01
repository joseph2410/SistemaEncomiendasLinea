using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using c3_dominio.entidades;
using c2_aplicacion;

namespace c1_presentacion
{
    public partial class frmRegistrarEntrega : System.Web.UI.Page
    {
        RegistrarRecepcionEncomiendaServicio objEncomienda = new RegistrarRecepcionEncomiendaServicio();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<DocumentoEnvioEncomienda> listaDocumentos = null;
            DocumentoEnvioEncomienda objDocumento = new DocumentoEnvioEncomienda();
            Sucursal s = new Sucursal();
            s.idSucursal = ((Usuario)Session["usuario"]).sucursal.idSucursal;
            objDocumento.sucursalDestino = s;
            Cliente c = new Cliente();
            c.documentoIdentidad = txtDni.Text;
            c.nombresCliente = txtNombre.Text;
            objDocumento.destinatario = c;

            if (txtDni.Text.Length > 0)
            {
                if (objDocumento.documentoClienteDestinatarioInvalido()) { Response.Write("<script>alert('El dni/ruc ingresado no es valido.')</script>"); return; }
                listaDocumentos = objEncomienda.buscarEncomiendaPorDNI(objDocumento);
            }
            else if (txtNombre.Text.Length > 0)
            {
                if (objDocumento.nombreClienteDestinatarioInvalido()) { Response.Write("<script>alert('El nombre ingresado no es valido.')</script>"); return; }
                listaDocumentos = objEncomienda.buscarEncomiendaPorNombre(objDocumento);
            }
            else { Response.Write("<script>alert('Ingresa un DNI / RUC o Nombre .')</script>"); return; }


            if (listaDocumentos.Count > 0)
            {
                Session["listaDocumentos"] = listaDocumentos;
                gvEncomiendas.DataSource = listaDocumentos;
                gvEncomiendas.DataBind();
                btnEntregar.Visible = true;
                lblMensaje.Text = "";
            }
            else
            {
                gvEncomiendas.DataSource = null;
                gvEncomiendas.DataBind();
                btnEntregar.Visible = false;
                lblMensaje.Text = "NO SE ENCONTRARON REGISTROS DE ENVIOS DE ENCOMIENDA PARA EL CLIENTE";
            }
        }

        protected void dvEncomiendas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DETALLE")
            {
                LinkButton lnkDetalle = (LinkButton)e.CommandSource;
                int idDocumento = Convert.ToInt32(lnkDetalle.CommandArgument);
                muestraDetalle(idDocumento);
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalJS", "abrirVentanaModal();", true);
            }
        }


        protected void muestraDetalle(int id)
        {
            List<DocumentoEnvioEncomienda> listaDocumentos = (List<DocumentoEnvioEncomienda>)Session["listaDocumentos"];
            foreach (DocumentoEnvioEncomienda obj in listaDocumentos)
            {
                if (obj.idDocumentoEnvio == id)
                {
                    lblDocumento.Text = obj.documentoPago.descripcion;
                    lblSerie.Text = obj.serieDocumentoPago;
                    lblNumero.Text = obj.numeroDocumentoPago;
                    lblOrigen.Text = obj.sucursalOrigen.nombreCiudad;
                    lblDestino.Text = obj.sucursalDestino.nombreCiudad;
                    lblRemite.Text = obj.remitente.nombresApellidosCliente;
                    lblDniRemite.Text = obj.remitente.documentoIdentidad;
                    lblDestinatario.Text = obj.destinatario.nombresApellidosCliente;
                    lblDniDestinatario.Text = obj.destinatario.documentoIdentidad;
                    lblTotal.Text = "S/. " + obj.monto.ToString();
                    if (obj.direccionDestino != null) lblDireccion.Text = "Direccion: " + obj.direccionDestino;
                    if (obj.contraEntrega) lblContraEntrega.Text = "Si"; else lblContraEntrega.Text = "No";
                    if (obj.aDomicilio) lblADomicilio.Text = "Si"; else lblADomicilio.Text = "No";
                    gvDetalle.DataSource = obj.listaDetalle;
                    gvDetalle.DataBind();
                }
            }
        }

        protected void btnEntregar_Click(object sender, EventArgs e)
        {
            String mensaje = "LOS SIGUIENTES DOCUMENTOS SON CONTRA ENTREGA:<br/><br/>";
            bool contEntrega, pagado,registrosSeleccionados=false;
            bool debePagar = false;
            String serie, numero;
            List<DocumentoEnvioEncomienda> lista = new List<DocumentoEnvioEncomienda>();
            foreach (GridViewRow row in gvEncomiendas.Rows)
            {
                CheckBox check = row.FindControl("chkEntregar") as CheckBox;
                var colsNoVisible = gvEncomiendas.DataKeys[row.RowIndex].Values;
                contEntrega = (bool)colsNoVisible[0];
                serie = (String)colsNoVisible[1];
                numero = (String)colsNoVisible[2];
                pagado = (bool)colsNoVisible[4];
                //montoTotal +=;

                DocumentoEnvioEncomienda obj = new DocumentoEnvioEncomienda();
                obj.idDocumentoEnvio = (int)colsNoVisible[3];
                Usuario u = new Usuario();
                u.idUsuario = ((Usuario)Session["usuario"]).idUsuario;
                obj.usuarioEntrega = u;
                if (check.Checked)
                {
                    if(contEntrega && !pagado)
                    {
                        mensaje += "-" + row.Cells[4].Text + " " + serie + "-" + numero + ",  Monto: " + row.Cells[5].Text + "<br/><br/>";
                    debePagar = true;
                    }
                    registrosSeleccionados = true;
                }

                lista.Add(obj);
            }

            if (!registrosSeleccionados) { Response.Write("<script>alert('Antes de registrar debe seleccionar registros.')</script>"); return; }

            if (debePagar)
            {
                Session["listaTemporal"] = lista;
                lblMensajeAlerta.Text = mensaje;
                btnAceptar.Visible = true;
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
            }
            else
            {
                btnAceptar.Visible = false;
                objEncomienda.registraEntrega(lista);
                gvEncomiendas.DataSource = null;
                gvEncomiendas.DataBind();
                btnEntregar.Visible = false;
                lblMensaje.Text = "SE REGISTRO CORRECTAMENTE LA(S) ENTREGA(S).";
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            List<DocumentoEnvioEncomienda> lista = (List<DocumentoEnvioEncomienda>)Session["listaTemporal"];

            btnAceptar.Visible = false;
            objEncomienda.registraEntregaPago(lista);
            gvEncomiendas.DataSource = null;
            gvEncomiendas.DataBind();
            btnEntregar.Visible = false;
            lblMensaje.Text = "SE REGISTRO CORRECTAMENTE LA(S) ENTREGA(S).";
        }

        protected void gvEncomiendas_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}