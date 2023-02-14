<%-- 
    Document   : ProductoCatView
    Created on : 12-17-2020, 11:29:54 AM
    Author     : Moises Romero
    Owner      : Cloud IT Systems, S.A
--%>
<%@page import="model.DaoProducto"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%
    String DirActual = request.getContextPath();
    int Msg = 0;
    String Mensaje = "";
    if (request.getAttribute("Msg") != null) {
        Msg = Integer.valueOf(request.getAttribute("Msg").toString());
        Mensaje = request.getAttribute("Mensaje").toString();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">        
        <%--ESTILOS DEL FRAMEWORK BOOTSTRAP --%>
        <link rel="stylesheet" href="<%=DirActual%>/css/bootstrap.css">
        <link rel="stylesheet" href="<%=DirActual%>/css/bootstrap-select.css">
        <link rel="stylesheet" href="<%=DirActual%>/css/EstiloTablas.css">
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
        <script type="text/javascript">
            //FUNCION PARA VALIDAR ERRORS EN PANTALLA..
            function valida(form) {
                var error = true;
                var PRODNAME = $("#PRODNAME").val().trim();//NOMBRE DEL PRODUCTO
                var PRODDESCXS = $("#PRODDESCXS").val().trim();//DESCRIPCION CORTA
                var PRODCOD = $("#PRODCOD").val().trim();//CODIGO DEL PRODUCTO
                var PRODIDTYP = $("#PRODIDTYP").val();//ID TIPO PRODUCTO          
                var PRODIDUNIT = $("#PRODIDUNIT").val();//ID UNIDAD MEDIDA
                var PRODIDCAT = $("#PRODIDCAT").val();//ID CATEGORIA
                var PRODPREC1 = $("#PRODPREC1").val();//PRECIO 1
                var PRODLOTE = $("#PRODLOTE").val();//PROD CONTROLADO X LOTE?
                var PRODSERIE = $("#PRODSERIE").val();//PROD CONTROLADO X SERIE?
                if (PRODNAME === "" && PRODNAME.length === 0) {
                    error = false;
                    document.getElementById("tab1Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-1"]').tab('show');
                    $("#PRODNAME").focus();
                    alert("Ingrese Nombre del Producto");
                } else if (PRODDESCXS === "" && PRODDESCXS.length === 0) {
                    error = false;
                    document.getElementById("tab1Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-1"]').tab('show');
                    $("#PRODDESCXS").focus();
                    alert("Ingrese al menos una Descripcion Corta del Producto");
                } else if (PRODCOD === "" && PRODCOD.length === 0) {
                    error = false;
                    document.getElementById("tab2Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-2"]').tab('show');
                    $("#PRODCOD").focus();
                    alert("Ingrese Codigo del Producto");
                } else if (PRODIDTYP === "0") {
                    error = false;
                    document.getElementById("tab3Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-3"]').tab('show');
                    $("#PRODIDTYP").focus();
                    alert("Seleccion Un Tipo de Producto");
                } else if (PRODIDUNIT === "0") {
                    error = false;
                    document.getElementById("tab3Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-3"]').tab('show');
                    $("#PRODIDUNIT").focus();
                    alert("Seleccion Unidad de Medida");
                } else if (PRODIDCAT === "0") {
                    error = false;
                    document.getElementById("tab3Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-3"]').tab('show');
                    $("#PRODIDCAT").focus();
                    alert("Selecciona una Categoria");
                } else if (PRODPREC1 === "" || PRODPREC1 === "0" || PRODPREC1 === "0.00" || PRODPREC1 === "0.0") {
                    error = false;
                    document.getElementById("tab4Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-4"]').tab('show');
                    $("#PRODPREC1").focus();
                    alert("Ingrese al menos un Precio de Venta");
                } else if (PRODLOTE === "S" && PRODSERIE === "S") {
                    error = false;
                    document.getElementById("tab5Error").style.display = 'inline';
                    $('.nav-tabs a[href="#tab-5"]').tab('show');
                    $("#PRODLOTE").focus();
                    alert("Solo Puede Seleccionar Uno Lote ó Serie.!");
                } else if (error === true) {
                    form.btnBack.disabled = true;
                    form.btnClean.disabled = true;
                    form.btnAgregar.disabled = true;
                    form.btnSalir.disabled = true;
                    form.submit();
                }
                return error;
            }
        </script>
        <script type="text/javascript">
            //FUNCION PARA LIMPIAR ICONO DE ERROR..
            function cleanSpan(span) {
                document.getElementById(span).style.display = 'none';
            }
        </script>
        <title>Catalogo Producto</title>
    </head>
    <%@include file="../../../Commons/Menu.jsp" %>
    <%        //RECUPERO VARIABLES. SI EL SERVLET ENVIA ALGUN ERROR.
        int PRODIDCOMP = Integer.valueOf(session.getAttribute("CompanyId").toString());//*--LLAVE FORANEA COMPAÑIA ID--*/
        int PRODID = request.getParameter("PRODID") == null ? 0 : Integer.valueOf(request.getParameter("PRODID"));//
        int PRODIDUNIT = request.getParameter("PRODIDUNIT") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNIT"));//
        String PRODTIPO = request.getParameter("PRODTIPO") == null ? "B" : request.getParameter("PRODTIPO");//TIPO PRODUCTO: B:BIENES; S:SERVICIO        
        int PRODIDTYP = request.getParameter("PRODIDTYP") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDTYP"));//
        int PRODIDCAT = request.getParameter("PRODIDCAT") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDCAT"));//
        int PRODIDMARCA = request.getParameter("PRODIDMARCA") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDMARCA"));//
        int PRODIDFABR = request.getParameter("PRODIDFABR") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDFABR"));//
        String PRODCOD = request.getParameter("PRODCOD") == null ? "" : request.getParameter("PRODCOD");//'CODIGO DEL PRODUCTO',
        String PRODEAN = request.getParameter("PRODEAN") == null ? "" : request.getParameter("PRODEAN");//'NUMERO DE PRODUCTO EUROPEO',
        String PRODSKU = request.getParameter("PRODSKU") == null ? "" : request.getParameter("PRODSKU");//'CODIGO SKU DEL PRODUCTO',
        String PRODUPC = request.getParameter("PRODUPC") == null ? "" : request.getParameter("PRODUPC");//'CODIGO UNIVERSAL DEL PRODUCTO',
        String PRODNAME = request.getParameter("PRODNAME") == null ? "" : request.getParameter("PRODNAME");//'NOMBRE DEL PRODUCTO',
        String PRODDESCXS = request.getParameter("PRODDESCXS") == null ? "" : request.getParameter("PRODDESCXS");//'DESCRIPCION CORTA DEL PRODUCTO',
        String PRODDESCLG = request.getParameter("PRODDESCLG") == null ? "" : request.getParameter("PRODDESCLG");//'DESCRIPCION LARGA DEL PRODUCTO',
        double PRODLASTCOST = request.getParameter("PRODLASTCOST") == null ? 0.00 : Double.valueOf(request.getParameter("PRODLASTCOST"));//'COSTO DE ULTIMA COMPRA DEL PRODUCTO',
        double PRODCOSTPROM = request.getParameter("PRODCOSTPROM") == null ? 0.00 : Double.valueOf(request.getParameter("PRODCOSTPROM"));//'COSTO PROMEDIO DE COMPRA DEL PRODUCTO',
        int PRODIDCURR = request.getParameter("PRODIDCURR") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDCURR"));//ID CURRENCY DEL PRODUCTO
        double PRODPREC1 = request.getParameter("PRODPREC1") == null ? 0.00 : Double.valueOf(request.getParameter("PRODPREC1"));//'PRECIO 1 DEL PRODUCTO',
        double PRODPREC2 = request.getParameter("PRODPREC2") == null ? 0.00 : Double.valueOf(request.getParameter("PRODPREC2"));//'PRECIO 2 DEL PRODUCTO',
        double PRODPREC3 = request.getParameter("PRODPREC3") == null ? 0.00 : Double.valueOf(request.getParameter("PRODPREC3"));//'PRECIO 3 DEL PRODUCTO',
        double PRODPREC4 = request.getParameter("PRODPREC4") == null ? 0.00 : Double.valueOf(request.getParameter("PRODPREC4"));//'PRECIO 4 DEL PRODUCTO',
        double PRODDESC = request.getParameter("PRODDESC") == null ? 0.00 : Double.valueOf(request.getParameter("PRODDESC"));//'DESCUENTO DEL PRODUCTO',
        String PRODIVA = request.getParameter("PRODIVA") == null ? "S" : request.getParameter("PRODIVA");//'SE LE APLICARA IVA AL PRODUCTO',
        double PRODDAI = request.getParameter("PRODDAI") == null ? 0.00 : Double.valueOf(request.getParameter("PRODDAI"));//Decimal (21,6) NOT NULL COMMENT 'PORCENTAJE PARA EL CALCULO DEL DAI',
        double PRODISC = request.getParameter("PRODISC") == null ? 0.00 : Double.valueOf(request.getParameter("PRODISC"));//Decimal (21,6) NOT NULL COMMENT 'PORCENTAJE PARA EL CALCULO DE ISC',
        String PRODLOTE = request.getParameter("PRODLOTE") == null ? "N" : request.getParameter("PRODLOTE");//'SE MANEJARA POR LOTE?',
        double PRODLONG = request.getParameter("PRODLONG") == null ? 0.00 : Double.valueOf(request.getParameter("PRODLONG"));//'LARGO DEL PRODUCTO',
        int PRODIDUNITLG = request.getParameter("PRODIDUNITLG") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNITLG"));//'ID UNIDAD DE MEDIDA DEL LARGO DEL PRODUCTO',
        double PRODWIDTH = request.getParameter("PRODWIDTH") == null ? 0.00 : Double.valueOf(request.getParameter("PRODWIDTH"));//'ANCHO DEL PRODUCTO',
        int PRODIDUNITWD = request.getParameter("PRODIDUNITWD") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNITWD"));//'ID UNIDAD DE MEDIDA DEL ANCHO DEL PRODUCTO',
        double PRODHEIGHT = request.getParameter("PRODHEIGHT") == null ? 0.00 : Double.valueOf(request.getParameter("PRODHEIGHT"));//'ALTURA DEL PRODUCTO',
        int PRODIDUNITHG = request.getParameter("PRODIDUNITHG") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNITHG"));//'ID UNIDAD DE MEDIDA DEL ALTO DEL PRODUCTO',
        double PRODWEIGHT = request.getParameter("PRODWEIGHT") == null ? 0.00 : Double.valueOf(request.getParameter("PRODWEIGHT"));//'PESO BRUTO DEL PRODUCTO',
        int PRODIDUNITWG = request.getParameter("PRODIDUNITWG") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNITWG"));//'ID UNIDAD DE MEDIDA DEL PESO BRUTO DEL PRODUCTO',
        double PRODVOLM = request.getParameter("PRODVOLM") == null ? 0.00 : Double.valueOf(request.getParameter("PRODVOLM"));//'VOLUMEN DEL PRODUCTO',
        int PRODIDUNITVOLM = request.getParameter("PRODIDUNITVOLM") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNITVOLM"));//'ID UNIDAD DE MEDIDA DEL VOLUMEN DEL PRODUCTO',
        double PRODTEMP = request.getParameter("PRODTEMP") == null ? 0.00 : Double.valueOf(request.getParameter("PRODTEMP"));//'TEMPERATURA DEL PRODUCTO',
        int PRODIDUNITTEMP = request.getParameter("PRODIDUNITTEMP") == null ? 0 : Integer.valueOf(request.getParameter("PRODIDUNITTEMP"));//'ID UNIDAD DE MEDIDA DEL LA TEMPERATURA DEL PRODUCTO',        
        String PRODSERIE = request.getParameter("PRODSERIE") == null ? "N" : request.getParameter("PRODSERIE");//'SE MANEJARA POR NUMERO DE SERIE.?',
        String PRODMODELO = request.getParameter("PRODMODELO") == null ? "" : request.getParameter("PRODMODELO");//'MODELO DEL PRODUCTO',
        String PRODOTRO1 = request.getParameter("PRODOTRO1") == null ? "" : request.getParameter("PRODOTRO1");//'CAMPO OTRO 1 DEL PRODUCTO',
        String PRODOTRO2 = request.getParameter("PRODOTRO2") == null ? "" : request.getParameter("PRODOTRO2");//'CAMPO OTRO 2 DEL PRODUCTO',
        double PRODSTCKMIN = request.getParameter("PRODSTCKMIN") == null ? 0.00 : Double.valueOf(request.getParameter("PRODSTCKMIN"));//'CANTIDAD MINIMA A TENER EN STOCK',
        double PRODSTCKMAX = request.getParameter("PRODSTCKMAX") == null ? 0.00 : Double.valueOf(request.getParameter("PRODSTCKMAX"));//'CANTIDAD MAXIMA A TENER EN STOCK',
        String PRODACTV = request.getParameter("PRODACTV") == null ? "S" : request.getParameter("PRODACTV");//'ACTIVO SI:NO'
        String PRODNEWWHO = request.getParameter("PRODNEWWHO") == null ? "" : request.getParameter("PRODNEWWHO");//'AGREGADO POR '
        String PRODNEWDT = request.getParameter("PRODNEWDT") == null ? "" : request.getParameter("PRODNEWDT");//'AGREGADO EL'
        String PRODCHGWHO = request.getParameter("PRODCHGWHO") == null ? "" : request.getParameter("PRODCHGWHO");//'ACTUALIZADO POR'
        String PRODCHGDT = request.getParameter("PRODCHGDT") == null ? "" : request.getParameter("PRODCHGDT");//'ACTUALIZADO EL'

        DaoProducto producto = new DaoProducto();
        producto.GetDataProd(PRODIDCOMP, PRODID);
        if (PRODID > 0) {
            PRODIDUNIT = producto.PRODIDUNIT;
            PRODTIPO = producto.PRODTIPO;
            PRODIDTYP = producto.PRODIDTYP;
            PRODIDCAT = producto.PRODIDCAT;
            PRODIDMARCA = producto.PRODIDMARCA;
            PRODIDFABR = producto.PRODIDFABR;
            PRODCOD = producto.PRODCOD;
            PRODEAN = producto.PRODEAN;
            PRODSKU = producto.PRODSKU;
            PRODUPC = producto.PRODUPC;
            PRODNAME = producto.PRODNAME;
            PRODDESCXS = producto.PRODDESCXS;
            PRODDESCLG = producto.PRODDESCLG;
            PRODLASTCOST = producto.PRODLASTCOST;
            PRODCOSTPROM = producto.PRODCOSTPROM;
            PRODIDCURR = producto.PRODIDCURR;
            PRODPREC1 = producto.PRODPREC1;
            PRODPREC2 = producto.PRODPREC2;
            PRODPREC3 = producto.PRODPREC3;
            PRODPREC4 = producto.PRODPREC4;
            PRODDESC = producto.PRODDESC;
            PRODIVA = producto.PRODIVA;
            //PRODDAI = producto.PRODDAI;
            //PRODISC = producto.PRODISC;
            PRODLOTE = producto.PRODLOTE;
            PRODLONG = producto.PRODLONG;//'LARGO DEL PRODUCTO',
            PRODIDUNITLG = producto.PRODIDUNITLG;//'ID UNIDAD DE MEDIDA DEL LARGO DEL PRODUCTO',
            PRODWIDTH = producto.PRODWIDTH;//'ANCHO DEL PRODUCTO',
            PRODIDUNITWD = producto.PRODIDUNITWD;//'ID UNIDAD DE MEDIDA DEL ANCHO DEL PRODUCTO',
            PRODHEIGHT = producto.PRODHEIGHT;//'ALTURA DEL PRODUCTO',
            PRODIDUNITHG = producto.PRODIDUNITHG;//'ID UNIDAD DE MEDIDA DEL ALTO DEL PRODUCTO',
            PRODWEIGHT = producto.PRODWEIGHT;//'PESO BRUTO DEL PRODUCTO',
            PRODIDUNITWG = producto.PRODIDUNITWG;//'ID UNIDAD DE MEDIDA DEL PESO BRUTO DEL PRODUCTO',
            PRODVOLM = producto.PRODVOLM;//'VOLUMEN DEL PRODUCTO',
            PRODIDUNITVOLM = producto.PRODIDUNITVOLM;//'ID UNIDAD DE MEDIDA DEL VOLUMEN DEL PRODUCTO',
            PRODTEMP = producto.PRODTEMP;//'TEMPERATURA DEL PRODUCTO',
            PRODIDUNITTEMP = producto.PRODIDUNITTEMP;//'ID UNIDAD DE MEDIDA DEL LA TEMPERATURA DEL PRODUCTO',
            PRODSERIE = producto.PRODSERIE;
            PRODMODELO = producto.PRODMODELO;//NOT NULL COMMENT 'MODELO DEL PRODUCTO',
            PRODOTRO1 = producto.PRODOTRO1;//NOT NULL COMMENT 'CAMPO OTRO 1 DEL PRODUCTO',
            PRODOTRO2 = producto.PRODOTRO2;//NOT NULL COMMENT 'CAMPO OTRO 2 DEL PRODUCTO',
            PRODSTCKMIN = producto.PRODSTCKMIN;
            PRODSTCKMAX = producto.PRODSTCKMAX;
            PRODACTV = producto.PRODACTV;
            PRODNEWWHO = producto.PRODNEWWHO;
            PRODNEWDT = producto.PRODNEWDT;
            PRODCHGWHO = producto.PRODCHGWHO;
            PRODCHGDT = producto.PRODCHGDT;
        }

    %>
    <body>
        <div id="EncabezadoPagina" style="background-color: #4682B4;">
            <center>
                <h1 style="color: #FFFFFF; text-align: center;">Ficha Tecnica del Producto</h1>                
            </center>
        </div>
        <ul class="nav nav-tabs" id="tabOptionProd" name="tabOptionProd" role="tablist">
            <li class="nav-item">
                <a class="btn btn-outline-primary active" id="nav-tab-1" data-toggle="tab" href="#tab-1" role="tab" aria-controls="tab-1" aria-selected="true">
                    Datos 
                    <span class="badge badge-danger" id="tab1Error" name="tab1Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>
                </a>
            </li>
            <li class="nav-item">
                <a class="btn btn-outline-primary" id="nav-tab-2" data-toggle="tab" href="#tab-2" role="tab" aria-controls="tab-2" aria-selected="false">
                    Identificacion
                    <span class="badge badge-danger" id="tab2Error" name="tab2Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>                
                </a>
            </li>
            <li class="nav-item">
                <a class="btn btn-outline-primary" id="nav-tab-3" data-toggle="tab" href="#tab-3" role="tab" aria-controls="tab-3" aria-selected="false">
                    Clasificacion
                    <span class="badge badge-danger" id="tab3Error" name="tab3Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>                
                </a>
            </li>
            <li class="nav-item">
                <a class="btn btn-outline-primary" id="nav-tab-7" data-toggle="tab" href="#tab-7" role="tab" aria-controls="tab-7" aria-selected="false">
                    Almacen
                    <span class="badge badge-danger" id="tab7Error" name="tab7Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>                
                </a>
            </li>            
            <li class="nav-item">
                <a class="btn btn-outline-primary" id="nav-tab-4" data-toggle="tab" href="#tab-4" role="tab" aria-controls="tab-4" aria-selected="false">
                    Costo Compra & Precios
                    <span class="badge badge-danger" id="tab4Error" name="tab4Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>                
                </a>
            </li>            
            <li class="nav-item">
                <a class="btn btn-outline-primary" id="nav-tab-5" data-toggle="tab" href="#tab-5" role="tab" aria-controls="tab-5" aria-selected="false">
                    Descuento & Iva
                    <span class="badge badge-danger" id="tab5Error" name="tab5Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>                
                </a>
            </li>                        
            <li class="nav-item" hidden="true">
                <a class="btn btn-outline-primary" id="nav-tab-6" data-toggle="tab" href="#tab-6" role="tab" aria-controls="tab-6" aria-selected="false">
                    Multimedia
                    <span class="badge badge-danger" id="tab6Error" name="tab6Error" style="display: none;">
                        <i class="icon ion-information"> Error</i></span>                
                </a>
            </li>            
        </ul>
        <form id="AddProducto" role='form' action='<%=DirActual%>/ServletProducto' method='POST'>
            <input type="text" class="form-control" id="form-Accion" name="form-Accion" value="PRODUCTO" hidden="true">
            <input type="text" class="form-control" id="AccionDB" name="AccionDB" value="UPDPROD" hidden="true">
            <input type="number" class="form-control" id="PRODID" name="PRODID" value="<%=PRODID%>" hidden="true">
            <%--DIV PARA CONTROLAR LOS MENSAJES EN PANTALLA REGRESADO DESDE EL SERVLET--%>
            <%if (Msg == 1) {%>
            <div id="DivMensaje" name="DivMensaje" class="alert alert-danger alert-dismissible col-9" role="alert">
                <Center><strong><h3 id="Mensaje" name="Mensaje"><%=Mensaje%>!!!</h3></strong></Center>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <%}%>
            <%--FIN DE DIV PARA CONTROLAR LOS MENSAJES EN PANTALLA REGRESADO DESDE EL SERVLET--%>
            <div class="tab-content" id="tabContenProducto" name="tabContenProducto">
                <%--DIV PARA CONTROLAR LOS MENSAJES EN PANTALLA --%>
                <div id="DivDataProd" name="DivDataProd" class="alert alert-warning alert-dismissible col-sm-10" role="alert" style="display: none;">
                    <Center><strong><h3 id="MsgDataProd" name="MsgDataProd">Revisar Parametros!!!</h3></strong></Center>
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <%--FIN DE DIV PARA CONTROLAR LOS MENSAJES EN PANTALLA --%>                
                <div class="tab-pane fade show active" id="tab-1" name="tab-1" role="tabpanel" aria-labelledby="tab-1">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Nombre</strong></span>
                        <input type="text" class="form-control col-sm-6" id="PRODNAME" name="PRODNAME" placeholder="Ingresa Nombre Tipo Producto...." required="true" style="text-align: center" minlength="1" maxlength="1200" onkeyup="cleanSpan('tab1Error');" value="<%=PRODNAME%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Descripcion Corta</strong></span>                        
                        <textarea class="form-control col-sm-6" rows="3" id="PRODDESCXS" name="PRODDESCXS" placeholder="Descripcion Corta del Producto" minlength="1" maxlength="130" required="true" style="resize: none;" onkeyup="cleanSpan('tab1Error');" disabled="true"><%=PRODDESCXS%></textarea>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Descripcion Larga</strong></span>                        
                        <textarea class="form-control col-sm-6" rows="3" id="PRODDESCLG" name="PRODDESCLG" placeholder="Descripcion Corta del Producto" minlength="0" maxlength="250" style="resize: none;" onkeyup="cleanSpan('tab1Error');" disabled="true"><%=PRODDESCLG%></textarea>
                    </div>                    
                </div>
                <div class="tab-pane fade" id="tab-2" name="tab-2" role="tabpanel" aria-labelledby="tab-2">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Codigo Catalogo</strong></span>
                        <input type="text" class="form-control col-sm-6" id="PRODCOD" name="PRODCOD" placeholder="Ingresa Codigo del Producto...." required="true" style="text-align: center" minlength="1" maxlength="50" onkeyup="cleanSpan('tab2Error');" value="<%=PRODCOD%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Codigo EAN</strong></span>
                        <input type="text" class="form-control col-sm-6" id="PRODEAN" name="PRODEAN" placeholder="Ingresa Codigo EAN del Producto...." style="text-align: center" maxlength="50" onkeyup="cleanSpan('tab2Error');" value="<%=PRODEAN%>" disabled="true">
                    </div>                    
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Codigo SKU</strong></span>
                        <input type="text" class="form-control col-sm-6" id="PRODSKU" name="PRODSKU" placeholder="Ingresa Codigo SKU del Producto...." style="text-align: center" maxlength="50" onkeyup="cleanSpan('tab2Error');" value="<%=PRODSKU%>" disabled="true">
                    </div>                    
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Codigo UPC</strong></span>
                        <input type="text" class="form-control col-sm-6" id="PRODUPC" name="PRODUPC" placeholder="Ingresa Codigo UPC del Producto...." style="text-align: center" maxlength="50" onkeyup="cleanSpan('tab2Error');" value="<%=PRODUPC%>" disabled="true">
                    </div>                                        
                </div>
                <div class="tab-pane fade" id="tab-3" name="tab-3" role="tabpanel" aria-labelledby="tab-3">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Tipo</strong></span>
                        <label class="form-control radio-inline col-sm-3" style="text-align: center;">
                            <input type="radio" required="true" name="PRODTIPO" value="B" <%=PRODTIPO.equals("B") ? "checked='true'" : ""%> disabled="true">Bienes
                            <input type="radio" required="true" name="PRODTIPO" value="S" <%=PRODTIPO.equals("S") ? "checked='true'" : ""%> disabled="true">Servicios
                        </label>
                    </div>                    
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Tipo Producto</strong></span>
                        <select class="form-control col-sm-3" id="PRODIDTYP" name="PRODIDTYP" style="text-align: center" onchange="cleanSpan('tab3Error');" <%=PRODIDTYP > 0 ? "disabled='true'" : ""%>>
                            <option value="0" >Selecciona Tipo Producto</option>
                            <% try {
                                    ConexionDB conn = new ConexionDB();
                                    conn.Conectar();
                                    String consulta = "Select TYPPRODIDCOMP, TYPPRODID, TYPNAME FROM UBTYPPROD WHERE TYPPRODIDCOMP=" + CompanyId + " ORDER BY TYPNAME ASC";
                                    ResultSet rs = null;
                                    PreparedStatement pst = null;
                                    pst = conn.conexion.prepareStatement(consulta);
                                    rs = pst.executeQuery();
                                    while (rs.next()) {
                                        if (PRODIDTYP > 0 && PRODIDTYP == rs.getInt("TYPPRODID")) {
                                            out.println("<option selected='true' value='" + rs.getInt("TYPPRODID") + "'>" + rs.getString("TYPNAME") + "</option>");
                                        } else {
                                            out.println("<option value='" + rs.getInt("TYPPRODID") + "'>" + rs.getString("TYPNAME") + "</option>");
                                        }
                                    }; // fin while 
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                    
                                } //fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Marca : " + e.getMessage());
                                };%>   
                        </select>
                    </div>                    
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Unidad Medida</strong></span>
                        <select class="form-control col-sm-3" id="PRODIDUNIT" name="PRODIDUNIT" style="text-align: center" onchange="cleanSpan('tab3Error');" <%=PRODIDUNIT > 0 ? "disabled='true'" : ""%>>
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM UBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNIT > 0 && PRODIDUNIT == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Categoria & Tipo Categoria</strong></span>
                        <select class="form-control col-sm-3" id="PRODIDCAT" name="PRODIDCAT" style="text-align: center" onchange="cleanSpan('tab3Error');" <%=PRODIDCAT > 0 ? "disabled='true'" : ""%>>
                            <option value="0" >Selecciona Categoria</option>                            
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBCATTYPPROD WHERE TYPCATIDCOMP=" + CompanyId + " AND TYPCATESTAT='S' ORDER BY TYPCATNAM ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("TYPCATNAM")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM UBCATPROD WHERE CATPRODIDCOMP=" + CompanyId + " AND CATTYPID=" + rs.getInt("TYPCATID") + "  ORDER BY CATPRODTOPLVLID,CATPRODPARENTID,CATPRODLEVEL"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDCAT > 0 && PRODIDCAT == rs2.getInt("CATPRODID")) {%>
                                <option selected='true' value="<%=rs2.getInt("CATPRODID")%>"><%=rs2.getString("CATPRODNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("CATPRODID")%>"><%=rs2.getString("CATPRODNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Categorias: " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Categorias : " + e.getMessage());
                                };%>
                        </select>
                    </div>                    
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Marca</strong></span>                       
                        <select class="form-control col-sm-3" id="PRODIDMARCA" name="PRODIDMARCA" style="text-align: center" onchange="cleanSpan('tab3Error');" disabled="true">
                            <option value="0" >Selecciona Marca</option>                            
                            <% try {
                                    ConexionDB conn = new ConexionDB();
                                    conn.Conectar();
                                    String consulta = "Select MCIDCOMP, MCIDMARCA, MCNAME FROM UBMARCA WHERE MCIDCOMP=" + CompanyId + " ORDER BY MCNAME ASC";
                                    ResultSet rs = null;
                                    PreparedStatement pst = null;
                                    pst = conn.conexion.prepareStatement(consulta);
                                    rs = pst.executeQuery();
                                    while (rs.next()) {
                                        if (PRODIDMARCA > 0 && PRODIDMARCA == rs.getInt("MCIDMARCA")) {
                                            out.println("<option selected='true' value='" + rs.getInt("MCIDMARCA") + "'>" + rs.getString("MCNAME") + "</option>");
                                        } else {
                                            out.println("<option value='" + rs.getInt("MCIDMARCA") + "'>" + rs.getString("MCNAME") + "</option>");
                                        }
                                    }; // fin while 
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                    
                                } //fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Marca : " + e.getMessage());
                                };%>   
                        </select>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Fabricante</strong></span>                                         
                        <select class="form-control col-sm-3" id="PRODIDFABR" name="PRODIDFABR" style="text-align: center" onchange="cleanSpan('tab3Error');" disabled="true">
                            <option value="0" >Selecciona Fabricante</option>
                            <% try {
                                    ConexionDB conn = new ConexionDB();
                                    conn.Conectar();
                                    String consulta = "Select FABIDCOMP, FABIDSEQNC, FABNAME FROM UBFABRICANTE WHERE FABIDCOMP=" + CompanyId + " ORDER BY FABNAME ASC";
                                    ResultSet rs = null;
                                    PreparedStatement pst = null;
                                    pst = conn.conexion.prepareStatement(consulta);
                                    rs = pst.executeQuery();
                                    while (rs.next()) {
                                        if (PRODIDFABR > 0 && PRODIDFABR == rs.getInt("FABIDSEQNC")) {
                                            out.println("<option selected='true' value='" + rs.getInt("FABIDSEQNC") + "'>" + rs.getString("FABNAME") + "</option>");
                                        } else {
                                            out.println("<option value='" + rs.getInt("FABIDSEQNC") + "'>" + rs.getString("FABNAME") + "</option>");
                                        }
                                    }; // fin while 
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                    
                                } //fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Marca : " + e.getMessage());
                                };%>   
                        </select>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Modelo</strong></span>
                        <input type="text" class="form-control col-sm-3" id="PRODMODELO" name="PRODMODELO" placeholder="Modelos del Producto" style="text-align: center" maxlength="200" onkeyup="cleanSpan('tab2Error');" value="<%=PRODMODELO%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-3"><strong>Otro 1</strong></span>
                        <input type="text" class="form-control col-sm-3" id="PRODOTRO1" name="PRODOTRO1" placeholder="Otro 1.." style="text-align: center" maxlength="200" onkeyup="cleanSpan('tab2Error');" value="<%=PRODOTRO1%>" disabled="true">
                        <span class="input-group-addon col-sm-3"><strong>Otro 2</strong></span>
                        <input type="text" class="form-control col-sm-3" id="PRODOTRO2" name="PRODOTRO2" placeholder="Otro 2.." style="text-align: center" maxlength="200" onkeyup="cleanSpan('tab2Error');" value="<%=PRODOTRO2%>" disabled="true">
                    </div>                        
                </div>
                <div class="tab-pane fade" id="tab-4" name="tab-4" role="tabpanel" aria-labelledby="tab-4">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Ultimo Costo de Compra</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-4" id="PRODLASTCOST" name="PRODLASTCOST" min="0" required="true" placeholder="Ultimo Costo de Compra..." style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODLASTCOST%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Costo Promedio de Compra</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-4" id="PRODCOSTPROM" name="PRODCOSTPROM" min="0" required="true" placeholder="Costo Compra Promedio..." style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODCOSTPROM%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2" style="text-align: center;"><strong>Moneda</strong></span>
                        <select class="form-control col-sm-2" id="PRODIDCURR" name="PRODIDCURR" required="true" disabled="true">
                            <%--<option value="0">Seleccione una Moneda</option>--%>
                            <%try {
                                    ConexionDB conn = new ConexionDB();
                                    conn.Conectar();
                                    ResultSet rs = null;
                                    PreparedStatement pst = null;
                                    pst = conn.conexion.prepareStatement("SELECT CURRID, DESCR FROM UBUNCURRENCY WHERE CompanyId=" + CompanyId + " ORDER BY CURRID");
                                    rs = pst.executeQuery();
                                    while (rs.next()) {
                                        if (PRODIDCURR != 0 && PRODIDCURR == rs.getInt(1)) {
                                            out.println("<option selected='true' class='text-default' value='" + rs.getInt(1) + "'>" + rs.getString(2) + "</option>");
                                        } else {
                                            out.println("<option class='text-default' value='" + rs.getInt(1) + "'>" + rs.getString(2) + "</option>");
                                        }
                                    } // fin while 
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS
                                } //fin try no usar ; al final de dos o mas catchs
                                catch (SQLException e) {
                                    System.err.println("Error en Cargar Moneda: " + e.getMessage());
                                }
                            %>
                        </select>
                    </div>                    
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Precio Venta 1</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-4" id="PRODPREC1" name="PRODPREC1" min="0" required="true" placeholder="Precio Venta..." style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODPREC1%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Precio Venta 2</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-4" id="PRODPREC2" name="PRODPREC2" min="0" placeholder="Precio Venta..." style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODPREC2%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Precio Venta 3</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-4" id="PRODPREC3" name="PRODPREC3" min="0" placeholder="Precio Venta..." style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODPREC3%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Precio Venta 4</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-4" id="PRODPREC4" name="PRODPREC4" min="0" placeholder="Precio Venta..." style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODPREC4%>" disabled="true">
                    </div>  
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>DAI %</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-2" id="PRODDAI" name="PRODDAI" min="0" placeholder="Porcentaje DAI" style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODDAI%>" disabled="true">
                        <span class="input-group-addon col-sm-1"><strong>ISC %</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-1" id="PRODISC" name="PRODISC" min="0" placeholder="Porcentaje ISC" style="text-align: center" onkeyup="cleanSpan('tab4Error');" value="<%=PRODISC%>" disabled="true">                        
                    </div>
                </div>
                <div class="tab-pane fade" id="tab-5" name="tab-5" role="tabpanel" aria-labelledby="tab-5">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Descuento</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODDESC" name="PRODDESC" min="0" placeholder="Ingresar Descuento..." style="text-align: center" onkeyup="cleanSpan('tab5Error');" value="<%=PRODDESC%>" disabled="true">
                        <span class="input-group-addon col-sm-1"><strong>%</strong></span>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Iva</strong></span>
                        <label class="form-control radio-inline col-sm-3" style="text-align: center;">
                            <input type="radio" required="true" name="PRODIVA" value="N" <%=PRODIVA.equals("N") ? "checked='true'" : ""%> disabled="true">No
                            <input type="radio" required="true" name="PRODIVA" value="S" <%=PRODIVA.equals("S") ? "checked='true'" : ""%> disabled="true">Si
                        </label>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Controlado Por Lote.?</strong></span>
                        <label class="form-control radio-inline col-sm-3" style="text-align: center;">
                            <input type="radio" required="true" name="PRODLOTE" value="N" <%=PRODLOTE.equals("N") ? "checked='true'" : ""%> disabled="true">No
                            <input type="radio" required="true" name="PRODLOTE" value="S" <%=PRODLOTE.equals("S") ? "checked='true'" : ""%> disabled="true">Si
                        </label>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Controlado Por # Serie.?</strong></span>
                        <label class="form-control radio-inline col-sm-3" style="text-align: center;">
                            <input type="radio" required="true" name="PRODSERIE" value="N" <%=PRODSERIE.equals("N") ? "checked='true'" : ""%> disabled="true">No
                            <input type="radio" required="true" name="PRODSERIE" value="S" <%=PRODSERIE.equals("S") ? "checked='true'" : ""%> disabled="true">Si
                        </label>
                    </div>                        
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Stock Minimo</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODSTCKMIN" name="PRODSTCKMIN" min="0" placeholder="Ingresar Stock Minimo..." required="true" style="text-align: center" onkeyup="cleanSpan('tab5Error');" value="<%=PRODSTCKMIN%>" disabled="true">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Stock Maximo</strong></span>                        
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODSTCKMAX" name="PRODSTCKMAX" min="0" placeholder="Ingresar Stock Maximo..." required="true" style="text-align: center" onkeyup="cleanSpan('tab5Error');" value="<%=PRODSTCKMAX%>" disabled="true">
                    </div>
                </div>
                <div class="tab-pane fade" id="tab-6" name="tab-6" role="tabpanel" aria-labelledby="tab-6" hidden="true">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Foto</strong></span>                        
                        <input type="file" class="form-control col-sm-4" id="Foto" name="Foto" style="text-align: center" disabled="true">
                    </div>
                </div>                            
                <div class="tab-pane fade" id="tab-7" name="tab-7" role="tabpanel" aria-labelledby="tab-7">
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Dimensión (L x A x A)</strong></span>
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODLONG" name="PRODLONG" min="0" required="true" style="text-align: center" onkeyup="cleanSpan('tab7Error');" value="<%=PRODLONG%>" disabled="true">
                        <select class="form-control col-sm-3" id="PRODIDUNITLG" name="PRODIDUNITLG" style="text-align: center" onchange="cleanSpan('tab7Error');" disabled="true">
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM IBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNITLG > 0 && PRODIDUNITLG == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>                        
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODWIDTH" name="PRODWIDTH" min="0" required="true" style="text-align: center" onkeyup="cleanSpan('tab7Error');" value="<%=PRODWIDTH%>" disabled="true">
                        <select class="form-control col-sm-3" id="PRODIDUNITWD" name="PRODIDUNITWD" style="text-align: center" onchange="cleanSpan('tab7Error');" disabled="true">
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM IBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNITWD > 0 && PRODIDUNITWD == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>                         
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODHEIGHT" name="PRODHEIGHT" min="0" required="true" style="text-align: center" onkeyup="cleanSpan('tab7Error');" value="<%=PRODHEIGHT%>" disabled="true">
                        <select class="form-control col-sm-3" id="PRODIDUNITHG" name="PRODIDUNITHG" style="text-align: center" onchange="cleanSpan('tab7Error');" disabled="true">
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM IBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNITHG > 0 && PRODIDUNITHG == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>                        
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Peso Bruto</strong></span>
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODWEIGHT" name="PRODWEIGHT" min="0" required="true" style="text-align: center" onkeyup="cleanSpan('tab7Error');" value="<%=PRODWEIGHT%>" disabled="true">
                        <select class="form-control col-sm-3" id="PRODIDUNITWG" name="PRODIDUNITWG" style="text-align: center" onchange="cleanSpan('tab7Error');" disabled="true">
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM IBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNITWG > 0 && PRODIDUNITWG == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>                                               
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Volumen</strong></span>
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODVOLM" name="PRODVOLM" min="0" required="true" style="text-align: center" onkeyup="cleanSpan('tab7Error');" value="<%=PRODVOLM%>" disabled="true">
                        <select class="form-control col-sm-3" id="PRODIDUNITVOLM" name="PRODIDUNITVOLM" style="text-align: center" onchange="cleanSpan('tab7Error');" disabled="true">
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM IBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNITVOLM > 0 && PRODIDUNITVOLM == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon col-sm-2"><strong>Temperatura</strong></span>
                        <input type="number" step="any" class="form-control col-sm-3" id="PRODTEMP" name="PRODTEMP" min="0" required="true" style="text-align: center" onkeyup="cleanSpan('tab7Error');" value="<%=PRODTEMP%>" disabled="true" disabled="true">
                        <select class="form-control col-sm-3" id="PRODIDUNITTEMP" name="PRODIDUNITTEMP" style="text-align: center" onchange="cleanSpan('tab7Error');" disabled="true">
                            <option value="0" >Selecciona Unidad Medida</option>
                            <%try {
                                    ConexionDB conn = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                    conn.Conectar(); //ABRO LA CONEXION A LA BD
                                    ResultSet rs = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                    PreparedStatement pst = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD 
                                    pst = conn.conexion.prepareStatement("SELECT * FROM UBUNMSTYPE WHERE UMTYPCOMPID=" + CompanyId + " AND UMTYPACT='S' ORDER BY UMTYPNAME ASC"); //LE PASO LA CONSULTA A EJECUTAR
                                    rs = pst.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                    //CON EL EL WHILE RECORRO LOS RESULTADOS 
                                    while (rs.next()) {%>
                            <optgroup  label="<%=rs.getString("UMTYPNAME")%>">
                                <%
                                    try {
                                        ConexionDB conn2 = new ConexionDB(); //IMPORTO LA CLASE DONDE MANEJO LA CONEXION A BASE DE DATOS.
                                        conn2.Conectar(); //ABRO LA CONEXION A LA BD
                                        ResultSet rs2 = null; // DECLARO VARIABLE QUE CONTENDRA LOS RESULTADOS DE LA CONSULTA
                                        PreparedStatement pst2 = null; //VARIBLE PARA EJECUTAR LA CONSULTA EN LA BD                     
                                        pst2 = conn2.conexion.prepareStatement("SELECT * FROM UBUNITMESAURE WHERE UMCOMPID=" + CompanyId + " AND UMIDTYP=" + rs.getInt("UMTYPID") + "  ORDER BY UMNAME"); //LE PASO LA CONSULTA A EJECUTAR
                                        rs2 = pst2.executeQuery();//CON ESTE COMANDO EJECUTO LA CONSULTA
                                        while (rs2.next()) {%>
                                <%if (PRODIDUNITTEMP > 0 && PRODIDUNITTEMP == rs2.getInt("UMID")) {%>
                                <option selected='true' value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%} else {%>
                                <option value="<%=rs2.getInt("UMID")%>"><%=rs2.getString("UMNAME")%></option>
                                <%}%>
                                <%};//FIN DE WHILE 2, QUE RECORE LAS CATEGORIAS.
                                        rs2.close(); //CIERRO LA CONEXION DEL RESULSET.
                                        pst2.close(); //CIERRO EL PREPARED STATEMENT.
                                        conn2.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                    } //Fin try no usar ; al final de dos o mas catchs 
                                    catch (SQLException e) {
                                        System.out.println("Error en Unidad de Medida " + e.getMessage());
                                    };%>
                            </optgroup>    
                            <%}; // Fin while 1 QUE RECORRE LOS TIPOS DE CATEGORIAS
                                    rs.close(); //CIERRO LA CONEXION DEL RESULSET.
                                    pst.close(); //CIERRO EL PREPARED STATEMENT.
                                    conn.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS                                            
                                } //Fin try no usar ; al final de dos o mas catchs 
                                catch (SQLException e) {
                                    System.out.println("Error en Tipo de Unidad de Medida : " + e.getMessage());
                                };%>
                        </select>                 
                    </div>
                </div>            
            </div>
            <br>
            <div class="row form-group justify-content-md-center">
                <div class="col-2"> 
                    <a class="btn btn-primary" href="javascript:history.back(-1);" title="Ir la página anterior">
                        <i class="icon ion-arrow-return-left"></i> 
                        Pagina Anterior
                    </a>     
                </div>
                <div class="col-sm-2"> 
                    <button type="button" id="btnSalir" name="btnSalir" class="btn btn-danger" onclick='location.href = "<%=DirActual%>/Principal.jsp"'>
                        <i class="icon ion-android-cancel"></i> 
                        Salir
                    </button>
                </div>
            </div>
        </form>
        <br>
        <div class="row form-group justify-content-md-center offset-2">
            <div class="input-group"><%--DIV PARA MOSTRAR LA INFO DEL USUARIO QUE HIZO LA TRANSACCION, FECHA E IP--%>
                <span class="input-group-addon col-2"><strong>Creado Por</strong></span>
                <input class="form-control col-2" id="PRODNEWWHO" name="PRODNEWWHO" type="text" style="text-align: center" readonly="true" value="<%=PRODNEWWHO%>">
                <span class="input-group-addon col-2"><strong>Actualizado Por</strong></span>
                <input class="form-control col-2" id="PRODNEWDT" name="PRODNEWDT" type="text" style="text-align: center" readonly="true" value="<%=PRODCHGWHO%>">                
            </div><%--FIN DE DIV PARA MOSTRAR LA INFO DEL USUARIO QUE HIZO LA TRANSACCION, FECHA E IP--%>            
            <div class="input-group"><%--DIV PARA MOSTRAR LA INFO DEL USUARIO QUE HIZO LA TRANSACCION, FECHA E IP--%>
                <span class="input-group-addon col-2"><strong>Fecha y Hora</strong></span>
                <input class="form-control col-2" id="PRODCHGWHO" name="PRODCHGWHO" type="text" style="text-align: center" readonly="true" value="<%=PRODNEWDT%>">
                <span class="input-group-addon col-2"><strong>Fecha y Hora</strong></span>
                <input class="form-control col-2" id="PRODCHGDT" name="PRODCHGDT" type="text" style="text-align: center" readonly="true" value="<%=PRODCHGDT%>">
            </div><%--FIN DE DIV PARA MOSTRAR LA INFO DEL USUARIO QUE HIZO LA TRANSACCION, FECHA E IP--%>
        </div>
    </body>
</html>
