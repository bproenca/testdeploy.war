<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%
/*
 * Synopsis
 * =====================================================================================
 * This script takes the connection from a JNDI data source, which is defined
 * in context.xml.  It then selects all records from a table, then displays
 * each row as a set of lines, in the following format:
 *
 *   [Column 1 - columnname] value
 *   [Column 2 - columnname] value
 *   [Column 3 - columnname] value
 *
 *   [Column 1 - columnname] value
 *   [Column 2 - columnname] value
 *   [Column 3 - columnname] value
 *
 */
    String selectQry = "select * from view_cor_contabilista";    // change this line, eg: select * from products where price < 10

    // Initialise and output top of page
    //out.println("<HTML><BODY BGCOLOR=\"#ddddff\">");
    //out.println("<HTML><TITLE>BCP - JDBC JNDI DBCP Driver Test JSP v1.3</TITLE><BODY><FONT FACE=\"Verdana, Helvetica\" size=4>");
    //out.println("Metawerx JDBC JNDI DBCP Driver Test JSP v1.3");

    out.println("<html>");
    out.println("<head>");
    out.println("    <title>Simple application server Tests</title>");
    out.println("    <link rel=\"stylesheet\" href=\"https://cdn.synchro.com.br/assets/fontawesome/4.7.0/css/font-awesome.css\"/>");
    out.println("    <link rel=\"stylesheet\" href=\"https://cdn.synchro.com.br/assets/saturn-v/rc/saturn-v.css\"/>");
    out.println("</head>");
    out.println("   <body>");

    // Get DataSource from JNDI (defined in context.xml file)
    Context ctx = new InitialContext();
    //DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/mydatabase");
    DataSource ds = (DataSource)ctx.lookup("java:/SFW_DS");

    // Create connection/statement variables outside of try block
    Connection c = null;
    Statement s = null;

    try {
        // Get Connection and Statement from DataSource
        c = ds.getConnection();
        s = c.createStatement();

        // Execute SQL
        out.println("<h3>Executing query...</h3>");
        out.println("<h4><i>["+selectQry+"]</i></h4>");

        try {

            // Create a statement and execute the query on it
            String name;
            s.execute(selectQry);

            // Get result set
            ResultSet r = s.getResultSet();
            ResultSetMetaData rm = r.getMetaData();    // call before r.next() see note 4 above in JDBC hints

            // Display data
            int count = rm.getColumnCount();
            while (r.next()) {
                for(int i = 1; i <= rm.getColumnCount(); i++)
                    out.println("<BR />[Column " + i + " - " + rm.getColumnName(i) + "] " + r.getString(rm.getColumnName(i)));
                out.println("<P />");
            }

            // Clean up
            s.close();
            c.close();

        } catch (SQLException se) {
            out.println("Errors occurred: " + se.toString());
        } catch (Exception e) {
            out.println("Errors occurred: " + e.toString());
        }

    } finally {

        // Ensure connection is closed and returned to the pool, even if errors occur.
        // This is *very* important if using a connection pool, because after all the
        // connections are used, the application will hang on getConnection(), waiting
        // for a connection to become available.
        // Any errors from the following closes are just ignored.  The main thing is
        // that we have definitely closed the connection.
        try { if(s != null) s.close(); } catch (Exception e) {}
        try { if(c != null) c.close(); } catch (Exception e) {}
    }

    // Done
    out.println("</PRE><P /><HR /><B>DONE</B></FONT></FONT></BODY></HTML>");
%>