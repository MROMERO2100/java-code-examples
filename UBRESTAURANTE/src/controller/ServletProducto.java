package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.DaoProducto;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @Document : ServletProducto
 * @Created on : 04-15-2020, 04:59:45 PM
 * @Author : Moises Romero
 * @Owner : Cloud IT Systems, S.A
 *
 */
public class ServletProducto extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();//RECUPERAMOS LA SESION ACTIVA
        String URL = ""; // ESTA VARIABLE SERA PARA MANEJAR LA URL
        int Msg = 0; // ESTA VARIABLE SERA PARA CONTROLAR LOS MENSAJES DE ERROR Y ENVIARLO A LA VISTA
        String Mensaje = ""; // ESTA VARIABLE SERA PARA CONTROLAR LOS MENSAJES DE ERROR Y ENVIARLO A LA VISTA
        String Accion = ""; //VARIABLE PARA EJECUTAR ACCION EN EL SERVLET
        String AccionDB = ""; //VARIABLE PARA EJECUTAR ACCION EN LA BASE DE DATOS
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
        String PRODFOTO = request.getParameter("PRODFOTO") == null ? "" : request.getParameter("PRODFOTO");//'RUTA DE LA FOTO',
        String WHO = session.getAttribute("usuario").toString();//USUARIO QUE HIZO LA TRANSACCION
        String IP = request.getRemoteAddr(); // IP DE USUARIO, QUE HIZO LA TRANS. "127.0.0.1";
        //OTRAS VARIABLES.
        String fieldName = "";
        String fileName = "";
        InputStream fileContent = null;
        int oldIdProd = 0;
        int newIdProd = 0;

        try {
            List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            //FOR PARA RECORRER TODO EL FORMULARIO, Y RECOGER CAMPO POR CAMPO.
            for (FileItem item : items) {
                if (item.isFormField()) {
                    //OBTENEMOS LOS DATOS QUE NO SON DE TIPO FILE (MULTIMEDIA)
                    fieldName = item.getFieldName();
                    String fieldValue = item.getString();
                    if (fieldName.equals("form-Accion")) {
                        Accion = fieldValue.trim();
                    }
                    if (fieldName.equals("AccionDB")) {
                        AccionDB = fieldValue.trim();
                    }                    
                    if (fieldName.equals("PRODID")) {
                        PRODID = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNIT")) {
                        PRODIDUNIT = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODTIPO")) {
                        PRODTIPO = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODIDTYP")) {
                        PRODIDTYP = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDCAT")) {
                        PRODIDCAT = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDMARCA")) {
                        PRODIDMARCA = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDFABR")) {
                        PRODIDFABR = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODCOD")) {
                        PRODCOD = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODEAN")) {
                        PRODEAN = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODSKU")) {
                        PRODSKU = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODUPC")) {
                        PRODUPC = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODNAME")) {
                        PRODNAME = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODDESCXS")) {
                        PRODDESCXS = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODDESCLG")) {
                        PRODDESCLG = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODLASTCOST")) {
                        PRODLASTCOST = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODCOSTPROM")) {
                        PRODCOSTPROM = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDCURR")) {
                        PRODIDCURR = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODPREC1")) {
                        PRODPREC1 = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODPREC2")) {
                        PRODPREC2 = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODPREC3")) {
                        PRODPREC3 = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODPREC4")) {
                        PRODPREC4 = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODDESC")) {
                        PRODDESC = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIVA")) {
                        PRODIVA = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODLOTE")) {
                        PRODLOTE = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODLONG")) {
                        PRODLONG = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODLONG")) {
                        PRODLONG = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNITLG")) {
                        PRODIDUNITLG = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODWIDTH")) {
                        PRODWIDTH = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNITWD")) {
                        PRODIDUNITWD = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODHEIGHT")) {
                        PRODHEIGHT = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNITHG")) {
                        PRODIDUNITHG = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODWEIGHT")) {
                        PRODWEIGHT = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNITWG")) {
                        PRODIDUNITWG = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODVOLM")) {
                        PRODVOLM = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNITVOLM")) {
                        PRODIDUNITVOLM = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODTEMP")) {
                        PRODTEMP = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODIDUNITTEMP")) {
                        PRODIDUNITTEMP = Integer.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODSERIE")) {
                        PRODSERIE = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODMODELO")) {
                        PRODMODELO = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODOTRO1")) {
                        PRODOTRO1 = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODOTRO2")) {
                        PRODOTRO2 = fieldValue.trim();
                    }
                    if (fieldName.equals("PRODSTCKMIN")) {
                        PRODSTCKMIN = Double.valueOf(fieldValue.trim());
                    }
                    if (fieldName.equals("PRODSTCKMAX")) {
                        PRODSTCKMAX = Double.valueOf(fieldValue.trim());
                    }
                } else {
                    //PROCESAMOS EL CAMPO FILE, PARA PODER SUBIR EL ACRVHIO
                    //fieldName = item.getFieldName();
                    //String fileName = FilenameUtils.getName(item.getName());
                    fileName = item.getName();
                    fileContent = item.getInputStream();
                }
            }//FIN DEL FOR PARA RECORRER TODO EL FORMULARIO, Y RECOGER CAMPO POR CAMPO.
        } catch (FileUploadException e) {
            throw new ServletException("Cannot parse multipart request.", e.getCause());
        }
        //IF MODULO PRDUCTO-CATALOGO DE PRODCUTOS-AGREGAR-ACTUALIZAR
        if (Accion.equals("PRODUCTO")) {
            DaoProducto producto = new DaoProducto();
            if (AccionDB.equals("ADDPROD")) {
                try {
                    if (producto.CheckNameProd(PRODIDCOMP, PRODID, PRODNAME)) {
                        Msg = 1;//NOMBRE PROVEEDOR YA EXISTE
                        Mensaje = "El  Nombre: '" + PRODNAME + "' Ya esta Registrado";
                        request.setAttribute("Msg", Msg);
                        request.setAttribute("Mensaje", Mensaje);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("CatalogoProductos/Producto/ProductoCatalogo/ProductoCatAdd.jsp");
                        dispatcher.forward(request, response);
                    } else if (producto.CheckCodProd(PRODIDCOMP, PRODID, PRODCOD)) {
                        Msg = 1;//NOMBRE PROVEEDOR YA EXISTE
                        Mensaje = "El  Codigo de Producto: '" + PRODCOD + "' Ya esta Registrado";
                        request.setAttribute("Msg", Msg);
                        request.setAttribute("Mensaje", Mensaje);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("CatalogoProductos/Producto/ProductoCatalogo/ProductoCatAdd.jsp");
                        dispatcher.forward(request, response);
                    } else {
                        oldIdProd = producto.getProductoId(PRODIDCOMP);
                        producto.PRODUC_ADD_UPD(PRODIDCOMP, PRODID, PRODIDUNIT, PRODTIPO, PRODIDTYP, PRODIDCAT, PRODIDMARCA, PRODIDFABR, PRODCOD, PRODEAN, PRODSKU, PRODUPC, PRODNAME, PRODDESCXS, PRODDESCLG, PRODLASTCOST, PRODCOSTPROM, PRODIDCURR, PRODPREC1, PRODPREC2, PRODPREC3, PRODPREC4, PRODDESC, PRODIVA, PRODLOTE, PRODLONG, PRODIDUNITLG, PRODWIDTH, PRODIDUNITWD, PRODHEIGHT, PRODIDUNITHG, PRODWEIGHT, PRODIDUNITWG, PRODVOLM, PRODIDUNITVOLM, PRODTEMP, PRODIDUNITTEMP, PRODSERIE, PRODMODELO, PRODOTRO1, PRODOTRO2, PRODSTCKMIN, PRODSTCKMAX, PRODFOTO, WHO, IP, "ADDPROD");
                        newIdProd = producto.getProductoId(PRODIDCOMP);
//                        if (newIdProd > oldIdProd) {
//                            String path = "/imgproductos/";
//                            File uploads = new File(path); //Carpeta donde se guardan los archivos
//                            uploads.mkdirs(); //Crea los directorios necesarios
//                            java.util.Date fecha = new Date();
//                            SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");//FORMATEO PARA FECHAS
//                            //File file = File.createTempFile(formatDate.format(fecha) + "-", "-" + fileName); //Evita que hayan dos archivos con el mismo nombre
//                            File file = File.createTempFile(formatDate.format(fecha) + "-", "-" + fileName, uploads); //Evita que hayan dos archivos con el mismo nombre
//                            Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
//                            String urlgenerada = file.toString();
//                            System.out.println("Url Generada: " + urlgenerada);
//                            //OBTENEMOS SOLO EL NOMBRE DEL ARCHIVO PARA MANDARLO CORRECTAMENTA VIA URL
//                            String nameFile = file.toString().substring(10);
//                            //String urlToPath = "/archivos/" + nameFile;
//                            PRODFOTO = nameFile;
//                            producto.PRODUC_ADD_UPD(PRODIDCOMP, PRODID, PRODIDUNIT, PRODTIPO, PRODIDTYP, PRODIDCAT, PRODIDMARCA, PRODIDFABR, PRODCOD, PRODEAN, PRODSKU, PRODUPC, PRODNAME, PRODDESCXS, PRODDESCLG, PRODLASTCOST, PRODCOSTPROM, PRODIDCURR, PRODPREC1, PRODPREC2, PRODPREC3, PRODPREC4, PRODDESC, PRODIVA, PRODLOTE, PRODLONG, PRODIDUNITLG, PRODWIDTH, PRODIDUNITWD, PRODHEIGHT, PRODIDUNITHG, PRODWEIGHT, PRODIDUNITWG, PRODVOLM, PRODIDUNITVOLM, PRODTEMP, PRODIDUNITTEMP, PRODSERIE, PRODMODELO, PRODOTRO1, PRODOTRO2, PRODSTCKMIN, PRODSTCKMAX, PRODFOTO, WHO, IP, "UPDPROD");
//                        }
                        URL = "CatalogoProductos/Producto/ProductoCatalogo/ProductoCatList.jsp";
                        response.sendRedirect(URL);
                    }
                } catch (IOException | SQLException | ServletException e) {
                    //Informar por consola
                    System.out.println("Error" + e.getMessage());
                }
            }//FIN DE IF PARA AGREGAR PRODUCTO
            if (AccionDB.equals("UPDPROD")) {
                try {
                    if (producto.CheckNameProd(PRODIDCOMP, PRODID, PRODNAME)) {
                        Msg = 1;//NOMBRE PROVEEDOR YA EXISTE
                        Mensaje = "El  Nombre: '" + PRODNAME + "' Ya esta Registrado";
                        request.setAttribute("Msg", Msg);
                        request.setAttribute("Mensaje", Mensaje);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("CatalogoProductos/Producto/ProductoCatalogo/ProductoCatUpd.jsp?PRODID=" + PRODID);
                        dispatcher.forward(request, response);
                    } else if (producto.CheckCodProd(PRODIDCOMP, PRODID, PRODCOD)) {
                        Msg = 1;//NOMBRE PROVEEDOR YA EXISTE
                        Mensaje = "El  Codigo de Producto: '" + PRODCOD + "' Ya esta Registrado";
                        request.setAttribute("Msg", Msg);
                        request.setAttribute("Mensaje", Mensaje);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("CatalogoProductos/Producto/ProductoCatalogo/ProductoCatUpd.jsp?PRODID=" + PRODID);
                        dispatcher.forward(request, response);
                    } else {
                        producto.PRODUC_ADD_UPD(PRODIDCOMP, PRODID, PRODIDUNIT, PRODTIPO, PRODIDTYP, PRODIDCAT, PRODIDMARCA, PRODIDFABR, PRODCOD, PRODEAN, PRODSKU, PRODUPC, PRODNAME, PRODDESCXS, PRODDESCLG, PRODLASTCOST, PRODCOSTPROM, PRODIDCURR, PRODPREC1, PRODPREC2, PRODPREC3, PRODPREC4, PRODDESC, PRODIVA, PRODLOTE, PRODLONG, PRODIDUNITLG, PRODWIDTH, PRODIDUNITWD, PRODHEIGHT, PRODIDUNITHG, PRODWEIGHT, PRODIDUNITWG, PRODVOLM, PRODIDUNITVOLM, PRODTEMP, PRODIDUNITTEMP, PRODSERIE, PRODMODELO, PRODOTRO1, PRODOTRO2, PRODSTCKMIN, PRODSTCKMAX, PRODFOTO, WHO, IP, "UPDPROD");
                        URL = "CatalogoProductos/Producto/ProductoCatalogo/ProductoCatList.jsp";
                        response.sendRedirect(URL);
                    }
                } catch (IOException | SQLException | ServletException e) {
                    //Informar por consola
                    System.out.println("Error" + e.getMessage());
                }
            }//FIN DE IF PARA ACTUALIZAR PRODUCTO
            if (AccionDB.equals("ACTPROD")) {

            }//FIN DE IF PARA ACTIVAR PRODUCTO
            if (AccionDB.equals("INCPROD")) {

            }//FIN DE IF PARA INACTIVAR PRODUCTO

        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
