<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%!
public String h(String str) {
    if (str == null) return "";
    return str.replace("&", "&amp;")
              .replace("<", "&lt;")
              .replace(">", "&gt;")
              .replace("\"", "&quot;")
              .replace("'", "&#39;");
}
%>

<%
Connection conn = null;
PreparedStatement ps = null;
PreparedStatement countPs = null;
ResultSet rs = null;
ResultSet countRs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

    conn = DriverManager.getConnection(url, user, password);

    String pageParam = request.getParameter("page");
    int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
    if (currentPage < 1) {
        currentPage = 1;
    }

    int perPage = 12;
    int offset = (currentPage - 1) * perPage;

    String countSql = "SELECT COUNT(*) FROM diaries d WHERE d.is_public = 1";
    countPs = conn.prepareStatement(countSql);
    countRs = countPs.executeQuery();

    int totalCount = 0;
    if (countRs.next()) {
        totalCount = countRs.getInt(1);
    }

    int totalPages = (int)Math.ceil((double)totalCount / perPage);
    if (totalPages == 0) {
        totalPages = 1;
    }

    if (currentPage > totalPages) {
        currentPage = totalPages;
        offset = (currentPage - 1) * perPage;
    }

    String sql = "SELECT d.id, d.image, d.title, d.diary_date, u.name "
               + "FROM diaries d "
               + "JOIN users u ON u.id = d.user_id "
               + "WHERE d.is_public = 1 "
               + "ORDER BY d.diary_date DESC "
               + "LIMIT ? OFFSET ?";

    ps = conn.prepareStatement(sql);
    ps.setInt(1, perPage);
    ps.setInt(2, offset);
    rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="includes/head.jsp" %>
<body>
<%@ include file="includes/headder.jsp" %>

<main>
    <section>
        <h1>公開日記一覧</h1>

        <div>
            <div class="diary-list">
                <%
                while (rs.next()) {
                    String image = rs.getString("image");
                    if (image == null || image.isEmpty()) {
                        image = "/images/defaults/default.png";
                    }
                %>
                <article class="diary-card">
                    <a href="/show/<%= rs.getInt("id") %>?from=public&page=<%= currentPage %>">
                        <img src="<%= h(image) %>" alt="日記画像" class="diary-image">
                        <h2 class="diary-title"><%= h(rs.getString("title")) %></h2>
                        <div class="diary-date"><%= h(rs.getString("diary_date")) %></div>
                        <p class="diary-user"><%= h(rs.getString("name")) %></p>
                    </a>
                </article>
                <%
                }
                %>
            </div>
        </div>

        <div class="pagination">
            <%
            if (currentPage <= 1) {
            %>
                <span class="page-button arrow gray"><</span>
            <%
            } else {
            %>
                <a href="?page=<%= currentPage - 1 %>" class="page-button arrow"><</a>
            <%
            }

            for (int i = 1; i <= totalPages; i++) {
                if (i == currentPage) {
            %>
                <span class="page-button current"><%= i %></span>
            <%
                } else {
            %>
                <a href="?page=<%= i %>" class="page-button"><%= i %></a>
            <%
                }
            }

            if (currentPage >= totalPages) {
            %>
                <span class="page-button arrow gray">></span>
            <%
            } else {
            %>
                <a href="?page=<%= currentPage + 1 %>" class="page-button arrow">></a>
            <%
            }
            %>
        </div>
    </section>
</main>

<%@ include file="includes/footer.jsp" %>
</body>
</html>

<%
} catch (Exception e) {
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (countRs != null) try { countRs.close(); } catch (Exception e) {}
    if (countPs != null) try { countPs.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
