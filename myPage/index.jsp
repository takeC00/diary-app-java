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
		Integer userId = (Integer) session.getAttribute("user_id");
		if (userId == null){
			//ログインしてない場合
			session.setAttribute("error", "ログインしてください");
			// ログイン画面へリダイレクト
			response.sendRedirect("/diary-app-java/");
			return;
		}
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

	  // ユーザー情報
		String userSql = "SELECT id, name, icon, introduction "
              + "FROM users "
              + "WHERE id = ?";

		PreparedStatement userPs = conn.prepareStatement(userSql);
		userPs.setInt(1, userId);
		ResultSet userRs = userPs.executeQuery();

		String userName = "";
		String userIcon = "/images/defaults/icon_1.jpeg";
		String introduction = "";

		if (userRs.next()) {
				userName = userRs.getString("name");
				if (userRs.getString("icon") != null && !userRs.getString("icon").isEmpty()) {
						userIcon = userRs.getString("icon");
				}
				introduction = userRs.getString("introduction");
		}

		// 日記情報
		String diarySql = "SELECT "
							+ "d.id AS diary_id, "
							+ "d.image AS image, "
							+ "d.title AS title, "
							+ "d.diary_date AS diary_date "
							+ "FROM diaries d "
							+ "JOIN users u ON u.id = d.user_id "
							+ "WHERE d.user_id = ? "
							+ "ORDER BY diary_date DESC ";

    PreparedStatement diaryPs = conn.prepareStatement(diarySql);
    diaryPs.setInt(1, userId);
    ResultSet diaryRs = diaryPs.executeQuery();

		String success = (String) session.getAttribute("success");
		String error	 = (String) session.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
	<main>
		<section>
			<h1>
				マイページ
				<img src="<%= h(userIcon) %>"	class="icon" alt="">
			</h1>
			<form action="/diary-app-java/myPage/update.jsp" method="POST">
				<div>
									</div>
				<div class="diary-detail flex">
					<div class="detail">
						<p class="mini-title">自己紹介：</p>
						<textarea name="introduction" placeholder="まだ、自己紹介文が登録されていません。自己紹介文を登録してみましょう"><%= h(introduction) %></textarea>
						<p class="mini-title">アイコン：</p>
						<div class="icon-list">
							<label>
								<input type="radio" name="icon" value="/images/defaults/icon_1.jpeg">
								<img src="/images/defaults/icon_1.jpeg">
							</label>

							<label>
								<input type="radio" name="icon" value="/images/defaults/icon_2.jpeg">
								<img src="/images/defaults/icon_2.jpeg">
							</label>
							<label>
								<input type="radio" name="icon" value="/images/defaults/icon_3.jpeg">
								<img src="/images/defaults/icon_3.jpeg">
							</label>

							<label>
								<input type="radio" name="icon" value="/images/defaults/icon_4.jpeg">
								<img src="/images/defaults/icon_4.jpeg">
							</label>
							<label>
								<input type="radio" name="icon" value="/images/defaults/icon_5.jpeg">
								<img src="/images/defaults/icon_5.jpeg">
							</label>
							<label>
								<input type="radio" name="icon" value="/images/defaults/icon_6.jpeg">
								<img src="/images/defaults/icon_6.jpeg">
							</label>
						</div>
					</div>
					<div>
						<p class="mini-title">日記一覧：</p>
							<div class="user-diary-grid">
								<%
                  while (diaryRs.next()) {
                    String image = diaryRs.getString("image");
                    if (image == null || image.isEmpty()) {
                        image = "/images/defaults/default.png";
                    }
                %>
								<a href="/diary-app-java/diary/show.jsp?diary_id=<%= diaryRs.getInt("diary_id") %>&from=myPage&page=1" class="grid-item">
									<img src="<%= h(image) %>">
								</a>
								<%
									}
								%>
							</div>
					</div>
				</div>
				<div class="update-button-my-page">
					<button class="" type="submit">更新</button>
				</div>
			</form>

			<div class="user-diaries">
							<!-- ページが2以上ならページネーション -->
						<div class="pagination">

				<!-- 1ページ目は戻るボタン無効化 -->

									<button class="page-button arrow gray"><</button>

															<button class="page-button current">1</button>
																				<a href="?page=2"><button class="page-button">2</button></a>

				<!-- 最終ページ目は進むボタン無効化 -->

									<a href="?page=2" class="page-button arrow">></a>

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
