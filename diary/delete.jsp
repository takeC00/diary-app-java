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
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

    int diary_id = Integer.parseInt(request.getParameter("diary_id"));
    conn = DriverManager.getConnection(url, user, password);

    String sql = "SELECT d.id, d.user_id, d.image, d.title, d.diary_date, d.body, u.name AS user_name "
               + "FROM diaries d "
               + "JOIN users u ON u.id = d.user_id "
               + "WHERE d.id = ?";

    ps = conn.prepareStatement(sql);
    ps.setInt(1, diary_id);
    rs = ps.executeQuery();
		if (rs.next()) {
			String image = rs.getString("image");
			if (image == null || image.isEmpty()) {
					image = "/images/defaults/default.png";
		}
		String pageParam = request.getParameter("page");
		int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
		Integer userId = (Integer) session.getAttribute("user_id");
		int ownerId = rs.getInt("user_id");
%>
<!DOCTYPE html>
<html lang="ja">
<%@ include file="includes/head.jsp" %>
<body>
<%@ include file="includes/headder.jsp" %>

<main>
    <section>
        <div class="button-section">
						<% if (ownerId!=userId) { %>
							<a href="/myPage/?user_id=<%= userId %>" class="btn my-page">この人の日記一覧を見る</a>
							<a href="/diary-app-java/diary/index.jsp?page=<%= currentPage %>" class="btn">戻る</a>
						<% } else { %>
							<a href="/edit/?diary_id=<%= diary_id %>" class="btn">編集</a>
							<form action="/diary/delete.jsp" method="post" onsubmit="return confirm('削除しますか？');">
									<input type="hidden" name="id" value="<%= rs.getInt("id") %>">
									<button class="delete" type="submit">削除</button>
							</form>
							<a href="/diary-app-java/diary/index.jsp?page=<%= currentPage %>" class="btn">戻る</a>
						<%	}	%>
        </div>
        <div class="detail-section">
            <div class="diary-detail flex">
                <div class="img">
                    <div class="background-white">
                        <img src="<%= h(image) %>" alt="">
                    </div>
                </div>

                <div class="detail">
                    <p>タイトル：<%= h(rs.getString("title")) %></p>
                    <p>日付：<%= h(rs.getString("diary_date")) %></p>
                    <p>作者：<%= h(rs.getString("user_name")) %></p>
                </div>
            </div>
            <div class="detail-text">
                <p class="detail-body"><%= h(rs.getString("body")) %></p>
            </div>
        </div>
        <%
        } else {
        %>
        <p>対象の日記が見つかりません。</p>
        <%
        }
        %>
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
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
