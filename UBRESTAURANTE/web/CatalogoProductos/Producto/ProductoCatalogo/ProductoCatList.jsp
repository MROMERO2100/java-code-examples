<%-- 
    Document   : ProductoCatList
    Created on : 04-13-2020, 01:54:05 PM
    Author     : Moises Romero
    Owner      : Cloud IT Systems, S.A
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="beans.ConexionDB"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String DirActual = request.getContextPath();
    int Msg = 0;
    String Mensaje = "";
    if (request.getParameter("Msg") != null) {
        Msg = Integer.valueOf(request.getParameter("Msg"));
        Mensaje = request.getAttribute("Mensaje").toString();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">        
        <%--ESTILOS DEL FRAMEWORK BOOTSTRAP --%>
        <link rel="stylesheet" href="<%=DirActual%>/css/bootstrap.css">
        <link rel="stylesheet" href="<%=DirActual%>/css/bootstrap-select.css">
        <link rel="stylesheet" href="<%=DirActual%>/css/EstiloTablas.css">
        <link rel="stylesheet" href="<%=DirActual%>/css/tableexport.css">
        <%--ESTILOS DEL FRAMEWORK IONICONS --%>
        <link rel="stylesheet" href="<%=DirActual%>/ionicons/css/ionicons.min.css">
        <%--JS DEL FRAMEWORK BOOTSTRAP Y JQUERY--%>
        <script src="<%=DirActual%>/js/jquery.min.js"></script>
        <script src="<%=DirActual%>/js/bootstrap.bundle.min.js"></script>
        <script src="<%=DirActual%>/js/bootstrap-select.js"></script>
        <script src="<%=DirActual%>/js/jquery-ui.min.js"></script>
        <script src="<%=DirActual%>/js/popper.min.js"></script>
        <script src="<%=DirActual%>/js/calendario.js"></script>
        <script src="<%=DirActual%>/js/cross-browser.js"></script>
        <script type="text/javascript" src="<%=DirActual%>/js/xlsx.core.min.js"></script>
        <script type="text/javascript" src="<%=DirActual%>/js/Blob.js"></script>
        <script type="text/javascript" src="<%=DirActual%>/js/FileSaver.js"></script>
        <script type="text/javascript" src="<%=DirActual%>/js/tableexport.js"></script>
        <script>
            //ESTA FUNCION SIRVE PARA FILTRAR LA BUSQUEDA POR NOMBRE
            $(document).ready(function () {
                $("#filtro").on("keyup", function () {
                    var value = $(this).val().toLowerCase();
                    $("#tblDatosProductoCatalago tr").filter(function () {
                        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                    });
                });
            });
        </script>        
        <title>Catalogo de Productos</title>
    </head>
    <%@include file="../../../Commons/Menu.jsp" %>
    <body>
        <div id="EncabezadoPagina" style="background-color: #4682B4;">
            <center>
                <h1 style="color: #FFFFFF; text-align: center;">Catalago de Productos</h1>
            </center>
        </div>
        <div id="BuscaProductoCat">
            <form id="FormBuscaProductoCat" role="form" action="#">
                <div class="input-group">
                    <span class="input-group-addon">Buscar</span>
                    <input id="filtro" name="filtro" type="text" value='' class="form-control" placeholder="Ingresa Filtro..." required="true">
                    <button type="button" onclick='location.href = "<%=DirActual%>/CatalogoProductos/Producto/ProductoCatalogo/ProductoCatAdd.jsp"' class='btn btn-success'>
                        <i class="icon ion-plus"></i>
                        Nuevo Producto
                    </button>
                </div>
            </form>
        </div>
        <div class="panel-body table table-responsive-sm" id="ListaCatalogoProducto" name="ListaCatalogoProducto">
            <table class="table table-sm table-hover table-striped" id="tblProductoCatalago" name="tblProductoCatalago">
                <thead style="background-color: #4682B4">
                    <tr>
                        <th style="color: #FFFFFF; text-align: center;"># ID</th>                  
                        <th style="color: #FFFFFF; text-align: left;">Nombre</th>
                        <th style="color: #FFFFFF; text-align: left;">Descripcion</th>                        
                        <th style="color: #FFFFFF; text-align: left;">Cod. Prod.</th>
                        <th style="color: #FFFFFF; text-align: left;">Marca</th>
                        <th style="color: #FFFFFF; text-align: left;">Categoria</th>                        
                        <th style="color: #FFFFFF; text-align: center;">Activo?</th>
                        <th style="color: #FFFFFF; text-align: center;">Acciones</th>
                    </tr>
                </thead>
                <tbody style="background-color: #C7C6C6;" id="tblDatosProductoCatalago">
                    <%try {
                            ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                            conn.Conectar(); //ABRO LA CONEXION A LA BD
                            ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                            PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                            pst = conn.conexion.prepareStatement("SELECT PRODID,PRODNAME,PRODDESCXS,PRODCOD,PRODEAN,PRODSKU,PRODUPC,PRODMODELO,PRODOTRO1,PRODOTRO2,(SELECT TYPNAME FROM UBTYPPROD WHERE TYPPRODIDCOMP=PRODIDCOMP AND TYPPRODID=PRODIDTYP) AS TIPOPROD,COALESCE((SELECT MCNAME FROM UBMARCA WHERE MCIDCOMP=PRODIDCOMP AND MCIDMARCA=PRODIDMARCA),'') AS MARCA,(SELECT CATPRODNAME FROM UBCATPROD WHERE CATPRODIDCOMP=PRODIDCOMP AND CATPRODID=PRODIDCAT) AS CATEGORIA,PRODACTV FROM UBPRODUCTO WHERE PRODIDCOMP=" + CompanyId); //LE PASO LA CONSULTA A EJECUTAR
                            rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                            //CON EL EL WHILE RECORRO LOS RESULTADOS 
                            while (rs.next()) {%>
                    <TR style='text-align: center;'>
                        <TD style="color: #000000; text-align: center;"><%=rs.getInt("PRODID")%></TD><%--//CODIGO DEL TIPO DE CAT.--%>
                        <TD style="color: #000000; text-align: left;"><%=rs.getString("PRODNAME")%></TD><%--//NOMBRE DEL TIPO DE CAT.--%>
                        <TD style="color: #000000; text-align: left;"><%=rs.getString("PRODDESCXS")%></TD><%--//DESCRPCION CORTA DEL PRODUCTO--%>
                        <TD style="color: #000000; text-align: left;"><%=rs.getString("PRODCOD")%></TD><%--//CODIGO DEL PRODUCTO--%>
                        <TD style="color: #000000; text-align: left;"><%=rs.getString("MARCA")%></TD><%--//MARCA DE PRODUCTO--%>
                        <TD style="color: #000000; text-align: left;"><%=rs.getString("CATEGORIA")%></TD><%--//CATEGORIA DE PRODUCTO--%>
                        <TD style="color: #000000; text-align: center;"><%=rs.getString("PRODACTV")%></TD><%--//ACTIVO? S=SI; N=NO;--%>
                        <TD>
                            <a class="btn btn-md btn-primary" href="ProductoCatUpd.jsp?PRODID=<%=rs.getInt("PRODID")%>"><i class="icon ion-edit" title="Editar"></i></a>
                            <a class="btn btn-md btn-info" href='ProductoCatView.jsp?PRODID=<%=rs.getInt("PRODID")%>'><i class="icon ion-eye" title="Ver"></i></a>
                        </TD>
                    </TR>
                    <%}; // Fin while 
                            rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                            pst.close(); //CIERRO EL PREPARED STATEMENT.
                            conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS
                        } //Fin try no usar ; al final de dos o mas catchs 
                        catch (SQLException e) {
                            System.out.println("Error: " + e.getMessage());
                        };%>
                </tbody>
            </table>     
        </div>
        <hr>
        <div class="row form-group justify-content-md-center">
            <div class="col-sm-2"> 
                <button type="button" onclick='location.href = "<%=DirActual%>/CatalogoProductos/Producto/ProductoCatalogo/ProductoCatAdd.jsp"' class='btn btn-success'>
                    <i class="icon ion-plus"></i>
                    Nuevo Producto
                </button>
            </div>
            <div class="col-sm-1"> 
                <button type="button" class="btn btn-danger" onclick='location.href = "<%=DirActual%>/Principal.jsp"'>
                    <i class="icon ion-android-exit"></i> 
                    Salir
                </button>
            </div>
        </div>
    </body>
</html>