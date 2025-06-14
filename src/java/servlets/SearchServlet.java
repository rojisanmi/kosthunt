package servlets;

import classes.JDBC;
import models.Kost;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("query");
        String location = request.getParameter("location");
        String priceRange = request.getParameter("price_range");
        String type = request.getParameter("type");
        String sortBy = request.getParameter("sort_by");
        String pageStr = request.getParameter("page");
        
        int currentPage = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
        int itemsPerPage = 9;

        List<Kost> kostList = new ArrayList<>();
        int totalItems = 0;

        StringBuilder sql = new StringBuilder("SELECT * FROM kost WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ? OR address LIKE ?)");
            params.add("%" + searchQuery + "%");
            params.add("%" + searchQuery + "%");
            params.add("%" + searchQuery + "%");
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND location LIKE ?");
            params.add("%" + location + "%");
        }
        if (priceRange != null && !priceRange.trim().isEmpty()) {
            String[] range = priceRange.split("-");
            if (range.length == 2) {
                sql.append(" AND price BETWEEN ? AND ?");
                params.add(Double.parseDouble(range[0]));
                params.add(Double.parseDouble(range[1]));
            }
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
            params.add(type);
        }

        JDBC db = new JDBC();
        db.connect();

        try {
            String countSql = "SELECT COUNT(*) FROM (" + sql.toString() + ") AS count_table";
            try (PreparedStatement countStmt = db.getConnection().prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) {
                    countStmt.setObject(i + 1, params.get(i));
                }
                try (ResultSet rs = countStmt.executeQuery()) {
                    if (rs.next()) {
                        totalItems = rs.getInt(1);
                    }
                }
            }

            if (sortBy != null && !sortBy.trim().isEmpty()) {
                switch (sortBy) {
                    case "price_asc": sql.append(" ORDER BY price ASC"); break;
                    case "price_desc": sql.append(" ORDER BY price DESC"); break;
                    default: sql.append(" ORDER BY created_at DESC"); break;
                }
            } else {
                sql.append(" ORDER BY created_at DESC");
            }

            sql.append(" LIMIT ? OFFSET ?");
            params.add(itemsPerPage);
            params.add((currentPage - 1) * itemsPerPage);

            try (PreparedStatement stmt = db.getConnection().prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Kost kost = new Kost();
                        kost.setId(rs.getInt("id"));
                        kost.setName(rs.getString("name"));
                        kost.setDescription(rs.getString("description"));
                        kost.setPrice(rs.getDouble("price"));
                        kost.setLocation(rs.getString("location"));
                        kost.setType(rs.getString("type"));
                        kost.setFacilities(rs.getString("facilities"));
                        kost.setImageUrl(rs.getString("image_url"));
                        kost.setAddress(rs.getString("address"));
                        kost.setStatus(rs.getInt("status"));
                        kost.setAvgRating(rs.getDouble("avg_rating"));
                        kostList.add(kost);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("kostList", kostList);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalItems / itemsPerPage));
        request.setAttribute("currentPage", currentPage);

        request.setAttribute("query", searchQuery);
        request.setAttribute("location", location);
        request.setAttribute("priceRange", priceRange);
        request.setAttribute("type", type);
        request.setAttribute("sortBy", sortBy);

        RequestDispatcher dispatcher = request.getRequestDispatcher("search.jsp");
        dispatcher.forward(request, response);
    }
}