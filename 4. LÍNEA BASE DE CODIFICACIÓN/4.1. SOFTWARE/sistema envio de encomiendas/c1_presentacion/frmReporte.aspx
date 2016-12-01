<%@ Page Title="" Language="C#" MasterPageFile="~/Estructura.Master" AutoEventWireup="true" CodeBehind="frmReporte.aspx.cs" Inherits="c1_presentacion.frmReporte" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function printContent() {
            confirmar = confirm("¿Está seguro de imprimir el reporte?");
            if (confirmar) {
                var ficha = document.getElementById('imprimir');
                var ventimp = window.open(' ', 'popimpr');
                ventimp.document.write(ficha.innerHTML);
                ventimp.document.close();
                ventimp.print();
                ventimp.close();
            }

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>Reporte por Fecha
        </h1>
        <ol class="breadcrumb">
            <li><a href="index.aspx"><i class="fa fa-dashboard"></i>Inicio</a></li>
            <li class="active">Reporte por Fecha</li>
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




                                <table align="center">
                                    <tr>
                                        <td>Fecha:</td>
                                        <td>
                                            <input id="txtFecha" type="date" name="txtFecha" runat="server" />
                                        </td>
                                        <td>Origen:</td>
                                        <td>
                                            <asp:DropDownList ID="cboOrigen" runat="server" OnSelectedIndexChanged="cboOrigen_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                                        </td>
                                        <td>Destino:</td>
                                        <td>
                                            <asp:DropDownList ID="cboDestino" runat="server"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="btnVerReporte" runat="server" Text="VER REPORTE" OnClick="btnVerReporte_Click" Style="height: 26px" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnImprimir" runat="server" Text="IMPRIMIR" OnClientClick="javascript:printContent();" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                                <br />
                                <div id="imprimir">
                                    <h2 align="center">
                                        <asp:Label ID="lblTituloReporte" runat="server" Text=""></asp:Label>
                                    </h2>
                                    <table style="align-content:center;">
                                        <tr>
                                            <asp:GridView ID="tablaDocumentoEnvioEncomienda" runat="server" CssClass="table table-hover table-striped" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" horizontalalign="Center">
                                                <AlternatingRowStyle BackColor="White" />
                                                <Columns>
                                                    <asp:BoundField DataField="idDocumentoEnvio" HeaderText="Codigo" />
                                                    <asp:TemplateField HeaderText="Remitente">
                                                        <ItemTemplate>
                                                            <asp:Label ID="NomRemitente" runat="server" Text='<%# Eval("remitente.nombresCliente") %>'></asp:Label>
                                                            <asp:Label ID="ApeRemitente" runat="server" Text='<%# Eval("remitente.apellidosCliente") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Destinatario">
                                                        <ItemTemplate>
                                                            <asp:Label ID="NomRemitente" runat="server" Text='<%# Eval("destinatario.nombresCliente") %>'></asp:Label>
                                                            <asp:Label ID="ApeRemitente" runat="server" Text='<%# Eval("destinatario.apellidosCliente") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="sucursalOrigen.nombreCiudad" HeaderText="Origen" />
                                                    <asp:BoundField DataField="sucursalDestino.nombreCiudad" HeaderText="Destino" />
                                                    <asp:BoundField DataField="fechaSalida" HeaderText="Fecha Salida" />
                                                    <asp:BoundField DataField="estadoDocumento" HeaderText="Estado" />

                                                </Columns>
                                                <RowStyle CssClass="cursor-pointer" />
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
                                        </tr>
                                    </table>
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
