package com.venzura.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/DatabaseCon")
public class DatabaseCon extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/venzura_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";
    
    private Connection connection;

    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            throw new ServletException("Database connection failed!", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().println("<html><head><title>Admin List</title></head><body>");
        response.getWriter().println("<h2>List of Admins</h2>");
        
        try {
            Statement stmt = connection.createStatement();
            String query = "SELECT id, username, email FROM admins";
            ResultSet rs = stmt.executeQuery(query);

            response.getWriter().println("<table border='1'><tr><th>ID</th><th>Username</th><th>Email</th></tr>");

            while (rs.next()) {
                int id = rs.getInt("id");
                String username = rs.getString("username");
                String email = rs.getString("email");

                response.getWriter().println("<tr><td>" + id + "</td><td>" + username + "</td><td>" + email + "</td></tr>");
            }

            response.getWriter().println("</table>");
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            response.getWriter().println("<p>Error retrieving admins: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }

        response.getWriter().println("</body></html>");
    }

    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
