using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using c3_dominio.contratos;
using c3_dominio.entidades;
using c2_aplicacion;


namespace c1_presentacion
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnIniciarSesion_Click(object sender, EventArgs e)
        {
            try
            {
                GestionarUsuario objGestionarUsuario = new GestionarUsuario();
                Usuario objUsuario = objGestionarUsuario.VerificarAcceso(txtNombreUsuario.Text, txtContraseña.Text);
                if (objUsuario != null)
                {
                    if (objUsuario.EsActivo())
                    {
                        Session["usuario"] = objUsuario;
                        Response.Redirect("index.aspx");
                    }
                    else
                    {
                        Response.Write("<script>alert('Lo sentimos, su usuario a sido dado de baja.')</script>");
                    }

                }
                else
                {
                    Response.Write("<script>alert('Usuario o Contraseña Incorrectos, intentelo nuevamente')</script>");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}