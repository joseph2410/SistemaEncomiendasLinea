<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="c1_presentacion.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>_:: Bienvenido ::_</title>
    <link rel="stylesheet" href="css_login/style.css">
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <span href="#" class="button" id="toggle-login">Log in</span>

            <div id="login">
                <div id="triangle"></div>
                <h1>Log in</h1>
                    <asp:TextBox ID="txtNombreUsuario"  placeholder="Usuario" class="estiloInput" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtContraseña" placeholder="Clave" class="estiloInput" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:Button ID="btnIniciarSesion" runat="server" class="estiloBoton" Text="INICIAR SESION" OnClick="btnIniciarSesion_Click" />
            </div>
        </div>
    </form>
<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

<script src="js_login/index.js"></script>
</body>
</html>
