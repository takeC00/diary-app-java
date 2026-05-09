<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>


<%
	request.setCharacterEncoding("UTF-8");
	Connection conn = null;
	PreparedStatement ps = null;
	String userIcon = "";
	String icon = "";

	try{
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

	  // ユーザー情報
		String userSql = "SELECT id, name, icon, introduction "
              + "FROM users "
              + "WHERE id = ?";
		PreparedStatement userPs = conn.prepareStatement(userSql);
		userPs.setInt(1, userId);
		ResultSet userRs = userPs.executeQuery();

		if (userRs.next()) {
			if (userRs.getString("icon") != null && !userRs.getString("icon").isEmpty()) {
					userIcon = userRs.getString("icon");
			}
		}

		if(request.getParameter("icon")!=null){
			icon = request.getParameter("icon");
		}else{
			icon = userIcon;
		}
		String introduction = request.getParameter("introduction");

		// 更新処理
		userRs = userPs.executeQuery();
		String sql = "UPDATE users SET icon = ?, introduction = ? WHERE id = ?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, icon);
		ps.setString(2, introduction);
		ps.setInt(3, userId);

    int result = ps.executeUpdate();
		if (result > 0) {
      session.setAttribute("success", "マイページを更新しました");
    } else {
      session.setAttribute("error", "更新対象が見つかりませんでした");
    }
    response.sendRedirect("/diary-app-java/myPage/");
	} catch (Exception e) {
    e.printStackTrace();
    session.setAttribute("error", "更新中にエラーが発生しました");
    response.sendRedirect("/diary-app-java/myPage/");
    return;
	} finally {
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
	}
%>
