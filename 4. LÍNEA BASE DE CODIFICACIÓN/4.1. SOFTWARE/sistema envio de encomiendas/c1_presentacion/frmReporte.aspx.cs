using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using c2_aplicacion;
using c3_dominio.entidades;
namespace c1_presentacion
{
    public partial class frmReporte : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ReporteEncomiendaServicio reporteEncomiendaServicio = new ReporteEncomiendaServicio();
                List<Sucursal> listaSucursalOrigen = reporteEncomiendaServicio.listarSucursal(0);

                cboOrigen.DataSource = listaSucursalOrigen;
                cboOrigen.DataTextField = "nombreCiudad";
                cboOrigen.DataValueField = "idSucursal";
                cboOrigen.DataBind();

                int idSucursalOrigen = Int32.Parse(cboOrigen.SelectedValue);

                List<Sucursal> listaSucursalDestino = reporteEncomiendaServicio.listarSucursal(idSucursalOrigen);
                cboDestino.DataSource = listaSucursalDestino;
                cboDestino.DataTextField = "nombreCiudad";
                cboDestino.DataValueField = "idSucursal";
                cboDestino.DataBind();

            }
        }

        protected void btnVerReporte_Click(object sender, EventArgs e)
        {
            string fecha = txtFecha.Value.ToString();
            int origen = Int32.Parse(cboOrigen.SelectedItem.Value);
            int destino = Int32.Parse(cboDestino.SelectedItem.Value);
            ReporteEncomiendaServicio reporteEncomiendaServicio = new ReporteEncomiendaServicio();
            List<DocumentoEnvioEncomienda> listaDocumentoEnvioEncomienda = reporteEncomiendaServicio.reporte(fecha, origen, destino);

            if (listaDocumentoEnvioEncomienda.Count == 0)
            {
                lblMensaje.Text = "No existen datos";
                lblTituloReporte.Text = "";
                lblMensaje.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblMensaje.Text = "";
                lblTituloReporte.Text = "REPORTE DE ENVIO DE ENCOMIENDAS";
            }

            tablaDocumentoEnvioEncomienda.DataSource = listaDocumentoEnvioEncomienda;
            tablaDocumentoEnvioEncomienda.DataBind();

        }

        protected void cboOrigen_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idSucursalOrigen = Int32.Parse(cboOrigen.SelectedValue);
            ReporteEncomiendaServicio reporteEncomiendaServicio = new ReporteEncomiendaServicio();
            List<Sucursal> listaSucursalDestino = reporteEncomiendaServicio.listarSucursal(idSucursalOrigen);
            cboDestino.DataSource = listaSucursalDestino;
            cboDestino.DataTextField = "nombreCiudad";
            cboDestino.DataValueField = "idSucursal";
            cboDestino.DataBind();
        }

    }
}