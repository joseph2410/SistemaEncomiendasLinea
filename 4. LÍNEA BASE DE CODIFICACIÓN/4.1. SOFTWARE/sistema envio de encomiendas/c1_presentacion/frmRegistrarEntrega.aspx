<%@ Page Title="" Language="C#" MasterPageFile="~/Estructura.Master" AutoEventWireup="true" CodeBehind="frmRegistrarEntrega.aspx.cs" Inherits="c1_presentacion.frmRegistrarEntrega" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function limpiarTexto(control) {
            control.value = "";
        }

        function limpiarCajaDNI() {
            var control = document.getElementById('<%= txtDni.ClientID %>');
            control.value = "";
        }
        function limpiarCajaNombre() {
            var control = document.getElementById('<%= txtNombre.ClientID %>');
            control.value = "";
        }
        function validaNumeros(e) {
            tecla = (document.all) ? e.keyCode : e.which;

            //Tecla de retroceso para borrar, siempre la permite
            if (tecla == 8 || tecla == 13) {
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
            if (tecla == 8 || tecla == 13 || tecla == 32) {
                return true;
            }

            // Patron de entrada, en este caso solo acepta numeros
            patron = /^[a-zA-Z]/;
            tecla_final = String.fromCharCode(tecla);
            return patron.test(tecla_final);
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>Registrar Entrega de encomienda
        </h1>
        <ol class="breadcrumb">
            <li><a href="index.aspx"><i class="fa fa-dashboard"></i>Inicio</a></li>
            <li><a href="#">Encomiendas</a></li>
            <li class="active">Registrar entrega</li>
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-header">
                        <h3 class="box-title">Buscar...</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-6"></div>
                            <div class="col-sm-6"></div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">


                                <table style="width: 100%;">
                                    <tr>
                                        <td>
                                            <div class="form-group">
                                                <label for="txtDni">DNI / RUC</label>
                                                <asp:TextBox ID="txtDni" runat="server" class="form-control" placeholder="Ingresa dni / ruc" onkeydown="limpiarCajaNombre();" onfocus="limpiarCajaNombre();"></asp:TextBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="form-group">
                                                <label for="txtNombre">Nombre o Raz. Social</label>
                                                <asp:TextBox ID="txtNombre" runat="server" class="form-control" placeholder="Ingresa nombre o razon social" onkeydown="limpiarCajaDNI();" onfocus="limpiarCajaDNI();"></asp:TextBox>
                                            </div>
                                            <div class="form-group">
                                                <asp:Button ID="btnBuscar" runat="server" class="btn btn-default btn-flat" Text="BUSCAR" OnClick="btnBuscar_Click" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:GridView ID="gvEncomiendas" runat="server" AutoGenerateColumns="False" OnRowCommand="dvEncomiendas_RowCommand"
                                                CssClass="table table-hover table-striped" GridLines="None"
                                                DataKeyNames="contraEntrega,serieDocumentoPago,numeroDocumentoPago,idDocumentoEnvio,pagado" CellPadding="4" ForeColor="#333333" OnSelectedIndexChanged="gvEncomiendas_SelectedIndexChanged">
                                                <AlternatingRowStyle BackColor="White" />
                                                <Columns>
                                                    <asp:BoundField DataField="idDocumentoEnvio" HeaderText="idDocumentoEnvio" Visible="False" />
                                                    <asp:BoundField DataField="destinatario.documentoIdentidad" HeaderText="DNI/RUC" />
                                                    <asp:BoundField DataField="destinatario.nombresApellidosCliente" HeaderText="Destinatario" />
                                                    <asp:BoundField DataField="remitente.nombresApellidosCliente" HeaderText="Remite" />
                                                    <asp:BoundField DataField="documentoPago.descripcion" HeaderText="Documento" />
                                                    <asp:BoundField HeaderText="Monto" DataField="monto" DataFormatString="S/. {0}" />
                                                    <asp:BoundField DataField="fechaSalida" HeaderText="Fecha Salida" DataFormatString="{0:dd-MM-yyyy}" />
                                                    <asp:TemplateField HeaderText="Detalle">
                                                        <ItemTemplate>
                                                            <!--<a >ver m&aacute;s</a>-->
                                                            <asp:LinkButton ID="lnkDetalle" runat="server" CommandName="DETALLE" CommandArgument='<%# Eval("idDocumentoEnvio") %>'>ver m&aacute;s</asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Entregar">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkEntregar" runat="server" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="contraEntrega" HeaderText="contraEntrega" Visible="False" />
                                                    <asp:BoundField DataField="serieDocumentoPago" HeaderText="Serie" Visible="False" />
                                                    <asp:BoundField DataField="numeroDocumentoPago" HeaderText="Numero" Visible="False" />
                                                    <asp:BoundField DataField="pagado" HeaderText="Pagado" Visible="False" />
                                                </Columns>
                                                <EditRowStyle BackColor="#2461BF" />
                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                                <RowStyle CssClass="cursor-pointer" BackColor="#EFF3FB" />
                                                <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                                <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                                <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                                <SortedDescendingHeaderStyle BackColor="#4870BE" />
                                            </asp:GridView>
                                            <asp:Label ID="lblMensaje" runat="server" ForeColor="Red" Text="" Style="text-align: center;"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="text-align: right;">
                                            <asp:Button ID="btnEntregar" runat="server" Text="ENTREGAR ENCOMIENDA(S)" Visible="false" OnClick="btnEntregar_Click" />
                                        </td>
                                    </tr>
                                </table>
                                <div class="ventana">
                                    <div class="form">
                                        <table style="width: 100%; height: auto; padding: 25px 25px 25px 25px;">
                                            <tr>
                                                <td colspan="2" style="text-align: right;">
                                                    <b>
                                                        <asp:Label ID="lblDocumento" runat="server" Text=""></asp:Label></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="text-align: right;">
                                                    <b>
                                                        <asp:Label ID="lblSerie" runat="server" Text=""></asp:Label>-<asp:Label ID="lblNumero" runat="server" Text=""></asp:Label>
                                                    </b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2"><b>ORIGEN:</b>
                                                    <asp:Label ID="lblOrigen" runat="server" Text=""></asp:Label>
                                                    <b>\ DESTINO:</b>
                                                    <asp:Label ID="lblDestino" runat="server" Text=""></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td><b>REMITE:</b>
                                                    <asp:Label ID="lblRemite" runat="server" Text=""></asp:Label></td>
                                                <td><b>DNI:</b>
                                                    <asp:Label ID="lblDniRemite" runat="server" Text=""></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td><b>DESTINATARIO:</b>
                                                    <asp:Label ID="lblDestinatario" runat="server" Text=""></asp:Label></td>
                                                <td><b>DNI:</b>
                                                    <asp:Label ID="lblDniDestinatario" runat="server" Text=""></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Label ID="lblDireccion" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2"><b>A domicilio:</b>
                                                    <asp:Label ID="lblADomicilio" runat="server" Text="Label"></asp:Label>&nbsp;&nbsp;&nbsp; <b>Contra entrega:</b>
                                                    <asp:Label ID="lblContraEntrega" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">&nbsp;<br />
                                                    <asp:GridView ID="gvDetalle" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" Style="width: 100%;">
                                                        <AlternatingRowStyle BackColor="White" />
                                                        <Columns>
                                                            <asp:BoundField DataField="idDetalle" HeaderText="idDetalle" Visible="False" />
                                                            <asp:BoundField DataField="descripcion" HeaderText="Descripcion" />
                                                            <asp:BoundField DataField="cantidad" HeaderText="Cantidad" />
                                                            <asp:BoundField DataField="precioVenta" HeaderText="Precio Venta" />
                                                        </Columns>
                                                        <EditRowStyle BackColor="#2461BF" />
                                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                                        <RowStyle BackColor="#EFF3FB" />
                                                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                        <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                                        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                                        <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                                        <SortedDescendingHeaderStyle BackColor="#4870BE" />
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right;"><b>Total:</b></td>
                                                <td style="text-align: right;">
                                                    <asp:Label ID="lblTotal" runat="server" Text="00.00"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="text-align: right;">
                                                    <input type="button" value="SALIR" onclick="javascript: cerrarVentanaModal();" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="ventanaMsj">
                                    <div class="formMsj">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblMensajeAlerta" runat="server" Text=""></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right;">&nbsp;<br />
                                                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" OnClick="btnAceptar_Click" Visible="false" />
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
