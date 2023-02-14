package model;

import beans.ConexionDB;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;

/**
 *
 * @Document : DaoProducto
 * @Created on : 04-15-2020, 05:00:21 PM
 * @Author : Moises Romero
 * @Owner : Cloud IT Systems, S.A
 */
public class DaoProducto {

    //VARIBALES DE LA BASE DE DATOS..
    private ConexionDB conDB = null;
    private Statement st = null;
    private PreparedStatement pst = null;
    private ResultSet rs = null;
    public boolean existe = false;

    public DaoProducto() {
        super();
    }

    public static int PRODIDCOMP = 0;//INT NOT NULL COMMENT 'ID COMPAÑIA',
    public static int PRODID = 0;//INT NOT NULL COMMENT 'ID PRODUCTO',
    public static int PRODIDUNIT = 0;//VARCHAR(50) NOT NULL COMMENT 'ID UNIDAD DE MEDIDA',
    public String PRODTIPO = "";//TIPO PRODUCTO: B:BIENES; S:SERVICIO        
    public static int PRODIDTYP = 0;//INT NOT NULL COMMENT 'ID TIPO PRODUCTO LLAVE FOREANEA',
    public static int PRODIDCAT = 0;//INT NOT NULL COMMENT 'ID CATEGORIA LLAVE FOREANEA',
    public static int PRODIDMARCA = 0;//INT NOT NULL COMMENT 'ID MARCA LLAVE FOREANEA',
    public static int PRODIDFABR = 0;//INT NOT NULL COMMENT 'ID FABRICANTE DEL PRODUCTO',
    public static String PRODCOD = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO DEL PRODUCTO',
    public static String PRODEAN = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'NUMERO DE PRODUCTO EUROPEO',
    public static String PRODSKU = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO SKU DEL PRODUCTO',
    public static String PRODUPC = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO UNIVERSAL DEL PRODUCTO',
    public static String PRODNAME = "";//VARCHAR(120) NOT NULL DEFAULT '' COMMENT 'NOMBRE DEL PRODUCTO',
    public static String PRODDESCXS = "";//VARCHAR(130) NOT NULL DEFAULT '' COMMENT 'DESCRIPCION CORTA DEL PRODUCTO',
    public static String PRODDESCLG = "";//VARCHAR(250) NOT NULL DEFAULT '' COMMENT 'DESCRIPCION LARGA DEL PRODUCTO',
    public static double PRODLASTCOST = 0.00;//Decimal (21,6) NOT NULL COMMENT 'COSTO DE ULTIMA COMPRA DEL PRODUCTO',
    public static double PRODCOSTPROM = 0.00;//Decimal (21,6) NOT NULL COMMENT 'COSTO PROMEDIO DE COMPRA DEL PRODUCTO',
    public static int PRODIDCURR = 0;//INT NOT NULL DEFAULT 0 COMMENT 'ID MONEDA DEL PRODUCTO',
    public static double PRODPREC1 = 0.00;//Decimal (21,6) NOT NULL COMMENT 'PRECIO 1 DEL PRODUCTO',
    public static double PRODPREC2 = 0.00;//Decimal (21,6) COMMENT 'PRECIO 2 DEL PRODUCTO',
    public static double PRODPREC3 = 0.00;//Decimal (21,6) COMMENT 'PRECIO 3 DEL PRODUCTO',
    public static double PRODPREC4 = 0.00;//Decimal (21,6) COMMENT 'PRECIO 4 DEL PRODUCTO',
    public static double PRODDESC = 0.00;//Decimal (6,2) NOT NULL COMMENT 'DESCUENTO DEL PRODUCTO',
    public static String PRODIVA = "";//CHAR(1) NOT NULL COMMENT 'SE LE APLICARA IVA AL PRODUCTO',
    public static String PRODLOTE = "";//CHAR(1) NOT NULL COMMENT 'SE MANEJARA POR LOTE?',
    public static double PRODLONG = 0.00;//'LARGO DEL PRODUCTO',
    public static int PRODIDUNITLG = 0;//'ID UNIDAD DE MEDIDA DEL LARGO DEL PRODUCTO',
    public static double PRODWIDTH = 0.00;//'ANCHO DEL PRODUCTO',
    public static int PRODIDUNITWD = 0;//'ID UNIDAD DE MEDIDA DEL ANCHO DEL PRODUCTO',
    public static double PRODHEIGHT = 0.00;//'ALTURA DEL PRODUCTO',
    public static int PRODIDUNITHG = 0;//'ID UNIDAD DE MEDIDA DEL ALTO DEL PRODUCTO',
    public static double PRODWEIGHT = 0.00;//'PESO BRUTO DEL PRODUCTO',
    public static int PRODIDUNITWG = 0;//'ID UNIDAD DE MEDIDA DEL PESO BRUTO DEL PRODUCTO',
    public static double PRODVOLM = 0.00;//'VOLUMEN DEL PRODUCTO',
    public static int PRODIDUNITVOLM = 0;//'ID UNIDAD DE MEDIDA DEL VOLUMEN DEL PRODUCTO',
    public static double PRODTEMP = 0.00;//'TEMPERATURA DEL PRODUCTO',
    public static int PRODIDUNITTEMP = 0;//'ID UNIDAD DE MEDIDA DEL LA TEMPERATURA DEL PRODUCTO',
    public static String PRODSERIE = "";//CHAR(1) NOT NULL COMMENT 'SE MANEJARA POR NUMERO DE SERIE.?',
    public static String PRODMODELO = "";//'MODELO DEL PRODUCTO',
    public static String PRODOTRO1 = "";//'CAMPO OTRO 1 DEL PRODUCTO',
    public static String PRODOTRO2 = "";//'CAMPO OTRO 2 DEL PRODUCTO',
    public static double PRODSTCKMIN = 0.00;//Decimal (21,6) NOT NULL COMMENT 'CANTIDAD MINIMA A TENER EN STOCK',
    public static double PRODSTCKMAX = 0.00;//Decimal (21,6) NOT NULL COMMENT 'CANTIDAD MAXIMA A TENER EN STOCK',
    public static String PRODFOTO = "";//VARCHAR(250) NOT NULL DEFAULT '' COMMENT 'RUTA DE LA FOTO',
    public static String PRODACTV = "";//CHAR(1) NOT NULL COMMENT 'ACTIVO SI:NO',
    public static String PRODDATADD = "";//TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'FECHA QUE SE CREO EL PRODUCTO',
    public static String PRODDATIN = "";//TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'FECHA QUE SE LE DIO DE BAJA',
    public static String PRODNEWWHO = "";//CHAR(50) NOT NULL DEFAULT '' COMMENT 'AGREGADO POR ',
    public static String PRODNEWDT = "";//TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'AGREGADO EL',
    public static String PRODNEWIP = "";//VARCHAR(25) NOT NULL DEFAULT '' COMMENT 'AGREGADO DESDE IP',
    public static String PRODCHGWHO = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'ACTUALIZADO POR',
    public static String PRODCHGDT = "";//TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'ACTUALIZADO EL',
    public static String PRODCHGIP = "";//VARCHAR(25) NOT NULL DEFAULT '' COMMENT 'ACTUALIZADO DESDDE IP',

    //FUNCION PARA AGREGAR Ó ACTUAIZAR DATOS DEL PRODUCTO..
    public void PRODUC_ADD_UPD(int PRODIDCOMP, int PRODID, int PRODIDUNIT, String PRODTIPO, int PRODIDTYP, int PRODIDCAT, int PRODIDMARCA,
            int PRODIDFABR, String PRODCOD, String PRODEAN, String PRODSKU, String PRODUPC, String PRODNAME, String PRODDESCXS,
            String PRODDESCLG, double PRODLASTCOST, double PRODCOSTPROM, int PRODIDCURR, double PRODPREC1, double PRODPREC2, double PRODPREC3,
            double PRODPREC4, double PRODDESC, String PRODIVA, String PRODLOTE,
            double PRODLONG, int PRODIDUNITLG, double PRODWIDTH, int PRODIDUNITWD, double PRODHEIGHT, int PRODIDUNITHG,
            double PRODWEIGHT, int PRODIDUNITWG, double PRODVOLM, int PRODIDUNITVOLM, double PRODTEMP, int PRODIDUNITTEMP,
            String PRODSERIE, String PRODMODELO, String PRODOTRO1, String PRODOTRO2, double PRODSTCKMIN, double PRODSTCKMAX,
            String PRODFOTO, String WHO, String IP, String ACTION) {
        try {
            //ESTABLECEMOS LA CONEXION A LA BASE DE DATOS
            conDB = new ConexionDB();
            pst = conDB.Conectar().prepareStatement("CALL PRODUC_ADD_UPD (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            pst.setInt(1, PRODIDCOMP);
            pst.setInt(2, PRODID);
            pst.setInt(3, PRODIDUNIT);
            pst.setString(4, PRODTIPO);
            pst.setInt(5, PRODIDTYP);
            pst.setInt(6, PRODIDCAT);
            pst.setInt(7, PRODIDMARCA);
            pst.setInt(8, PRODIDFABR);
            pst.setString(9, PRODCOD);
            pst.setString(10, PRODEAN);
            pst.setString(11, PRODSKU);
            pst.setString(12, PRODUPC);
            pst.setString(13, PRODNAME);
            pst.setString(14, PRODDESCXS);
            pst.setString(15, PRODDESCLG);
            pst.setDouble(16, PRODLASTCOST);
            pst.setDouble(17, PRODCOSTPROM);
            pst.setInt(18, PRODIDCURR);
            pst.setDouble(19, PRODPREC1);
            pst.setDouble(20, PRODPREC2);
            pst.setDouble(21, PRODPREC3);
            pst.setDouble(22, PRODPREC4);
            pst.setDouble(23, PRODDESC);
            pst.setString(24, PRODIVA);
            pst.setString(25, PRODLOTE);
            pst.setDouble(26, PRODLONG);
            pst.setInt(27, PRODIDUNITLG);
            pst.setDouble(28, PRODWIDTH);
            pst.setInt(29, PRODIDUNITWD);
            pst.setDouble(30, PRODHEIGHT);
            pst.setInt(31, PRODIDUNITHG);
            pst.setDouble(32, PRODWEIGHT);
            pst.setInt(33, PRODIDUNITWG);
            pst.setDouble(34, PRODVOLM);
            pst.setInt(35, PRODIDUNITVOLM);
            pst.setDouble(36, PRODTEMP);
            pst.setInt(37, PRODIDUNITTEMP);
            pst.setString(38, PRODSERIE);
            pst.setString(39, PRODMODELO);
            pst.setString(40, PRODOTRO1);
            pst.setString(41, PRODOTRO2);
            pst.setDouble(42, PRODSTCKMIN);
            pst.setDouble(43, PRODSTCKMAX);
            pst.setString(44, PRODFOTO);
            pst.setString(45, WHO);
            pst.setString(46, IP);
            pst.setString(47, ACTION);
            // ejecutar el SP
            System.out.println("Hora & Fecha de Ejecucion: " + new Date());
            System.out.println(pst.toString());
            pst.execute();
            pst.close();
            // confirmar si se ejecuto sin errores
            conDB.Commit();
            conDB.Cerrar();
        } catch (SQLException e) {
            //INFORMAMOS POR CONSOLA LA HORA,FECHA Y EL ERROR.
            System.out.println("Hora & Fecha de Ejecucion: " + new Date());
            System.out.println("Error: " + e.getMessage());
        }
    }//FIN DE FUNCION PARA AGREGAR Ó ACTUAIZAR DATOS DEL PRODUCTO..

    //TO VALIDATE BEFORE AND AFTER INSERT ID PRODUCTO
    public int getProductoId(int companyId) {
        int ProdId = 0;
        try {
            conDB = new ConexionDB();
            st = conDB.Conectar().createStatement();
            rs = st.executeQuery("SELECT MAX(PRODID) FROM UBPRODUCTO WHERE PRODIDCOMP  = " + companyId);
            if (rs.next()) {
                ProdId = rs.getInt(1);
            }
            rs.close();
            st.close();
            conDB.Cerrar();
        } catch (SQLException e) {
            System.out.println("Error" + e.getMessage());
        }
        return ProdId;
    }//END TO VALIDATE BEFORE AND AFTER INSERT ID PRODUCTO
    
    //FUNCION PARA MANDAR A VERIFICAR SI YA EXISTE EL NOMBRE DEL PRODUCTO.
    public boolean CheckNameProd(int PRODIDCOMP, int PRODID, String PRODNAME) throws SQLException {
        existe = false;
        try {
            conDB = new ConexionDB();
            st = conDB.Conectar().createStatement();
            rs = st.executeQuery("SELECT PRODNAME FROM UBPRODUCTO WHERE PRODNAME LIKE '" + PRODNAME + "' AND PRODID != " + PRODID + " AND PRODIDCOMP =" + PRODIDCOMP);
            if (rs.next()) {
                existe = true;
            }
            rs.close(); //CIERRO LA CONEXION DEL RESULSET.
            st.close(); //CIERRO LA CONEXION DEL STAMENT
            conDB.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS
        } catch (SQLException e) {
            System.out.println("Error" + e.getMessage());
            rs.close(); //CIERRO LA CONEXION DEL RESULSET.
            st.close(); //CIERRO LA CONEXION DEL STAMENT
            conDB.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS
        }
        return existe;
    }//FUNCION PARA MANDAR A VERIFICAR SI YA EXISTE EL NOMBRE DEL PRODUCTO.

    //FUNCION PARA MANDAR A VERIFICAR SI YA EXISTE EL NOMBRE DEL PRODUCTO.
    public boolean CheckCodProd(int PRODIDCOMP, int PRODID, String PRODCOD) throws SQLException {
        existe = false;
        try {
            conDB = new ConexionDB();
            st = conDB.Conectar().createStatement();
            rs = st.executeQuery("SELECT PRODNAME FROM UBPRODUCTO WHERE PRODCOD LIKE '" + PRODCOD + "' AND PRODID != " + PRODID + " AND PRODIDCOMP =" + PRODIDCOMP);
            if (rs.next()) {
                existe = true;
            }
            rs.close(); //CIERRO LA CONEXION DEL RESULSET.
            st.close(); //CIERRO LA CONEXION DEL STAMENT
            conDB.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS
        } catch (SQLException e) {
            System.out.println("Error" + e.getMessage());
            rs.close(); //CIERRO LA CONEXION DEL RESULSET.
            st.close(); //CIERRO LA CONEXION DEL STAMENT
            conDB.Cerrar(); // CIERRO LA CONEXION A LA BASE DE DATOS
        }
        return existe;
    }//FUNCION PARA MANDAR A VERIFICAR SI YA EXISTE EL NOMBRE DEL PRODUCTO.
    
    //FUNCION PARA VERFICAR CUANTOS PRODUCTOS ACTIVOS HAY ACTUALMENTE.
        public int GetCountProd(int PRODIDCOMP) {
        int CountProd = 0;
        try {
            conDB = new ConexionDB();
            st = conDB.Conectar().createStatement();
            rs = st.executeQuery("SELECT COUNT(*) AS PRODS FROM UBPRODUCTO WHERE PRODIDCOMP="+PRODIDCOMP +" AND PRODACTV='S'");
            if (rs.next()) {
                existe = true;
                CountProd = rs.getInt("PRODS");
            }
        } catch (SQLException e) {
            System.out.println("Hora & Fecha de Ejecucion: " + new Date());
            System.out.println("Error Obteniedo Ultimo ID de Mesa: " + e.getMessage());
        }
        return CountProd;
    }//FIN DE FUNCION PARA VERFICAR CUANTOS PRODUCTOS ACTIVOS HAY ACTUALMENTE.

    //FUNCION PARA RECOGER LOS DATOS DE LA TABLA PRODUCTO
    public boolean GetDataProd(int PRODIDCOMP, int PRODID) {
        PRODIDUNIT = 0;//VARCHAR(50) NOT NULL COMMENT 'ID UNIDAD DE MEDIDA',
        PRODTIPO = "";//TIPO PRODUCTO: B:BIENES; S:SERVICIO
        PRODIDTYP = 0;//INT NOT NULL COMMENT 'ID TIPO PRODUCTO LLAVE FOREANEA',
        PRODIDCAT = 0;//INT NOT NULL COMMENT 'ID CATEGORIA LLAVE FOREANEA',
        PRODIDMARCA = 0;//INT NOT NULL COMMENT 'ID MARCA LLAVE FOREANEA',
        PRODIDFABR = 0;//INT NOT NULL COMMENT 'ID FABRICANTE DEL PRODUCTO',
        PRODCOD = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO DEL PRODUCTO',
        PRODEAN = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'NUMERO DE PRODUCTO EUROPEO',
        PRODSKU = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO SKU DEL PRODUCTO',
        PRODUPC = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO UNIVERSAL DEL PRODUCTO',
        PRODNAME = "";//VARCHAR(120) NOT NULL DEFAULT '' COMMENT 'NOMBRE DEL PRODUCTO',
        PRODDESCXS = "";//VARCHAR(130) NOT NULL DEFAULT '' COMMENT 'DESCRIPCION CORTA DEL PRODUCTO',
        PRODDESCLG = "";//VARCHAR(250) NOT NULL DEFAULT '' COMMENT 'DESCRIPCION LARGA DEL PRODUCTO',
        PRODLASTCOST = 0.00;//Decimal (21,6) NOT NULL COMMENT 'COSTO DE ULTIMA COMPRA DEL PRODUCTO',
        PRODCOSTPROM = 0.00;//Decimal (21,6) NOT NULL COMMENT 'COSTO PROMEDIO DE COMPRA DEL PRODUCTO',
        PRODIDCURR = 0;// NOT NULL DEFAULT 0 COMMENT 'ID MONEDA DEL PRODUCTO',
        PRODPREC1 = 0.00;//Decimal (21,6) NOT NULL COMMENT 'PRECIO 1 DEL PRODUCTO',
        PRODPREC2 = 0.00;//Decimal (21,6) COMMENT 'PRECIO 2 DEL PRODUCTO',
        PRODPREC3 = 0.00;//Decimal (21,6) COMMENT 'PRECIO 3 DEL PRODUCTO',
        PRODPREC4 = 0.00;//Decimal (21,6) COMMENT 'PRECIO 4 DEL PRODUCTO',
        PRODDESC = 0.00;//Decimal (6,2) NOT NULL COMMENT 'DESCUENTO DEL PRODUCTO',
        PRODIVA = "";//CHAR(1) NOT NULL COMMENT 'SE LE APLICARA IVA AL PRODUCTO',
        PRODLOTE = "";//CHAR(1) NOT NULL COMMENT 'SE MANEJARA POR LOTE?',
        PRODLONG = 0.00;//'LARGO DEL PRODUCTO',
        PRODIDUNITLG = 0;//'ID UNIDAD DE MEDIDA DEL LARGO DEL PRODUCTO',
        PRODWIDTH = 0.00;//'ANCHO DEL PRODUCTO',
        PRODIDUNITWD = 0;//'ID UNIDAD DE MEDIDA DEL ANCHO DEL PRODUCTO',
        PRODHEIGHT = 0.00;//'ALTURA DEL PRODUCTO',
        PRODIDUNITHG = 0;//'ID UNIDAD DE MEDIDA DEL ALTO DEL PRODUCTO',
        PRODWEIGHT = 0.00;//'PESO BRUTO DEL PRODUCTO',
        PRODIDUNITWG = 0;//'ID UNIDAD DE MEDIDA DEL PESO BRUTO DEL PRODUCTO',
        PRODVOLM = 0.00;//'VOLUMEN DEL PRODUCTO',
        PRODIDUNITVOLM = 0;//'ID UNIDAD DE MEDIDA DEL VOLUMEN DEL PRODUCTO',
        PRODTEMP = 0.00;//'TEMPERATURA DEL PRODUCTO',
        PRODIDUNITTEMP = 0;//'ID UNIDAD DE MEDIDA DEL LA TEMPERATURA DEL PRODUCTO',
        PRODSERIE = "";//CHAR(1) NOT NULL COMMENT 'SE MANEJARA POR NUMERO DE SERIE.?',
        PRODMODELO = "";//NOT NULL COMMENT 'MODELO DEL PRODUCTO',
        PRODOTRO1 = "";//NOT NULL COMMENT 'CAMPO OTRO 1 DEL PRODUCTO',
        PRODOTRO2 = "";//NOT NULL COMMENT 'CAMPO OTRO 2 DEL PRODUCTO',
        PRODSTCKMIN = 0.00;//Decimal (21,6) NOT NULL COMMENT 'CANTIDAD MINIMA A TENER EN STOCK',
        PRODSTCKMAX = 0.00;//Decimal (21,6) NOT NULL COMMENT 'CANTIDAD MAXIMA A TENER EN STOCK',
        PRODFOTO = "";//NOT NULL DEFAULT '' COMMENT 'RUTA DE LA FOTO',
        PRODACTV = "";//CHAR(1) NOT NULL COMMENT 'ACTIVO SI:NO',
        PRODDATADD = "";//TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'FECHA QUE SE CREO EL PRODUCTO',
        PRODDATIN = "";//TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'FECHA QUE SE LE DIO DE BAJA',
        PRODNEWWHO = "";//CHAR(50) NOT NULL DEFAULT '' COMMENT 'AGREGADO POR ',
        PRODNEWDT = "";//TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'AGREGADO EL',
        PRODNEWIP = "";//VARCHAR(25) NOT NULL DEFAULT '' COMMENT 'AGREGADO DESDE IP',
        PRODCHGWHO = "";//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'ACTUALIZADO POR',
        PRODCHGDT = "";//TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'ACTUALIZADO EL',
        PRODCHGIP = "";//VARCHAR(25) NOT NULL DEFAULT '' COMMENT 'ACTUALIZADO DESDDE IP',
        try {
            conDB = new ConexionDB();
            st = conDB.Conectar().createStatement();
            rs = st.executeQuery("SELECT * FROM UBPRODUCTO WHERE PRODIDCOMP=" + PRODIDCOMP + " AND PRODID=" + PRODID);
            if (rs.next()) {
                PRODIDUNIT = rs.getInt("PRODIDUNIT");//INT NOT NULL COMMENT 'ID UNIDAD DE MEDIDA',
                PRODTIPO = rs.getString("PRODTIPO");//TIPO PRODUCTO: B:BIENES; S:SERVICIO
                PRODIDTYP = rs.getInt("PRODIDTYP");//INT NOT NULL COMMENT 'ID TIPO PRODUCTO LLAVE FOREANEA',
                PRODIDCAT = rs.getInt("PRODIDCAT");//INT NOT NULL COMMENT 'ID CATEGORIA LLAVE FOREANEA',
                PRODIDMARCA = rs.getInt("PRODIDMARCA");//INT NOT NULL COMMENT 'ID MARCA LLAVE FOREANEA',
                PRODIDFABR = rs.getInt("PRODIDFABR");//INT NOT NULL COMMENT 'ID FABRICANTE DEL PRODUCTO',
                PRODCOD = rs.getString("PRODCOD");//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO DEL PRODUCTO',
                PRODEAN = rs.getString("PRODEAN");//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'NUMERO DE PRODUCTO EUROPEO',
                PRODSKU = rs.getString("PRODSKU");//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO SKU DEL PRODUCTO',
                PRODUPC = rs.getString("PRODUPC");//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'CODIGO UNIVERSAL DEL PRODUCTO',
                PRODNAME = rs.getString("PRODNAME");//VARCHAR(120) NOT NULL DEFAULT '' COMMENT 'NOMBRE DEL PRODUCTO',
                PRODDESCXS = rs.getString("PRODDESCXS");//VARCHAR(130) NOT NULL DEFAULT '' COMMENT 'DESCRIPCION CORTA DEL PRODUCTO',
                PRODDESCLG = rs.getString("PRODDESCLG");//VARCHAR(250) NOT NULL DEFAULT '' COMMENT 'DESCRIPCION LARGA DEL PRODUCTO',
                PRODLASTCOST = rs.getDouble("PRODLASTCOST");//Decimal (21,6) NOT NULL COMMENT 'COSTO DE ULTIMA COMPRA DEL PRODUCTO',
                PRODCOSTPROM = rs.getDouble("PRODCOSTPROM");//Decimal (21,6) NOT NULL COMMENT 'COSTO PROMEDIO DE COMPRA DEL PRODUCTO',
                PRODIDCURR = rs.getInt("PRODIDCURR");// NOT NULL DEFAULT 0 COMMENT 'ID MONEDA DEL PRODUCTO',
                PRODPREC1 = rs.getDouble("PRODPREC1");//Decimal (21,6) NOT NULL COMMENT 'PRECIO 1 DEL PRODUCTO',
                PRODPREC2 = rs.getDouble("PRODPREC2");//Decimal (21,6) COMMENT 'PRECIO 2 DEL PRODUCTO',
                PRODPREC3 = rs.getDouble("PRODPREC3");//Decimal (21,6) COMMENT 'PRECIO 3 DEL PRODUCTO',
                PRODPREC4 = rs.getDouble("PRODPREC4");//Decimal (21,6) COMMENT 'PRECIO 4 DEL PRODUCTO',
                PRODDESC = rs.getDouble("PRODDESC");//Decimal (6,2) NOT NULL COMMENT 'DESCUENTO DEL PRODUCTO',
                PRODIVA = rs.getString("PRODIVA");//CHAR(1) NOT NULL COMMENT 'SE LE APLICARA IVA AL PRODUCTO',
                PRODLOTE = rs.getString("PRODLOTE");//CHAR(1) NOT NULL COMMENT 'SE MANEJARA POR LOTE?',
                PRODLONG = rs.getDouble("PRODLONG");//'LARGO DEL PRODUCTO',
                PRODIDUNITLG = rs.getInt("PRODIDUNITLG");//'ID UNIDAD DE MEDIDA DEL LARGO DEL PRODUCTO',
                PRODWIDTH = rs.getDouble("PRODWIDTH");//'ANCHO DEL PRODUCTO',
                PRODIDUNITWD = rs.getInt("PRODIDUNITWD");//'ID UNIDAD DE MEDIDA DEL ANCHO DEL PRODUCTO',
                PRODHEIGHT = rs.getDouble("PRODHEIGHT");//'ALTURA DEL PRODUCTO',
                PRODIDUNITHG = rs.getInt("PRODIDUNITHG");//'ID UNIDAD DE MEDIDA DEL ALTO DEL PRODUCTO',
                PRODWEIGHT = rs.getDouble("PRODWEIGHT");//'PESO BRUTO DEL PRODUCTO',
                PRODIDUNITWG = rs.getInt("PRODIDUNITWG");//'ID UNIDAD DE MEDIDA DEL PESO BRUTO DEL PRODUCTO',
                PRODVOLM = rs.getDouble("PRODVOLM");//'VOLUMEN DEL PRODUCTO',
                PRODIDUNITVOLM = rs.getInt("PRODIDUNITVOLM");//'ID UNIDAD DE MEDIDA DEL VOLUMEN DEL PRODUCTO',
                PRODTEMP = rs.getDouble("PRODTEMP");//'TEMPERATURA DEL PRODUCTO',
                PRODIDUNITTEMP = rs.getInt("PRODIDUNITTEMP");//'ID UNIDAD DE MEDIDA DEL LA TEMPERATURA DEL PRODUCTO',                
                PRODSERIE = rs.getString("PRODSERIE");//CHAR(1) NOT NULL COMMENT 'SE MANEJARA POR NUMERO DE SERIE.?',
                PRODMODELO = rs.getString("PRODMODELO");///NOT NULL COMMENT 'MODELO DEL PRODUCTO',
                PRODOTRO1 = rs.getString("PRODOTRO1");///NOT NULL COMMENT 'CAMPO OTRO 1 DEL PRODUCTO',
                PRODOTRO2 = rs.getString("PRODOTRO2");///NOT NULL COMMENT 'CAMPO OTRO 2 DEL PRODUCTO',
                PRODSTCKMIN = rs.getDouble("PRODSTCKMIN");//Decimal (21,6) NOT NULL COMMENT 'CANTIDAD MINIMA A TENER EN STOCK',
                PRODSTCKMAX = rs.getDouble("PRODSTCKMAX");//Decimal (21,6) NOT NULL COMMENT 'CANTIDAD MAXIMA A TENER EN STOCK',
                PRODFOTO = rs.getString("PRODFOTO");//NOT NULL DEFAULT '' COMMENT 'RUTA DE LA FOTO',
                PRODACTV = rs.getString("PRODACTV");//CHAR(1) NOT NULL COMMENT 'ACTIVO SI:NO',
                PRODDATADD = rs.getString("PRODDATADD");//TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'FECHA QUE SE CREO EL PRODUCTO',
                PRODDATIN = rs.getString("PRODDATIN");//TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'FECHA QUE SE LE DIO DE BAJA',
                PRODNEWWHO = rs.getString("PRODNEWWHO");//CHAR(50) NOT NULL DEFAULT '' COMMENT 'AGREGADO POR ',
                PRODNEWDT = rs.getString("PRODNEWDT");//TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'AGREGADO EL',
                PRODNEWIP = rs.getString("PRODNEWIP");//VARCHAR(25) NOT NULL DEFAULT '' COMMENT 'AGREGADO DESDE IP',
                PRODCHGWHO = rs.getString("PRODCHGWHO");//VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'ACTUALIZADO POR',
                PRODCHGDT = rs.getString("PRODCHGDT");//TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'ACTUALIZADO EL',
                PRODCHGIP = rs.getString("PRODCHGIP");//VARCHAR(25) NOT NULL DEFAULT '' COMMENT 'ACTUALIZADO DESDDE IP',
            }
            rs.close(); //CIERRO EL RESULSET STATEMENT
            st.close(); //CIERRO EL STATEMENT
            conDB.Cerrar();// CIERRO LA CONEXION A LA BASE DE DATOS
        } catch (SQLException e) {
            //INFORMAMOS POR CONSOLA LA HORA,FECHA Y EL ERROR.
            System.out.println("Hora & Fecha de Ejecucion: " + new Date());
            System.out.println("Error: " + e.getMessage());
        }
        return existe;
    }//FIN DE FUNCION PARA RECOGER LOS DATOS DE LA TABLA PRODUCTO

}
