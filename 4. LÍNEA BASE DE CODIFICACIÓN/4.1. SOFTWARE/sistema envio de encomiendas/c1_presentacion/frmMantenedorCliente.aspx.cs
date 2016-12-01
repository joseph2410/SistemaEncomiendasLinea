using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using c2_aplicacion;
using c3_dominio.entidades;
using System.Data;

namespace c1_presentacion
{
    public partial class frmMantenedorCliente : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                txtNombre.Focus();
                //GestionarCliente gestionarCliente = new GestionarCliente();
                //List<entCliente> listaClientes = gestionarCliente.ListarClientes();
                //tablaClientes.DataSource = listaClientes;
                //tablaClientes.DataBind();
                botModificar.CssClass = "btn btn-primary disabled";
            }
            
        }

        protected void botGuardar_Click(object sender, EventArgs e)
        {
            var db = new GestionarCliente();
            var c = new Cliente();
            c.nombresCliente = txtNombre.Text;
            c.apellidosCliente = txtApellidos.Text;
            c.documentoIdentidad = txtDocumento.Text;
            c.direccion = txtDireccion.Text;
            c.telefono = txtTelefono.Text;

            if (c.NombreInvalido())
            {
                //Response.Write("<script>alert('Nombre invalido')</script>");

                lblMensajeAlerta.Text = "Nombre invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                //txtNombre.Text = "";
                return;
            }
            if (c.ApellidoInvalido())
            {
                //Response.Write("<script>alert('Nombre invalido')</script>");

                lblMensajeAlerta.Text = "Apellido Invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                //txtNombre.Text = "";
                return;
            }
            if (c.DocumentoInvalido())
            {
                lblMensajeAlerta.Text = "Documento Invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                return;
            }

            if (c.TelefonoInvalido())
            {
                lblMensajeAlerta.Text = "Telefono Invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                return;
            }

            int registrar = db.RegistrarCliente(c);
            if (registrar == 1)
            {
                etiMensaje.Text = "Los datos fueron guardados con Exito";
                tablaClientes.DataBind();
            }
            else
                etiMensaje.Text = "No se pudieron guardar los datos";
            //botGuardar.Enabled = false;
            limpiarCajas();
        }

        public List<Cliente> ListarClientes()
        {
            var db = new GestionarCliente();
            return db.ListarClientes();

        }

        protected void botModificar_Click(object sender, EventArgs e)
        {
            var cliente = new GestionarCliente();
            var c = new Cliente();
            c.idCliente = Convert.ToInt32(hdn.Value);
            c.nombresCliente = txtNombre.Text;
            c.apellidosCliente = txtApellidos.Text;
            c.documentoIdentidad = txtDocumento.Text;
            c.direccion = txtDireccion.Text;
            c.telefono = txtTelefono.Text;


            if (c.NombreInvalido())
            {
                //Response.Write("<script>alert('Nombre invalido')</script>");

                lblMensajeAlerta.Text = "Nombre invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                //txtNombre.Text = "";
                return;
            }
            if (c.ApellidoInvalido())
            {
                //Response.Write("<script>alert('Nombre invalido')</script>");

                lblMensajeAlerta.Text = "Apellido Invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                //txtNombre.Text = "";
                return;
            }
            if (c.DocumentoInvalido())
            {
                lblMensajeAlerta.Text = "Documento Invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                return;
            }

            if (c.TelefonoInvalido())
            {
                lblMensajeAlerta.Text = "Telefono Invalido";
                ClientScript.RegisterStartupScript(GetType(), "abrirVentanaModalMsjJS", "abrirVentanaModalMsj();", true);
                return;
            }
                cliente.ActualizarCliente(c);
                tablaClientes.DataBind();
                limpiarCajas();
        }

        protected void botLimpiar_Click(object sender, EventArgs e)
        {
            limpiarCajas();
        }

        void limpiarCajas()
        {
            txtNombre.Text = "";
            txtApellidos.Text = "";
            txtDocumento.Text = "";
            txtDireccion.Text = "";
            txtTelefono.Text = "";
            etiMensaje.Text = "";
            botModificar.CssClass = "btn btn-primary disabled";
            botGuardar.CssClass = "btn btn-primary";
        }

        protected void gridDados_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var cliente = new GestionarCliente();
            var objeCliente = new Cliente();
            var id = Convert.ToInt32(e.CommandArgument);
            hdn.Value = id.ToString();

            switch (e.CommandName)
            {
                case "Eliminar":
                    cliente.EliminarCliente(id);
                    tablaClientes.DataBind();
                    break;

                case "Editar":
                    botGuardar.CssClass = "btn btn-primary disabled";
                    botModificar.CssClass = "btn btn-primary";
                    CargarDatos(id);
                    break;

                default:
                    break;
            }
        }

        public void CargarDatos(int id)
        {
            var cliente = new GestionarCliente();

            var obj = cliente.BuscarCliente(id);

            txtNombre.Text = obj.nombresCliente;
            txtApellidos.Text = obj.apellidosCliente;
            txtDocumento.Text = obj.documentoIdentidad;
            txtDireccion.Text = obj.direccion;
            txtTelefono.Text = obj.telefono;
        }





    }
}