<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>

<%
/*
 * Script for server-side tests with database
 * This script takes the connection from a JNDI data source
 * It then selects all records from a table, received as query string, and displays it
 */
    String table = request.getParameter("table");
    String selectQry = "SELECT  * FROM " + table;    // change this line, eg: select * from products where price < 10

    // Initialise and output top of page
    out.println("<html>");
    out.println("<head>");
    out.println("    <title>BCP - JDBC JNDI DBCP Driver Test JSP v1.3 (Server Side)</title>");
    out.println("    <link rel=\"stylesheet\" href=\"https://cdn.synchro.com.br/assets/fontawesome/4.7.0/css/font-awesome.css\"/>");
    out.println("    <link rel=\"stylesheet\" href=\"https://cdn.synchro.com.br/assets/saturn-v/rc/saturn-v.css\"/>");
    out.println("</head>");
    out.println("   <body>");
    out.println("       <h4 class=\"sv-fw-normal sv-ts-i\">[" + selectQry + "]</h4>");
    out.println("       <hr>");

    // Get DataSource from JNDI (defined in context.xml file)
    // DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/mydatabase");
    Context ctx = new InitialContext();
    DataSource ds = (DataSource)ctx.lookup("java:/SFW_DS");

    // Create connection/statement variables outside of try block
    Connection c = null;
    Statement s = null;

    try {
        // Get Connection and Statement from DataSource
        c = ds.getConnection();
        s = c.createStatement();

        // Execute SQL
        try {

            // Create a statement and execute the query on it
            s.execute(selectQry);

            // Get result set
            ResultSet r = s.getResultSet();
            ResultSetMetaData rm = r.getMetaData();

            // Display data
            int count = rm.getColumnCount();
            out.println("<table class=\"sv-table with--borders with--stripes with--hover\">");
            out.println("<thead><tr>");
            for(int i = 1; i <= count; i++) {
                out.println("<th>" + rm.getColumnName(i) + "</th>");
            }
            out.println("</tr></thead><tbody>");

            while (r.next()) {
                out.println("<tr>");
                for(int i = 1; i <= count; i++) {
                    out.println("<td>" + r.getString(rm.getColumnName(i)) + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</tbody></table>");

        } catch (SQLException se) {
            out.println("Errors occurred: <b>" + se.toString() + "</b><br><br>");
        } catch (Exception e) {
            out.println("Errors occurred: <b>" + e.toString() + "</b><br><br>");
        }

    } finally {
        try {
            if (s != null) s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (c != null) c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Done

    out.println("<div class=\"sv-segment sv-pa--15 sv-bg-color--blue-50\"></i>How to use it:</i> http://localhost:8080/testdeploy/database.jsp<b>?table=changelog</b></div>");
    out.println("<br><br><p>DONE</p></body></html>");
%>