<%@ Page Title="" Language="C#" MasterPageFile="~/Estructura.Master" AutoEventWireup="true" CodeBehind="frmMantenedorCliente.aspx.cs" Inherits="c1_presentacion.frmMantenedorCliente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
        function validaNumeros(e) {
            tecla = (document.all) ? e.keyCode : e.which;

            //Tecla de retroceso para borrar, siempre la permite
            if (tecla == 8) {
                return true;
            }

            // Patron de entrada, en este caso solo acepta numeros
            patron = /[0-9]/;
            tecla_final = String.fromCharCode(tecla);
            return patron.test(tecla_final);
        }
        function validaLetras(e) {
            tecla = (document.all) ? e.keyCode : e.which;

            //Tecla de retroceso para borrar, siempre la permite
            if (tecla == 8 || tecla == 32) {
                return true;
            }

            // Patron de entrada, en este caso solo acepta numeros
            patron = /^[a-zA-Z]/;
            tecla_final = String.fromCharCode(tecla);
            return patron.test(tecla_final);
        }
        function validaTelefono(e)
        {
            tecla = (document.all) ? e.keyCode : e.which;

            //Tecla de retroceso para borrar, siempre la permite
            if (tecla == 8 || tecla == 32 || tecla == 45) {
                return true;
            }

            // Patron de entrada, en este caso solo acepta numeros
            patron = /[0-9]/;
            tecla_final = String.fromCharCode(tecla);
            return patron.test(tecla_final);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>Mantenedor de cliente
        </h1>
        <ol class="breadcrumb">
            <li><a href="index.aspx"><i class="fa fa-dashboard"></i>Inicio</a></li>
            <li class="active">Mantenedor de cliente</li>
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-header">
                        <h3 class="box-title">Informaci&oacute;n</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-6"></div>
                            <div class="col-sm-6"></div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">




                                <asp:HiddenField runat="server" ID="hdn" />

                                <table style="width: 100%; margin-bottom: 0px; height: 194px;">

                                    <tr>
                                        <td class="auto-style7">
                                            <asp:Label ID="nombre" runat="server" Text="Nombres:"></asp:Label>
                                        </td>
                                        <td class="auto-style7">
                                            <asp:TextBox ID="txtNombre" runat="server" MaxLength="25" Style="margin-top: 0px" Width="257px" Height="25px" onkeypress="return validaLetras(event)"></asp:TextBox>

                                        </td>
                                        <td class="auto-style7"></td>

                                    </tr>
                                    <tr>
                                        <td class="auto-style3">
                                            <asp:Label ID="apellidos" runat="server" Text="Apellidos:"></asp:Label>
                                        </td>
                                        <td class="auto-style1">
                                            <asp:TextBox ID="txtApellidos" runat="server" MaxLength="25" Style="margin-top: 0px" Width="257px" onkeypress="return validaLetras(event)"></asp:TextBox>

                                        </td>
                                        <td class="auto-style1"></td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style13">
                                            <asp:Label ID="documento" runat="server" Text="Documento:"></asp:Label>
                                        </td>
                                        <td class="auto-style14">
                                            <asp:TextBox ID="txtDocumento" MaxLength="11" runat="server" Width="177px" onkeypress="return validaNumeros(event)"></asp:TextBox>
                                        </td>
                                        <td class="auto-style14"></td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style15">
                                            <asp:Label ID="direccion" runat="server" Text="Dirección:"></asp:Label>
                                        </td>
                                        <td class="auto-style16">
                                            <asp:TextBox ID="txtDireccion" runat="server" MaxLength="50" Width="177px"></asp:TextBox>
                                        </td>
                                        <td class="auto-style16"></td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style17">
                                            <asp:Label ID="telefono" runat="server" Text="Telefono:"></asp:Label>
                                        </td>
                                        <td class="auto-style18">
                                            <asp:TextBox ID="txtTelefono" runat="server" MaxLength="20" Width="177px" onkeypress="return validaTelefono(event)"></asp:TextBox>
                                        </td>
                                        <td class="auto-style18"></td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style9"></td>
                                        <td class="auto-style10">
                                            <asp:Label ID="etiMensaje" runat="server" BackColor="#FFFFCC" ForeColor="Blue"></asp:Label>
                                        </td>
                                        <td class="auto-style10"></td>
                                    </tr>
                                </table>
                                <br />
                                <table style="width: 32%;">
                                    <tr>
                                        <td class="auto-style6">
                                            <asp:Button ID="botGuardar" class="btn btn-primary" runat="server" OnClick="botGuardar_Click" Text="Guardar" />
                                        </td>
                                        <td>
                                            <asp:Button ID="botModificar" class="btn btn-primary" runat="server" OnClick="botModificar_Click" Text="Modificar" />
                                        </td>
                                        <td>
                                            <asp:Button ID="botLimpiar" class="btn btn-primary" runat="server" OnClick="botLimpiar_Click" Text="Limpiar" />
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <br />
                                <asp:GridView ID="tablaClientes" runat="server" AutoGenerateColumns="False" CssClass="table table-hover table-striped" ItemType="c3_dominio.entidades.Cliente" SelectMethod="ListarClientes" DataKeyNames="idCliente" OnRowCommand="gridDados_RowCommand" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None">
                                    <Columns>
                                        <asp:BoundField DataField="idCliente" HeaderText="ID" />
                                        <asp:BoundField DataField="nombresCliente" HeaderText="NOMBRES" />
                                        <asp:BoundField DataField="apellidosCliente" HeaderText="APELLIDOS" />
                                        <asp:BoundField DataField="documentoIdentidad" HeaderText="DNI" />
                                        <asp:BoundField DataField="direccion" HeaderText="DIRECCION" />
                                        <asp:BoundField DataField="telefono" HeaderText="TELEFONO" />
                                        <asp:CheckBoxField DataField="activo" HeaderText="ACTIVO" />

                                        <asp:TemplateField ShowHeader="false">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Eliminar" OnClientClick="return confirm('Desea Eliminarlo?')" CommandArgument='<%#: Item.idCliente %>' Text="Eliminar"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ShowHeader="false">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Editar" CommandArgument='<%#: Item.idCliente %>' Text="Editar"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>
                                    <RowStyle CssClass="cursor-pointer" />
                                    <FooterStyle BackColor="White" ForeColor="#000066" />
                                    <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                    <RowStyle ForeColor="#000066" />
                                    <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                                    <SortedAscendingHeaderStyle BackColor="#007DBB" />
                                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                                    <SortedDescendingHeaderStyle BackColor="#00547E" />
                                </asp:GridView>
                                <br />



                                <div class="ventanaMsj">
                                    <div class="formMsj">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblMensajeAlerta" runat="server" Text=""></asp:Label>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right;">&nbsp;<br />
                                                    &nbsp;<input type="button" value="SALIR" onclick="javascript: cerrarVentanaModalMsj();" />
                                                </td>
                                            </tr>
                                        </table>

                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <!-- /.box -->
            </div>
            <!-- /.col -->
        </div>
        <!-- /.row -->
    </section>
</asp:Content>
