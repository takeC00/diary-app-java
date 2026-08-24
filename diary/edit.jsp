<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.diary.db.DbConfig" %>

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

<% List<String> errors = (List<String>) session.getAttribute("errors"); %>

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
Boolean myPage = false;

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


    int diary_id = Integer.parseInt(request.getParameter("diary_id"));
    conn = DbConfig.getConnection();

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
					image = "/diary-app-java/images/defaults/default.png";
			}
			id = rs.getInt("id");
			title = rs.getString("title");
      diaryDate = rs.getString("diary_date");
      body = rs.getString("body");
      userName = rs.getString("user_name");
      ownerId = rs.getInt("user_id");
			checked = rs.getString("is_public");
		}

		int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;

		if ("1".equals(checked)){
			is_public = "checked";
		}else{
			un_public = "checked";
		}

		if (id == 0) {
				session.setAttribute("error", "存在しない日記IDが指定されました");
				response.sendRedirect("/diary-app-java/404.jsp");
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
			<%
				if (errors != null) {
			%>
			<ul>
				<% for (String e : errors) { %>
					<li style="color:red;"><%= e %></li>
				<% } %>
			</ul>
			<%
					session.removeAttribute("errors");
			}
			%>
			<div class="button-section">
				<a href="<%= backUrl %>"><button class="back">戻る</button></a>
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
						<input type="hidden" name="pageParam" value="<%= pageParam %>">
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
<script>
document.getElementById('imageInput').addEventListener('change', function(e) {
	const file = e.target.files[0];

	if (!file) return;

	const reader = new FileReader();

	reader.onload = function(event) {
		const img = document.getElementById('preview');
		img.src = event.target.result;
		img.style.display = 'block';
	};

	reader.readAsDataURL(file);
});
</script>
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
