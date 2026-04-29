<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.io.File" %>

<%
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

		// パラメータ用変数の初期化
		int id = 0;
		String image = "";
		String title = "";
		String diaryDate = "";
		String body = "";
		String userName = "";
		String checked = "";
		String isPublic = "";
		Part filePart = request.getPart("diary_image");

		String imagePath = null;

		if (filePart != null && filePart.getSize() > 0) {
				String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

				String uploadDirPath = application.getRealPath("/images/diaries");
				File uploadDir = new File(uploadDirPath);

				if (!uploadDir.exists()) {
						uploadDir.mkdirs();
				}

				filePart.write(uploadDirPath + File.separator + fileName);

				imagePath = "/diary-app-java/images/diaries/" + fileName;
		}
    // パラメータ取得
    String idParam = request.getParameter("id");
		if (idParam == null) {
        out.println("IDが指定されていません");
        return;
    }

    image = request.getParameter("diary_image");
    title = request.getParameter("title");
    diaryDate = request.getParameter("diary_date");
    body = request.getParameter("body");
		isPublic = request.getParameter("is_public");
    idParam = request.getParameter("id");

    id = Integer.parseInt(idParam);

    // ログインユーザーID（仮）
    Integer loginUserId = (Integer)session.getAttribute("user_id");
    if (loginUserId == null) {
        out.println("ログインしてください");
        return;
    }

    conn = DriverManager.getConnection(url, user, password);

    // ★自分の投稿だけ更新できるようにする（重要）
    String sql = "UPDATE diaries SET title = ? , diary_date = ?, image = ?, is_public = ?, body = ? WHERE id = ?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, title);
    ps.setString(2, diaryDate);
    ps.setString(3, image);
    ps.setString(4, isPublic);
    ps.setString(5, body);
		ps.setInt(6, id);

    int result = ps.executeUpdate();

    if (result == 0) {
        out.println("更新できませんでした（権限がない可能性）");
    } else {
				//削除成功メッセージ
				session.setAttribute("success", "更新しました");
        // 一覧へリダイレクト
        response.sendRedirect("/diary-app-java/diary/index.jsp");
    }

} catch (Exception e) {
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
} finally {
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>

<pre>
idParam: <%= request %>
</pre>
