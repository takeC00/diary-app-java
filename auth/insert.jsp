<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
Connection conn = null;
PreparedStatement ps = null;
PreparedStatement countPs = null;
ResultSet rs = null;
ResultSet countRs = null;

request.setCharacterEncoding("UTF-8");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
    String user = "root";
    String password = "root";

    conn = DriverManager.getConnection(url, user, password);

		String name =   "";
		String email =  "";
		String pass =   "";
		String rePass = "";

		name = request.getParameter("name");
		email = request.getParameter("email");
		pass = request.getParameter("password");
		rePass = request.getParameter("rePassword");

		List<String> errors = new ArrayList<>();
		if(name == ""){
				errors.add("名前は必須です");
		}

		if(email == ""){
				errors.add("メールアドレスは必須です");
		}

		if(!pass.equals(rePass)){
				errors.add("パスワードとパスワード(確認)が一致しません");
		}

		if (pass == "" || !pass.matches("^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")) {
				errors.add("パスワードは半角英数字で8文字以上で入力してください");
		}
		if (!errors.isEmpty()) {
				session.setAttribute("errors", errors);
				response.sendRedirect("/diary-app-java/auth/create.jsp");
				return;
		}

		String hashedPassword = BCrypt.hashpw(pass, BCrypt.gensalt());

		String sql = "INSERT INTO users (`name`,`email`, `icon`, `password`,`created_at`,`updated_at`)"
						+ "VALUES (?, ?, ?, ?, now(), now())";

    ps = conn.prepareStatement(sql);
    ps.setString(1, name);
    ps.setString(2, email);
		ps.setString(3, "/images/defaults/icon_1.jpeg");
		ps.setString(4, hashedPassword);
		int result = ps.executeUpdate();
		if (result == 1) {
				session.setAttribute("success", "ユーザー作成しました");
				response.sendRedirect("/diary-app-java/");
				return;
		} else {
				out.println("登録に失敗しました");
		}

	} catch (Exception e) {
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
	}
%>
