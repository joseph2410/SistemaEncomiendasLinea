<%@ Page Title="" Language="C#" MasterPageFile="~/Estructura.Master" AutoEventWireup="true" CodeBehind="frmRegistrarEnvio.aspx.cs" Inherits="c1_presentacion.frmRegistrarEnvio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style type="text/css">
        .auto-style7 {
            width: 195px;
        }

        .auto-style8 {
            height: 30px;
            width: 195px;
        }

        .auto-style9 {
            height: 25px;
            width: 195px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>Registrar Envio de encomienda
        </h1>
        <ol class="breadcrumb">
            <li><a href="index.aspx"><i class="fa fa-dashboard"></i>Inicio</a></li>
            <li><a href="#">Encomiendas</a></li>
            <li class="active">Registrar Envio</li>
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-header">
                        <h3 class="box-title">Encomienda</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-6"></div>
                            <div class="col-sm-6"></div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">


                                <table style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td style="padding: 5px; margin: 5px">Sucursal Origen: 
                            <asp:DropDownList ID="cboSucursalOrigen" runat="server" AutoPostBack="True"></asp:DropDownList>
                                            </td>
                                            <td style="padding: 5px; margin: 5px">Sucursal Destino: 
                            <asp:DropDownList ID="cboSucursalDestino" runat="server" OnSelectedIndexChanged="cboSucursalDestino_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="0">Seleccione Ciudad</asp:ListItem>
                            </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px; margin: 5px">Tipo Documento: 
                            <asp:DropDownList ID="cboDocumento" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboDocumento_SelectedIndexChanged">
                                <asp:ListItem Value="1">Boleta</asp:ListItem>
                                <asp:ListItem Value="2">Factura</asp:ListItem>
                            </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <table>
                                    <tbody>
                                        <tr>
                                            <td style="padding: 5px; margin: 5px" class="auto-style7">
                                                <% if (cboDocumento.SelectedIndex == 0)
                                                   {%>
                                                <h3>Boleta</h3>
                                                <%}
                                                   else
                                                   { %>
                                                <h3>Factura</h3>
                                                <%} %>
                                            </td>
                                            <td style="padding: 5px; margin: 5px">&nbsp;
                                                <asp:TextBox placeholder="NRO SERIE" ID="txtNroSerie" ReadOnly="true" runat="server"></asp:TextBox>
                                            </td>
                                            <td colspan="3">
                                                <asp:TextBox placeholder="NRO CORRELATIVO" ID="txtNroCorrelativo" ReadOnly="true" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style8">Remitente</td>
                                            <td class="auto-style1">
                                                <asp:TextBox placeholder="DNI O RUC" ID="txtNroDocumentoRemitente" runat="server" MaxLength="11"></asp:TextBox></td>
                                            <td class="auto-style1">&nbsp;<asp:Button ID="btnBuscarRemitente" runat="server" Text="B.R" OnClick="btnBuscarRemitente_Click" /></td>
                                            <td class="auto-style2">
                                                <asp:TextBox placeholder="NOMBRES O RAZON SOCIAL" ID="txtNombresRemitente" runat="server" ReadOnly="true"></asp:TextBox></td>
                                            <td class="auto-style4">&nbsp;&nbsp;<asp:Button ID="btnAgregarRemitente" runat="server" Text="+" OnClick="btnAgregarRemitente_Click" /></td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style8">Destinatario:</td>
                                            <td class="auto-style1">
                                                <asp:TextBox placeholder="DNI O RUC" ID="txtNroDocumentoDestinatario" runat="server" MaxLength="11"></asp:TextBox>&nbsp;</td>
                                            <td class="auto-style1">
                                                <asp:Button ID="btnBuscarDestinatario" runat="server" Text="B.D" OnClick="btnBuscarDestinatario_Click" /></td>
                                            <td class="auto-style2">
                                                <asp:TextBox placeholder="NOMBRES O RAZON SOCIAL" ID="txtNombresDestinatario" runat="server" ReadOnly="true"></asp:TextBox></td>
                                            <td class="auto-style4">&nbsp;&nbsp;<asp:Button ID="btnAgregarDestinatario" runat="server" Text="+" OnClick="btnAgregarDestinatario_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px; margin: 5px" class="auto-style7">Atencion a:</td>
                                            <td style="padding: 5px; margin: 5px">
                                                <asp:TextBox placeholder="DNI" ID="txtDNIResponsable" runat="server" ReadOnly="true" MaxLength="8"></asp:TextBox>
                                            </td>
                                            <td colspan="3">
                                                <asp:TextBox placeholder="NOMBRES Y APELLIDOS" ID="txtNombreResponsable" runat="server" Width="100%" ReadOnly="true" MaxLength="50"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px; margin: 5px" class="auto-style7">Domicilio: </td>
                                            <td colspan="4">
                                                <asp:TextBox placeholder="DIRECCION DEL DOMICILIO " ID="txtDomicilioDestinatario" runat="server" Width="100%" ReadOnly="true" MaxLength="50"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px; margin: 5px" class="auto-style7"></td>
                                            <td style="padding: 5px; margin: 5px">
                                                <asp:CheckBox ID="cbkADomicilio" runat="server" Text="A Domicilio" AutoPostBack="True" OnCheckedChanged="cbkADomicilio_CheckedChanged" />

                                            </td>
                                            <td style="padding: 5px; margin: 5px">
                                                <asp:CheckBox ID="cbkContraEntrega" runat="server" Text="Contra Entrega" AutoPostBack="True" OnCheckedChanged="cbkContraEntrega_CheckedChanged" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                <ContentTemplate>

                                                    <td style="padding: 5px; margin: 5px" class="auto-style7">
                                                        <asp:TextBox placeholder="CANTIDAD" ID="txtCantidad" runat="server" MaxLength="2"></asp:TextBox>&nbsp; </td>
                                                    <td style="padding: 5px; margin: 5px">
                                                        <asp:TextBox placeholder="DESCRIPCION" ID="txtDescripcion" runat="server" MaxLength="25"></asp:TextBox></td>
                                                    <td style="padding: 5px; margin: 5px">
                                                        <asp:DropDownList ID="cboPrecioBase" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboPrecioBase_SelectedIndexChanged"></asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style3">PRECIO: S/. 
                                            <asp:Label ID="lblPrecioBase" runat="server" Text="0.00"></asp:Label>
                                                    </td>
                                                    <td class="auto-style5">
                                                        <asp:Button ID="btnAgregar" runat="server" Text="AGREGAR" OnClick="btnAgregar_Click" />
                                                    </td>
                                                    </tr>
                                        <tr>
                                            <td colspan="5">
                                                <asp:GridView ID="dtgDetaalleEncomienda" runat="server" Width="100%" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" OnRowCommand="dtgDetaalleEncomienda_RowCommand" OnRowDeleted="dtgDetaalleEncomienda_RowDeleted">
                                                    <Columns>
                                                        <asp:BoundField DataField="CANTIDAD" HeaderText="CANTIDAD" />
                                                        <asp:BoundField DataField="DESCRIPCION" HeaderText="DESCRIPCION" />
                                                        <asp:BoundField DataField="UNIDAD MEDIDA" HeaderText="UNIDAD MEDIDA" />
                                                        <asp:BoundField DataField="PRECIO UNITARIO" HeaderText="PRECIO UNITARIO" />
                                                        <asp:BoundField DataField="PRECIO VENTA" HeaderText="PRECIO VENTA" />
                                                        <asp:TemplateField HeaderText="QUITAR">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" CommandName="QUITAR" CommandArgument="<%#((GridViewRow)Container).RowIndex %>">QUITAR</asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
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
                                            </td>
                                        </tr>
                                                    <tr>
                                                        <td style="padding: 5px; margin: 5px" class="auto-style7"></td>
                                                        <td style="padding: 5px; margin: 5px"></td>
                                                        <td style="padding: 5px; margin: 5px"></td>
                                                        <td style="padding: 5px; margin: 5px">SUBTOTAL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; S/.</td>
                                                        <td style="padding: 5px; margin: 5px">
                                                            <asp:Label ID="lblSubTotal" runat="server" Text="0.00" Width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 5px; margin: 5px" class="auto-style7"></td>
                                                        <td style="padding: 5px; margin: 5px"></td>
                                                        <td style="padding: 5px; margin: 5px"></td>
                                                        <td style="padding: 5px; margin: 5px">% IGV </td>
                                                        <td style="padding: 5px; margin: 5px">
                                                            <asp:Label ID="lblIGV" runat="server" Text="0.00" Width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="auto-style9"></td>
                                                        <td class="auto-style6"></td>
                                                        <td class="auto-style6"></td>
                                                        <td class="auto-style6">IMPORTE TOTAL S/.</td>
                                                        <td class="auto-style6">
                                                            <asp:Label ID="lblImporteTotal" runat="server" Text="0.00" Width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 5px; margin: 5px" class="auto-style7"></td>

                                                        <td style="padding: 5px; margin: 5px">
                                                            <asp:Button ID="btnRegistrarEnvioEncomienda" runat="server" Text="REGISTRAR" OnClick="btnRegistrarEnvioEncomienda_Click" /></td>
                                                        <td style="padding: 5px; margin: 5px"></td>
                                                        <td style="padding: 5px; margin: 5px">
                                                            <asp:Button ID="btnLimpiarCampos" runat="server" Text="CANCELAR" OnClick="btnLimpiarCampos_Click" /></td>
                                                        <td style="padding: 5px; margin: 5px"></td>
                                                    </tr>
                                                    </tbody>
                                    
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                </table>



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
