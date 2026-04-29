<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

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

		int userId = 0;
		String inputEmail =  "";
		String inputPass  =  "";
		String dbEmail =  "";
		String dbPass  =  "";

		inputEmail = request.getParameter("email");
		inputPass  = request.getParameter("password");

    String sql = "SELECT id, password, email "
      + "FROM users "
      + "WHERE email = ? ";

    ps = conn.prepareStatement(sql);
    ps.setString(1, inputEmail);
    rs = ps.executeQuery();

		while (rs.next()) {
			userId  = rs.getInt("id");
			dbEmail = rs.getString("email");
			dbPass  = rs.getString("password");
		}

		if (userId==0){
				//メアドに紐づくユーザーがない場合
				session.setAttribute("error", "登録されていないメールアドレスです");
        // ログイン画面へリダイレクト
        response.sendRedirect("/diary-app-java/");
				return;
		}

		if (!BCrypt.checkpw(inputPass, dbPass)) {
				//パスワードが一致しない場合
				session.setAttribute("error", "メールアドレスとパスワードの組み合わせが正しくありません");
        // ログイン画面へリダイレクト
        response.sendRedirect("/diary-app-java/");
				return;
		}

			// ログイン成功
			session.setAttribute("user_id", userId);
			session.setAttribute("success", "ログインしました");
			response.sendRedirect("/diary-app-java/diary/");
%>

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
