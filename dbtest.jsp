<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>DB Test</title>
</head>
<body>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

    conn = DriverManager.getConnection(url, user, password);
    ps = conn.prepareStatement("SELECT 1");
    rs = ps.executeQuery();

    if (rs.next()) {
        out.println("<h1>DB接続成功 🎉</h1>");
        out.println("<p>結果: " + rs.getInt(1) + "</p>");
    }
} catch (Exception e) {
    out.println("<h1>DB接続失敗 ❌</h1>");
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
</body>
</html>
