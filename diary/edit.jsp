<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.Paths" %>

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
String checked = "";
int ownerId = 0;
String is_public = "";
String un_public = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

    int diary_id = Integer.parseInt(request.getParameter("diary_id"));
    conn = DriverManager.getConnection(url, user, password);

    String sql = "SELECT d.id, d.user_id, d.image, d.title, d.diary_date, d.body, u.name AS user_name, d.is_public "
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
			checked = rs.getString("is_public");
		}

		String pageParam = request.getParameter("page");
		int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
		Integer userId = (Integer) session.getAttribute("user_id");

		if ("1".equals(checked)){
			is_public = "checked";
		}else{
			un_public = "checked";
		}

		if (id == 0) {
				session.setAttribute("error", "存在しない日記IDが指定されました");
				response.sendRedirect("/diary-app-java/diary/index.jsp");
				return;
		}
		if (userId != ownerId){
				//URL直接指定などで不正に編集ページにアクセスした場合
				session.setAttribute("error", "自分の日記以外は編集できません");
        // 一覧へリダイレクト
        response.sendRedirect("/diary-app-java/diary/index.jsp");
		}
%>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
	<main>
		<section>
						<div class="button-section">
				<a href="/diary-app-java/diary/show.jsp?diary_id=<%= id %>&from=public&page=<%= currentPage %>"><button class="back">戻る</button></a>
			</div>
			<div class="detail-section">
				<div class="diary-detail flex">
					<div class="img">
						<div class="background-white">
							<img src="<%= h(image) %>" alt="" id="preview" class="">
						</div>
					</div>
					<form action="/diary-app-java/diary/update" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="id" value="<%= id %>">
						<div class="form-row">
							<p class="mini-title">タイトル：</p>
							<input type="text" name="title"
								value="<%= h(rs.getString("title")) %>"
								class="">
						</div>

						<div class="form-row">
							<p class="mini-title">日付：</p>
							<input type="date" name="diary_date"
								value="<%= h(rs.getString("diary_date")) %>"
								class="">
						</div>

						<div class="form-row">
							<p class="mini-title">画像：</p>
							<div>
								<input type="file" name="diary_image" id="imageInput"
									class="">
							</div>
						</div>

						<div class="form-row">
							<p class="mini-title public">公開設定：</p>
							<div class="radio-group">
														<div class="radio-group">
								<label>
									<input type="radio" name="is_public" value="1" <%= is_public %> >
									公開
								</label>

								<label>
									<input type="radio" name="is_public" value="0" <%= un_public %> >
									非公開
								</label>
							</div>
							</div>
						</div>

						<div class="form-row">
							<p class="mini-title">本文：</p>
							<textarea class=""
								name="body"><%= h(rs.getString("body")) %></textarea>
						</div>

						<div class="button-section">
							<button class="create" type="submit">更新</button>
						</div>
					</form>
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
