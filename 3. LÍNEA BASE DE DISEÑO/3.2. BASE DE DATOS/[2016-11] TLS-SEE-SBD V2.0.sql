USE [master]
GO
/****** Object:  Database [SISTEMA_ENVIOS]    Script Date: 03/06/2015 12:23 AM ******/
CREATE DATABASE [SISTEMA_ENVIOS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SISTEMA_ENVIOS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SISTEMA_ENVIOS.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SISTEMA_ENVIOS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SISTEMA_ENVIOS_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SISTEMA_ENVIOS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET ARITHABORT OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET RECOVERY FULL 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET  MULTI_USER 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SISTEMA_ENVIOS]
GO
/****** Object:  StoredProcedure [dbo].[sp_buscarClientePorId]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_buscarClientePorId]
@idCliente int
AS
SELECT idCliente,nombresCliente,apellidosCliente,documentoIdentidad,direccion,telefono,activo
FROM Cliente
	WHERE idCliente = @idCliente
	AND activo = 1
GO
/****** Object:  StoredProcedure [dbo].[sp_buscarDetalleEncomienda]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--buscar los detalle
CREATE PROCEDURE [dbo].[sp_buscarDetalleEncomienda]
@idDocumentoEnvio int
AS
SELECT idDetalle,descripcion,precioVenta,cantidad 
FROM DetalleDocumentoEnvioEncomienda
	WHERE idDocumentoEnvio = @idDocumentoEnvio


GO
/****** Object:  StoredProcedure [dbo].[sp_buscarEncomiendaPorDNI]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--busqueda por dni
CREATE PROCEDURE [dbo].[sp_buscarEncomiendaPorDNI]
@idSucursalDestino int,
@dni varchar(11)
AS
SELECT 
dee.idDocumentoEnvio,dee.idDocumentoPago,
dp.descripcion AS 'descripcionDocumentoPago',
dee.serieDocumentoPago,dee.numeroDocumentoPago,
dee.idRemitente,
dee.idDestinatario,cd.nombresCliente + ' ' + cd.apellidosCliente as 'nombreApellidosCliente',
dee.fechaSalida, 
dee.idSucursalOrigen,
dee.idSucursalDestino,
dee.estadoDocumento,
dee.contraEntrega,
dee.dniResponsableRecojo,
dee.nombreResponsableRecojo,
dee.aDomicilio,
dee.pagado,
dee.activo
FROM DocumentoEnvioEncomienda dee
INNER JOIN DocumentoPago dp
	ON dee.idDocumentoPago = dp.idDocumentoPago
INNER JOIN Cliente cr
	ON dee.idRemitente = cr.idCliente
INNER JOIN Cliente cd
	ON dee.idDestinatario = cd.idCliente
INNER JOIN Sucursal so
	ON so.idSucursal = dee.idSucursalOrigen
INNER JOIN Sucursal sd
	ON sd.idSucursal = dee.idSucursalDestino
WHERE dee.activo = 1
	AND sd.idSucursal = @idSucursalDestino
	AND cd.documentoIdentidad = @dni
	AND dee.estadoDocumento = 'POR ENTREGAR'
GO
/****** Object:  StoredProcedure [dbo].[sp_buscarEncomiendaPorNombre]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--busqueda por nombre
CREATE PROCEDURE [dbo].[sp_buscarEncomiendaPorNombre]
@idSucursalDestino int,
@nombre varchar(50)
AS
SELECT 
dee.idDocumentoEnvio,dee.idDocumentoPago,
dp.descripcion AS 'descripcionDocumentoPago',
dee.serieDocumentoPago,dee.numeroDocumentoPago,
dee.idRemitente,
dee.idDestinatario,cd.nombresCliente + ' ' + cd.apellidosCliente as 'nombreApellidosCliente',
dee.fechaSalida, 
dee.idSucursalOrigen,
dee.idSucursalDestino,
dee.estadoDocumento,
dee.contraEntrega,
dee.dniResponsableRecojo,
dee.nombreResponsableRecojo,
dee.aDomicilio,
dee.pagado,
dee.activo
FROM DocumentoEnvioEncomienda dee
INNER JOIN DocumentoPago dp
	ON dee.idDocumentoPago = dp.idDocumentoPago
INNER JOIN Cliente cr
	ON dee.idRemitente = cr.idCliente
INNER JOIN Cliente cd
	ON dee.idDestinatario = cd.idCliente
INNER JOIN Sucursal so
	ON so.idSucursal = dee.idSucursalOrigen
INNER JOIN Sucursal sd
	ON sd.idSucursal = dee.idSucursalDestino
WHERE dee.activo = 1
	AND sd.idSucursal = @idSucursalDestino
	AND dee.estadoDocumento = 'POR ENTREGAR'
	AND cd.nombresCliente LIKE '%' + @nombre + '%'
	OR cd.apellidosCliente LIKE '%' + @nombre + '%'

GO
/****** Object:  StoredProcedure [dbo].[sp_buscarSucursalPorId]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_buscarSucursalPorId]
@idSucursal int
AS
SELECT idSucursal,nombreCiudad,direccion,telefono,activo
FROM Sucursal
	WHERE idSucursal = @idSucursal
	AND activo = 1

GO
/****** Object:  StoredProcedure [dbo].[sp_registrarEntrega]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_registrarEntrega]
@prmstrCadXML varchar(max)
AS
	Declare @h int
Begin Transaction
	EXEC sp_xml_preparedocument @h output, @prmstrCadXML

	--EDITAR
	UPDATE d
	SET d.estadoDocumento = 'ENTREGADO',
		d.fechaEntrega = getdate(),
		d.idUsuarioEntrega = X.idUsuarioEntrega,
		d.pagado = 1
	FROM DocumentoEnvioEncomienda d INNER JOIN openXML(@h,'/root/Encomienda',1) WITH(
		idDocumentoEnvio int,
		idUsuarioEntrega int) X ON d.idDocumentoEnvio = X.idDocumentoEnvio

	EXEC sp_xml_removedocument @h
	if @@Error<>0
	Begin
		Rollback Transaction
		Return -1
	End

Commit Transaction
return 1


GO
/****** Object:  StoredProcedure [dbo].[sp_registrarEntregaConPago]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_registrarEntregaConPago]
@prmstrCadXML varchar(max)
AS
	Declare @h int
Begin Transaction
	EXEC sp_xml_preparedocument @h output, @prmstrCadXML

	--EDITAR
	UPDATE d
	SET d.estadoDocumento = 'ENTREGADO',
		d.fechaEntrega = getdate(),
		d.idUsuarioEntrega = X.idUsuarioEntrega,
		d.pagado = 1
	FROM DocumentoEnvioEncomienda d INNER JOIN openXML(@h,'/root/Encomienda',1) WITH(
		idDocumentoEnvio int,
		idUsuarioEntrega int) X ON d.idDocumentoEnvio = X.idDocumentoEnvio

	EXEC sp_xml_removedocument @h
	if @@Error<>0
	Begin
		Rollback Transaction
		Return -1
	End

Commit Transaction
return 1


GO
/****** Object:  StoredProcedure [dbo].[spActualizarCliente]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spActualizarCliente]
@idCliente int,
@nombres varchar(25),
@apellidos varchar(25),
@documento varchar(11),
@direccion varchar(50),
@Telefono varchar(20)

as

update Cliente
set
nombresCliente = @nombres,
apellidosCliente = @apellidos,
documentoIdentidad = @documento,
direccion = @direccion,
telefono = @Telefono 

where @idCliente = idCliente

GO
/****** Object:  StoredProcedure [dbo].[spBuscarCliente]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spBuscarCliente]

@IdCliente int
as

select idCliente,nombresCliente,apellidosCliente,documentoIdentidad,direccion,telefono
from Cliente
where @IdCliente = idCliente

GO
/****** Object:  StoredProcedure [dbo].[spBuscarClientePorDocumento]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBuscarClientePorDocumento]

@prmDocumentoIdentidad varchar(11)
as
begin 
select * from Cliente
where documentoIdentidad like @prmDocumentoIdentidad and activo=1
end

GO
/****** Object:  StoredProcedure [dbo].[spDevolverUltimoNroDcoumento]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spDevolverUltimoNroDcoumento]
@prmTipoDoc varchar(20),
@prmIdSucursal int
as
begin
declare @nro varchar(50);
declare @nroActual int;
set @nroActual=(select numero from DocumentoPago where descripcion like @prmTipoDoc+ '%' and idSucursal=@prmIdSucursal and activo=1  )
Set @nro=RIGHT('0000000' + Ltrim(Rtrim(@nroActual+1)),8)
select iddocumentoPago,serie, @nro as 'numero' from DocumentoPago where descripcion like @prmTipoDoc + '%' and idSucursal=@prmIdSucursal and activo=1  
end

GO
/****** Object:  StoredProcedure [dbo].[spEliminarCliente]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spEliminarCliente]

@idCliente int
as

update cliente
set activo = 0
where @idCliente = idCliente

GO
/****** Object:  StoredProcedure [dbo].[spIniciarSesion]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spIniciarSesion]
@prmUsuario varchar(20),
@prmClave varchar(20)

as

select 

u.idUsuario,
u.usuario,
u.clave,
u.nombreUsuario,
u.apellidosUsuario,
u.documentoIdentidad,
u.direccion,
u.telefono,
u.cargo,
u.idSucursal,
u.activo,
s.nombreCiudad,
s.direccion as 'SDireccion',
s.telefono


from Usuario u
inner join Sucursal s
on u.idSucursal = s.idSucursal
where  @prmUsuario = u.usuario and @prmClave = u.clave
and u.activo = 1

GO
/****** Object:  StoredProcedure [dbo].[spListarCliente]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spListarCliente]
as

select *

from Cliente
where activo = 1
GO
/****** Object:  StoredProcedure [dbo].[spListarPrecioBase]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spListarPrecioBase]
@prmIdSucursalOrigen int,
@prmIdSucursalDestino int
as
begin
select idPrecioBase, descripcion, precio from PrecioBase
where idSucursalOrigen=@prmIdSucursalOrigen and idSucursalDestino=@prmIdSucursalDestino and activo=1
end

GO
/****** Object:  StoredProcedure [dbo].[spListarSucursalDestino]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spListarSucursalDestino]
@prmIdSucursalOrigen int
as 
begin
select distinct s.idSucursal as 'idSucursalDestino', s.nombreCiudad as 'ciudadDestino' from Sucursal s, PrecioBase pb
where  s.idSucursal=pb.idSucursalDestino and pb.idSucursalOrigen=@prmIdSucursalOrigen and pb.activo=1;
end


GO
/****** Object:  StoredProcedure [dbo].[spListarSucursalOrigen]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spListarSucursalOrigen]
@prmIdSucursalUsuario int 
as
begin
select* from Sucursal
where idSucursal=@prmIdSucursalUsuario
and activo = 1
end


GO
/****** Object:  StoredProcedure [dbo].[spRegistrarCliente]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spRegistrarCliente]
@nombres varchar(25),
@apellidos varchar(25),
@documento varchar(11),
@direccion varchar(20),
@Telefono varchar(20)

as

insert into Cliente(nombresCliente,apellidosCliente,documentoIdentidad,direccion,telefono)
values (@nombres,@apellidos,@documento,@direccion,@Telefono)

GO
/****** Object:  StoredProcedure [dbo].[spRegistrarDocEnvioEncomienda]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarDocEnvioEncomienda]
@prmcadXML varchar(max)
AS
	Declare @h int
	Declare @intPKDocEncomienda int
	declare @inFKDocPago int
Begin Transaction
	EXEC sp_xml_preparedocument @h output, @prmcadXML

	--Insertar Pedido
	INSERT INTO DocumentoEnvioEncomienda(
		idDocumentoPago,
		serieDocumentoPago,
		numeroDocumentoPago,
		idRemitente,
		idDestinatario,
		fechaSalida,
		nombreResponsableRecojo,
		dniResponsableRecojo,
		idSucursalOrigen,
		idSucursalDestino,
		direccionDestino,
		aDomicilio,
		contraEntrega,
		estadoDocumento,
		idUsuario,
		activo
	)
	SELECT X.idDocumentoPago ,
		X.serieDocumentoPago ,
		X.numeroDocumentoPago ,
		X.idRemitente  ,
		X.idDestinatario ,
		GETDATE() ,
		X.nombreResponsableRecojo ,
		X.dniResponsableRecojo ,
		X.idSucursalOrigen ,
		X.idSucursalDestino,
		X.direccionDestino ,
		X.aDomicilio ,
		X.contraEntrega ,
		X.estadoDocumento ,
		X.idUsuario,
		1
		FROM openXML(@h, '/root/Encomienda', 1) WITH(
		idDocumentoPago int,
		serieDocumentoPago char(3),
		numeroDocumentoPago char(8),
		idRemitente int ,
		idDestinatario int ,
		nombreResponsableRecojo varchar(50),
		dniResponsableRecojo varchar(8),
		idSucursalOrigen int ,
		idSucursalDestino int ,
		direccionDestino varchar(50),
		aDomicilio bit,
		contraEntrega bit,
		estadoDocumento varchar(20),
		idUsuario int) X

		

	SELECT @intPKDocEncomienda = @@identity

	--Insertar el Detalle del Pedido
	INSERT INTO DetalleDocumentoEnvioEncomienda(
	idDocumentoEnvio, descripcion, precioVenta,cantidad)
	SELECT @intPKDocEncomienda, X.descripcion ,X.precioVenta, X.cantidad
	FROM openXML(@h, '/root/Encomienda/EncomiendaDetalle', 1)
	 WITH(
		descripcion varchar(25),
		precioVenta decimal(6,2),
		cantidad int) X

		update DocumentoPago 
		set numero=(select top 1 numeroDocumentoPago from DocumentoEnvioEncomienda order by idDocumentoEnvio desc) 
		where idDocumentoPago=(select top 1 idDocumentoPago from DocumentoEnvioEncomienda order by idDocumentoEnvio desc)

	EXEC sp_xml_removedocument @h
	if @@Error<>0
	Begin
		Rollback Transaction
		Return -1
	End

Commit Transaction
return @intPKDocEncomienda

GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cliente](
	[idCliente] [int] IDENTITY(1,1) NOT NULL,
	[nombresCliente] [varchar](25) NOT NULL,
	[apellidosCliente] [varchar](25) NOT NULL,
	[documentoIdentidad] [varchar](11) NOT NULL,
	[direccion] [varchar](50) NOT NULL,
	[telefono] [varchar](20) NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleDocumentoEnvioEncomienda]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleDocumentoEnvioEncomienda](
	[idDetalle] [int] IDENTITY(1,1) NOT NULL,
	[idDocumentoEnvio] [int] NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
	[precioVenta] [decimal](6, 2) NOT NULL,
	[cantidad] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentoEnvioEncomienda]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DocumentoEnvioEncomienda](
	[idDocumentoEnvio] [int] IDENTITY(1,1) NOT NULL,
	[idDocumentoPago] [int] NOT NULL,
	[serieDocumentoPago] [char](3) NOT NULL,
	[numeroDocumentoPago] [char](8) NOT NULL,
	[idRemitente] [int] NOT NULL,
	[idDestinatario] [int] NOT NULL,
	[fechaSalida] [datetime] NOT NULL,
	[fechaEntrega] [datetime] NULL,
	[nombreResponsableRecojo] [varchar](50) NULL,
	[dniResponsableRecojo] [varchar](8) NULL,
	[idSucursalOrigen] [int] NOT NULL,
	[idSucursalDestino] [int] NOT NULL,
	[direccionDestino] [varchar](50) NULL,
	[aDomicilio] [bit] NOT NULL,
	[contraEntrega] [bit] NOT NULL,
	[estadoDocumento] [varchar](20) NOT NULL,
	[idUsuario] [int] NOT NULL,
	[pagado] [bit] NOT NULL,
	[idUsuarioEntrega] [int] NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idDocumentoEnvio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentoPago]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DocumentoPago](
	[idDocumentoPago] [int] IDENTITY(1,1) NOT NULL,
	[serie] [char](3) NOT NULL,
	[numero] [char](8) NOT NULL,
	[descripcion] [varchar](25) NOT NULL,
	[idSucursal] [int] NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idDocumentoPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PrecioBase]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PrecioBase](
	[idPrecioBase] [int] IDENTITY(1,1) NOT NULL,
	[idSucursalOrigen] [int] NOT NULL,
	[idSucursalDestino] [int] NOT NULL,
	[descripcion] [varchar](25) NOT NULL,
	[precio] [decimal](6, 2) NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idPrecioBase] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sucursal]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sucursal](
	[idSucursal] [int] IDENTITY(1,1) NOT NULL,
	[nombreCiudad] [varchar](20) NOT NULL,
	[direccion] [varchar](50) NOT NULL,
	[telefono] [varchar](20) NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 03/06/2015 12:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario](
	[idUsuario] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [varchar](6) NOT NULL,
	[clave] [varchar](9) NOT NULL,
	[nombreUsuario] [varchar](25) NOT NULL,
	[apellidosUsuario] [varchar](25) NOT NULL,
	[documentoIdentidad] [varchar](8) NOT NULL,
	[direccion] [varchar](50) NOT NULL,
	[telefono] [varchar](20) NULL,
	[cargo] [varchar](25) NOT NULL,
	[idSucursal] [int] NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Cliente] ON 

INSERT [dbo].[Cliente] ([idCliente], [nombresCliente], [apellidosCliente], [documentoIdentidad], [direccion], [telefono], [activo]) VALUES (1, N'Sara Katherine1', N'Valencia Perez', N'45202114', N'av nueve de octubre # 2547', N'', 0)
INSERT [dbo].[Cliente] ([idCliente], [nombresCliente], [apellidosCliente], [documentoIdentidad], [direccion], [telefono], [activo]) VALUES (2, N'Ayrton Michael', N'Valverde Esparza', N'45877469', N'calle los jardines # 12547', N'', 1)
INSERT [dbo].[Cliente] ([idCliente], [nombresCliente], [apellidosCliente], [documentoIdentidad], [direccion], [telefono], [activo]) VALUES (3, N'Elias Javier', N'Hipolito Tafur', N'45812331111', N'calle leoncio prado # 8747', N'', 1)
INSERT [dbo].[Cliente] ([idCliente], [nombresCliente], [apellidosCliente], [documentoIdentidad], [direccion], [telefono], [activo]) VALUES (4, N'MARIA IHOANA', N'VASQUEZ CHAVEZ', N'20345678', N'LOS ALAMOS', N'123456789', 1)
INSERT [dbo].[Cliente] ([idCliente], [nombresCliente], [apellidosCliente], [documentoIdentidad], [direccion], [telefono], [activo]) VALUES (5, N'wilson', N'narro esquivel', N'70772628', N'ad12', N'qwe', 1)
INSERT [dbo].[Cliente] ([idCliente], [nombresCliente], [apellidosCliente], [documentoIdentidad], [direccion], [telefono], [activo]) VALUES (7, N'wilson', N'narro', N'12232322111', N'los rosales', N'', 1)
SET IDENTITY_INSERT [dbo].[Cliente] OFF
SET IDENTITY_INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ON 

INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (1, 1, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (2, 2, N'SOBRE MANILA COLOR AZUL', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (3, 2, N'SOBRE MANILA COLOR AMARILLO', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (4, 3, N'cajas de papeles', CAST(25.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (5, 4, N'cajas de papeles', CAST(25.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (6, 4, N'FOLDER MANILA', CAST(5.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (7, 5, N'bolsa de productos', CAST(30.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (8, 5, N'caja de golosinas', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (9, 6, N'cajas de papeles', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (10, 7, N'cajas de papeles', CAST(40.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (11, 8, N'juego de libros', CAST(35.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (12, 9, N'cajas de papeles', CAST(40.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (13, 10, N'FOLDER MANILA', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (14, 11, N'cajas de papeles', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (15, 12, N'cajas de papeles', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (16, 13, N'cajas de papeles', CAST(5.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (17, 14, N'cajas de papeles', CAST(8.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (18, 15, N'cajas de papeles', CAST(5.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (19, 16, N'FOLDER MANILA', CAST(35.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (20, 17, N'cajas de papeles', CAST(45.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (21, 18, N'cajas de papeles', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (22, 19, N'cajas de papeles', CAST(30.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (23, 20, N'FOLDER MANILA', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (24, 21, N'cajas de papeles', CAST(30.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (25, 22, N'cajas de papeles', CAST(5.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (26, 23, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (27, 24, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (28, 25, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[DetalleDocumentoEnvioEncomienda] ([idDetalle], [idDocumentoEnvio], [descripcion], [precioVenta], [cantidad]) VALUES (29, 26, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
SET IDENTITY_INSERT [dbo].[DetalleDocumentoEnvioEncomienda] OFF
SET IDENTITY_INSERT [dbo].[DocumentoEnvioEncomienda] ON 

INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (1, 1, N'001', N'00000001', 1, 2, CAST(0x0000A46400000000 AS DateTime), CAST(0x0000A4AB01662620 AS DateTime), NULL, NULL, 1, 2, NULL, 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (2, 1, N'001', N'00000002', 3, 2, CAST(0x0000A46400000000 AS DateTime), CAST(0x0000A4AB01662620 AS DateTime), NULL, NULL, 1, 2, NULL, 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (3, 2, N'002', N'00000002', 1, 3, CAST(0x0000A4AA00828B9A AS DateTime), CAST(0x0000A4AB0166C968 AS DateTime), N'', N'', 1, 4, N'los cedros nro 2310', 1, 0, N'ENTREGADO', 1, 1, 4, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (4, 15, N'008', N'00000002', 3, 1, CAST(0x0000A4AA0085EA9E AS DateTime), CAST(0x0000A4AA008671C1 AS DateTime), N'', N'', 4, 1, N'', 1, 1, N'ENTREGADO', 4, 1, 1, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (5, 1, N'001', N'00000002', 4, 1, CAST(0x0000A4AA0088EF52 AS DateTime), CAST(0x0000A4AB01667C97 AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (6, 1, N'001', N'00000003', 3, 1, CAST(0x0000A4AB00EAC5DD AS DateTime), CAST(0x0000A4AB01667C97 AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (7, 1, N'001', N'00000004', 3, 1, CAST(0x0000A4AB00EB807B AS DateTime), CAST(0x0000A4AB01667C97 AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (8, 1, N'001', N'00000005', 3, 1, CAST(0x0000A4AB00EEDC9B AS DateTime), CAST(0x0000A4AB0166B22B AS DateTime), N'', N'', 1, 4, N'', 0, 0, N'ENTREGADO', 1, 1, 4, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (9, 1, N'001', N'00000006', 4, 3, CAST(0x0000A4AB01016CB5 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (10, 1, N'001', N'00000007', 4, 3, CAST(0x0000A4AB01031D71 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (11, 1, N'001', N'00000008', 4, 3, CAST(0x0000A4AB011EA46D AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (12, 1, N'001', N'00000009', 4, 3, CAST(0x0000A4AB01214325 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (13, 1, N'001', N'00000010', 4, 3, CAST(0x0000A4AB01337309 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (14, 3, N'003', N'00000002', 4, 3, CAST(0x0000A4AB01340699 AS DateTime), CAST(0x0000A4AB016220A2 AS DateTime), N'los datos deben coincidir', N'12345678', 2, 1, N'', 0, 0, N'ENTREGADO', 2, 1, 1, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (15, 1, N'001', N'00000011', 4, 3, CAST(0x0000A4AB01357C59 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'los datos deben coincidir', N'12345623', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (16, 3, N'003', N'00000003', 4, 3, CAST(0x0000A4AB0138FC99 AS DateTime), CAST(0x0000A4AB016220A2 AS DateTime), N'', N'12345677', 2, 1, N'', 0, 0, N'ENTREGADO', 2, 1, 1, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (17, 3, N'003', N'00000004', 4, 3, CAST(0x0000A4AB01392025 AS DateTime), CAST(0x0000A4AB016220A2 AS DateTime), N'', N'12345677', 2, 1, N'', 0, 0, N'ENTREGADO', 2, 1, 1, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (18, 1, N'001', N'00000012', 4, 3, CAST(0x0000A4AB013996FE AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (19, 1, N'001', N'00000013', 4, 3, CAST(0x0000A4AB0139D089 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (20, 1, N'001', N'00000014', 4, 3, CAST(0x0000A4AB013A71C9 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'', N'12345678', 1, 2, N'', 0, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (21, 1, N'001', N'00000015', 4, 3, CAST(0x0000A4AB013D0C0D AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'los datos deben coincidir', N'12345678', 1, 2, N'', 1, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (22, 1, N'001', N'00000016', 4, 3, CAST(0x0000A4AB013F311E AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'los datos deben coincidir', N'12345678', 1, 2, N'', 1, 0, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (23, 1, N'001', N'00000017', 4, 3, CAST(0x0000A4AB015B3D4E AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'qwe', N'12354877', 1, 2, N'', 0, 1, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (24, 1, N'001', N'00000018', 4, 3, CAST(0x0000A4AB015BB143 AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'qwe', N'12354877', 1, 2, N'', 0, 1, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (25, 1, N'001', N'00000019', 4, 3, CAST(0x0000A4AB0162488B AS DateTime), CAST(0x0000A4AB0165017A AS DateTime), N'qweqwewqe', N'12312234', 1, 2, N'', 0, 1, N'ENTREGADO', 1, 1, 2, 1)
INSERT [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio], [idDocumentoPago], [serieDocumentoPago], [numeroDocumentoPago], [idRemitente], [idDestinatario], [fechaSalida], [fechaEntrega], [nombreResponsableRecojo], [dniResponsableRecojo], [idSucursalOrigen], [idSucursalDestino], [direccionDestino], [aDomicilio], [contraEntrega], [estadoDocumento], [idUsuario], [pagado], [idUsuarioEntrega], [activo]) VALUES (26, 1, N'001', N'00000020', 4, 3, CAST(0x0000A4AB0168EA41 AS DateTime), CAST(0x0000A4AB01690061 AS DateTime), N'qweqwewqe', N'12354877', 1, 2, N'', 0, 1, N'ENTREGADO', 1, 1, 2, 1)
SET IDENTITY_INSERT [dbo].[DocumentoEnvioEncomienda] OFF
SET IDENTITY_INSERT [dbo].[DocumentoPago] ON 

INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (1, N'001', N'00000020', N'BOLETA ', 1, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (2, N'002', N'00000002', N'FACTURA', 1, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (3, N'003', N'00000004', N'BOLETA ', 2, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (4, N'004', N'00000001', N'FACTURA', 2, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (5, N'005', N'00000001', N'BOLETA ', 3, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (9, N'006', N'00000001', N'FACTURA', 3, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (13, N'007', N'00000001', N'BOLETA ', 4, 1)
INSERT [dbo].[DocumentoPago] ([idDocumentoPago], [serie], [numero], [descripcion], [idSucursal], [activo]) VALUES (15, N'008', N'00000002', N'FACTURA', 4, 1)
SET IDENTITY_INSERT [dbo].[DocumentoPago] OFF
SET IDENTITY_INSERT [dbo].[PrecioBase] ON 

INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (1, 2, 1, N'SOBRE', CAST(8.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (2, 1, 2, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (3, 4, 1, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (4, 1, 4, N'SOBRE', CAST(5.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (5, 2, 1, N'CAJA MEDIANA', CAST(35.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (6, 1, 2, N'CAJA MEDIANA', CAST(30.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (7, 4, 1, N'CAJA MEDIANA', CAST(25.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (8, 1, 4, N'CAJA MEDIANA', CAST(25.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (9, 2, 1, N'CAJA GRANDE', CAST(45.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (10, 1, 2, N'CAJA GRANDE', CAST(40.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (11, 4, 1, N'CAJA GRANDE', CAST(35.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[PrecioBase] ([idPrecioBase], [idSucursalOrigen], [idSucursalDestino], [descripcion], [precio], [activo]) VALUES (12, 1, 4, N'CAJA GRANDE', CAST(35.00 AS Decimal(6, 2)), 1)
SET IDENTITY_INSERT [dbo].[PrecioBase] OFF
SET IDENTITY_INSERT [dbo].[Sucursal] ON 

INSERT [dbo].[Sucursal] ([idSucursal], [nombreCiudad], [direccion], [telefono], [activo]) VALUES (1, N'TRUJILLO', N'Av España # 1254', N'554748', 1)
INSERT [dbo].[Sucursal] ([idSucursal], [nombreCiudad], [direccion], [telefono], [activo]) VALUES (2, N'LIMA', N'', N'', 1)
INSERT [dbo].[Sucursal] ([idSucursal], [nombreCiudad], [direccion], [telefono], [activo]) VALUES (3, N'PIURA', N'', N'', 1)
INSERT [dbo].[Sucursal] ([idSucursal], [nombreCiudad], [direccion], [telefono], [activo]) VALUES (4, N'CHIMBOTE', N'', N'', 1)
SET IDENTITY_INSERT [dbo].[Sucursal] OFF
SET IDENTITY_INSERT [dbo].[Usuario] ON 

INSERT [dbo].[Usuario] ([idUsuario], [usuario], [clave], [nombreUsuario], [apellidosUsuario], [documentoIdentidad], [direccion], [telefono], [cargo], [idSucursal], [activo]) VALUES (1, N'Weyne', N'123456', N'Wilson Edward Yoel', N'Narro Esquivel', N'70775854', N'Pasaje Jesus de nazareth 306 - Alto Mochica', N'', N'CARGO', 1, 1)
INSERT [dbo].[Usuario] ([idUsuario], [usuario], [clave], [nombreUsuario], [apellidosUsuario], [documentoIdentidad], [direccion], [telefono], [cargo], [idSucursal], [activo]) VALUES (2, N'jjjp', N'123456', N'Joseph Junior', N'Jacinto Paredes', N'78542154', N'av panamerica # 1254', N'', N'CARGO', 2, 1)
INSERT [dbo].[Usuario] ([idUsuario], [usuario], [clave], [nombreUsuario], [apellidosUsuario], [documentoIdentidad], [direccion], [telefono], [cargo], [idSucursal], [activo]) VALUES (3, N'cgn', N'123456', N'Carlos', N'Garcia Navarro', N'78541254', N'av america norte # 1254', N'', N'CARGO', 3, 1)
INSERT [dbo].[Usuario] ([idUsuario], [usuario], [clave], [nombreUsuario], [apellidosUsuario], [documentoIdentidad], [direccion], [telefono], [cargo], [idSucursal], [activo]) VALUES (4, N'jccs', N'123456', N'Juan Carlos', N'Capcha Sanchez', N'74859632', N'av mansiche S/N', N'', N'CARGO', 4, 1)
SET IDENTITY_INSERT [dbo].[Usuario] OFF
ALTER TABLE [dbo].[Cliente] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] ADD  DEFAULT ((0)) FOR [aDomicilio]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] ADD  DEFAULT ((0)) FOR [contraEntrega]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] ADD  DEFAULT ((0)) FOR [pagado]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] ADD  DEFAULT ((0)) FOR [idUsuarioEntrega]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[DocumentoPago] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[PrecioBase] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[Sucursal] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[DetalleDocumentoEnvioEncomienda]  WITH CHECK ADD  CONSTRAINT [FK_DETALLEDOCUMENTOENVIOENCOMIENDA_DOCUMENTOENVIOENCOMIENDA] FOREIGN KEY([idDocumentoEnvio])
REFERENCES [dbo].[DocumentoEnvioEncomienda] ([idDocumentoEnvio])
GO
ALTER TABLE [dbo].[DetalleDocumentoEnvioEncomienda] CHECK CONSTRAINT [FK_DETALLEDOCUMENTOENVIOENCOMIENDA_DOCUMENTOENVIOENCOMIENDA]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_CLIENTE] FOREIGN KEY([idRemitente])
REFERENCES [dbo].[Cliente] ([idCliente])
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] CHECK CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_CLIENTE]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_CLIENTE1] FOREIGN KEY([idDestinatario])
REFERENCES [dbo].[Cliente] ([idCliente])
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] CHECK CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_CLIENTE1]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_SUCURSAL] FOREIGN KEY([idSucursalOrigen])
REFERENCES [dbo].[Sucursal] ([idSucursal])
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] CHECK CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_SUCURSAL]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_SUCURSAL1] FOREIGN KEY([idSucursalDestino])
REFERENCES [dbo].[Sucursal] ([idSucursal])
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] CHECK CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_SUCURSAL1]
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_USUARIO] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuario] ([idUsuario])
GO
ALTER TABLE [dbo].[DocumentoEnvioEncomienda] CHECK CONSTRAINT [FK_DOCUMENTOENVIOENCOMIENDA_USUARIO]
GO
ALTER TABLE [dbo].[DocumentoPago]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENTO_PAGO_SUCURSAL] FOREIGN KEY([idSucursal])
REFERENCES [dbo].[Sucursal] ([idSucursal])
GO
ALTER TABLE [dbo].[DocumentoPago] CHECK CONSTRAINT [FK_DOCUMENTO_PAGO_SUCURSAL]
GO
ALTER TABLE [dbo].[PrecioBase]  WITH CHECK ADD  CONSTRAINT [FK_PRECIOBASE_SUCURSAL] FOREIGN KEY([idSucursalOrigen])
REFERENCES [dbo].[Sucursal] ([idSucursal])
GO
ALTER TABLE [dbo].[PrecioBase] CHECK CONSTRAINT [FK_PRECIOBASE_SUCURSAL]
GO
ALTER TABLE [dbo].[PrecioBase]  WITH CHECK ADD  CONSTRAINT [FK_PRECIOBASE_SUCURSAL1] FOREIGN KEY([idSucursalDestino])
REFERENCES [dbo].[Sucursal] ([idSucursal])
GO
ALTER TABLE [dbo].[PrecioBase] CHECK CONSTRAINT [FK_PRECIOBASE_SUCURSAL1]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_USUARIO_SUCURSAL] FOREIGN KEY([idSucursal])
REFERENCES [dbo].[Sucursal] ([idSucursal])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_USUARIO_SUCURSAL]
GO
USE [master]
GO
ALTER DATABASE [SISTEMA_ENVIOS] SET  READ_WRITE 
GO
