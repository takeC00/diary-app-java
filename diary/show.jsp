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
// 表示用変数
int id = 0;
String image = "";
String title = "";
String diaryDate = "";
String body = "";
String userName = "";
int ownerId = 0;

Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null){
	//ログインしてない場合
	session.setAttribute("error", "ログインしてください");
	// ログイン画面へリダイレクト
	response.sendRedirect("/diary-app-java/");
	return;
}

String pageParam = request.getParameter("page");
String fromPage = request.getParameter("from");
String backUrl = "";

if ("myDiary".equals(fromPage)) {
    backUrl = "/diary-app-java/" + fromPage + "/index.jsp?page=" + pageParam;
}else{
	backUrl = "/diary-app-java/diary/index.jsp?page=" + pageParam;
}


try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

    Integer diary_id = Integer.parseInt(request.getParameter("diary_id"));
    conn = DriverManager.getConnection(url, user, password);

    String sql = "SELECT d.id, d.user_id, d.image, d.title, d.diary_date, d.body, u.name AS user_name "
               + "FROM diaries d "
               + "JOIN users u ON u.id = d.user_id "
               + "WHERE d.id = ?";

    ps = conn.prepareStatement(sql);
    ps.setInt(1, diary_id);
    rs = ps.executeQuery();
		if (rs.next()) {
			image = rs.getString("image");
			if (image == null || image.isEmpty()) {
					image = "/images/defaults/default.png";
			}
			id = rs.getInt("id");
			title = rs.getString("title");
      diaryDate = rs.getString("diary_date");
      body = rs.getString("body");
      userName = rs.getString("user_name");
      ownerId = rs.getInt("user_id");
		}

		Integer currentPage = (pageParam != null && !pageParam.isEmpty())
						? Integer.parseInt(pageParam)
						: 1;

		if (id == 0) {
				session.setAttribute("error", "存在しない日記IDが指定されました");
				response.sendRedirect("/diary-app-java/diary/index.jsp");
				return;
		}
		String success = (String) session.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>

<main>
    <section>
				<% if(success != null) { %>
				<p class="green-message"><%= success %></p>
				<%
					}
					session.removeAttribute("success");
				%>
        <div class="button-section">
						<% if (ownerId!=userId) { %>
							<a href="/myPage/?user_id=<%= userId %>" class="btn my-page">この人の日記一覧を見る</a>
							<a href="<%= backUrl %>" class="btn">戻る</a>
						<% } else { %>
							<a href="/diary-app-java/diary/edit.jsp?from=<%= fromPage  %>&diary_id=<%= diary_id %>&page=<%= pageParam %>" class="btn">編集</a>
							<form action="/diary-app-java/diary/delete.jsp" method="post" onsubmit="return confirm('削除しますか？');">
									<input type="hidden" name="id" value="<%= rs.getInt("id") %>">
									<button class="delete" type="submit">削除</button>
							</form>
							<a href="<%= backUrl %>" class="btn">戻る</a>
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
    </section>
</main>

<%@ include file="/includes/footer.jsp" %>
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
