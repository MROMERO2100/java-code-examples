<%-- 
    Document   : ProductoCatFind
    Created on : 11-25-2020, 11:38:41 AM
    Author     : Moises Romero
    Owner      : Cloud IT Systems, S.A
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="beans.ConexionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String DirActual = request.getContextPath();
    int POVENDID = 0;

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">        
        <%--ESTILOS DEL FRAMEWORK BOOTSTRAP --%>
        <link rel="stylesheet" href="<%=DirActual%>/css/bootstrap.css">
        <link rel="stylesheet" href="<%=DirActual%>/css/bootstrap-select.css">
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
        <script>
            $(function () {
                $("#grupoTablas").tabs();
            });
        </script>
        <script type="text/javascript">
            //FUNCION PARA VALIDAR EL INGRESO DE PARAMETROS
            function valida() {
                var ok = true;
                var msg = "";
                var CheckVendor = document.getElementById('CheckVendor').checked; //CHECKBOX BUSCAR X #OC...
                var POVENDID = $('#POVENDID').val();//ID DE PROVEEDOR
                var CheckNumOC = document.getElementById('CheckNumOC').checked;
                var POIDSEQNCE = $('#POIDSEQNCE').val();//NUMERO OC
                var CheckRangoFecha = document.getElementById('CheckRangoFecha').checked; //CHECKBOX RANGO FECHA..
                var FechaDesde = $("#FechaDesde").datepicker("getDate"); //FECHA DESDE..
                var FechaHasta = $("#FechaHasta").datepicker("getDate"); //FECHA HASTA..
                var CheckDescripcion = document.getElementById('CheckDescripcion').checked; //CHECKBOX DESCRIPCION...
                var POMEMO = $('#POMEMO').val();//DESCRIPCION A BUSCAR
                var CheckEstatusOC = document.getElementById('CheckEstatusOC').checked; //CHECKBOX ESTATUS...
                var POSTATUS = $('#POSTATUS').val();//ESTATUS A BUSCAR

                if (CheckVendor === true && POVENDID === "0" && POVENDID === 0) {
                    ok = false;
                    msg = "Favor Selecciona Un Proveedor!";
                    $("#POVENDID").focus();
                }
                if (CheckNumOC === true && POIDSEQNCE === "0" && POIDSEQNCE === 0) {
                    ok = false;
                    msg = "Favor Ingrese Numero de OC..!!";
                    $("#POIDSEQNCE").focus();
                }
                if (CheckRangoFecha === true) {
                    if (FechaDesde > FechaHasta) {
                        ok = false;
                        msg = "Fecha Inicial no puede ser mayor a Fecha Final";
                        $("#FechaDesde").focus();
                    }
                }
                if (CheckDescripcion === true && POMEMO.length === 0 && POMEMO === "") {
                    ok = false;
                    msg = "Favor Ingrese una Descripcion.!";
                    $("#POMEMO").focus();
                }
                if (CheckEstatusOC === true && POSTATUS === "" && POSTATUS === null && POSTATUS.length === 0) {
                    ok = false;
                    msg = "Favor Seleccione un Estatus.!";
                    $("#POSTATUS").focus();
                }
                if (ok === false)
                    alert(msg);
                return ok;
            }//FIN FUNCION VALIDAR PARAMETROS..

            //FUNCION PARA LIMPIAR LOS CAMPOS DE ENTIDADES.
            function Limpiar() {
                $("#POVENDID").val('0').selectpicker("refresh");
            }
        </script>
        <title>Busqueda Producto</title>
    </head>
    <%@include file="../../../Commons/Menu.jsp" %>
    <body>
        <div id="EncabezadoPagina" style="background-color: #4682B4;">
            <center>
                <h1 style="color: #FFFFFF; text-align: center;">Buscar Producto</h1>
            </center>
        </div>
        <%-- FORMULARIO PARA MANDAR A BUSCAR PRODUCTOS--%>
        <form id="BuscarProducto" role='form' action='ProductoCatList.jsp' method='POST' onsubmit="return valida(this)">
            <div class="offset-2">
                <div id="tab-1"><%-- DIV DE PARAMETROS PARA LA BUSQUEDA DE ORDENES DE COMPRA --%>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2" style="text-align: left;">
                            <input type="checkbox" id="CheckCodProd" name="CheckCodProd">
                            <strong>Codigo Producto</strong>
                        </span>
                        <input id="PRODCOD" name="PRODCOD" class="form-control col-sm-2" placeholder="Codigo Producto" style="text-align: center" value="">
                        <span class="input-group-addon col-sm-2" style="text-align: left;">
                            <input type="checkbox" id="CheckCodEAN" name="CheckCodEAN">
                            <strong>Codigo EAN</strong>
                        </span>
                        <input id="PRODEAN" name="PRODEAN" class="form-control col-sm-2" placeholder="Codigo EAN" style="text-align: center" value="">                        
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2" style="text-align: left;">
                            <input type="checkbox" id="CheckCodSKU" name="CheckCodSKU">
                            <strong>Codigo SKU</strong>
                        </span>
                        <input id="PRODSKU" name="PRODSKU" class="form-control col-sm-2" placeholder="Codigo SKU" style="text-align: center" value="">
                        <span class="input-group-addon col-sm-2" style="text-align: left;">
                            <input type="checkbox" id="CheckCodUPC" name="CheckCodUPC">
                            <strong>Codigo UPC</strong>
                        </span>
                        <input id="PRODUPC" name="PRODUPC" class="form-control col-sm-2" placeholder="Codigo UPC" style="text-align: center" value="">                        
                    </div>
                    <div class="input-group checkbox-inline">
                        <span class="input-group-addon col-sm-2" style="text-align: left;">
                            <input type="checkbox" id="CheckDescripcion" name="CheckDescripcion">
                            <strong>Descripcion Corta</strong>
                        </span>
                        <input type="text" class="form-control col-sm-6" id="PRODDESCXS" name="PRODDESCXS">
                    </div>
                    <div class="input-group checkbox-inline">
                        <span class="input-group-addon col-sm-2" style="text-align: left;">
                            <input type="checkbox" id="CheckEstatus" name="CheckEstatus">
                            <strong>Estatus</strong>
                        </span>
                        <%-- ESTATUS DEL PRODUCTO--%>
                        <select required="true" class="form-control col-sm-2" id="PRODACTV" name="PRODACTV" style="text-align: center">
                            <option value="S" >Activo</option>
                            <option value="N" >Inactivo</option>
                        </select>
                    </div>
                </div><%--FIN DIV DE PARAMETROS PARA LA BUSQUEDA DE FACTURAS --%>
                <br>
                <div class="row form-group">
                    <div class="col-sm-2"> 
                        <button type="button" onclick='location.href = "<%=DirActual%>/CatalogoProductos/Producto/ProductoCatalogo/ProductoCatFind.jsp"' class='btn btn-dark'>
                            <i class="icon ion-android-cancel"></i> 
                            Cancelar
                        </button>
                    </div>
                    <div class="col-sm-2"> 
                        <button type="submit" class="btn btn-info" id="btnBuscar" name="btnBuscar" >
                            <i class="icon ion-search"></i>
                            Mostrar Resultados
                        </button>
                    </div>                            
                    <div class="col-sm-2"> 
                        <button type="button" onclick='location.href = "<%=DirActual%>/CatalogoProductos/Producto/ProductoCatalogo/ProductoCatAdd.jsp"' class='btn btn-success'>
                            <i class="icon ion-plus"></i>
                            Nuevo Producto
                        </button>
                    </div>
                    <div class="col-sm-2"> 
                        <button type="button" class="btn btn-danger" onclick='location.href = "<%=DirActual%>/Principal.jsp"'>
                            <i class="icon ion-android-exit"></i> 
                            Salir
                        </button>
                    </div>
                </div>
            </div><%--FIN DIV GRUPO DE TABS--%>       
        </form> <%--FIN FORMULARIO PARA MANDAR A BUSCAR UN COMPROBANTE--%>
    </body>
</html>