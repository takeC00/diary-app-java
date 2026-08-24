<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.diary.db.DbConfig" %>

<%
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement ps = null;

try {
    // パラメータ取得
    String idParam = request.getParameter("id");
    if (idParam == null) {
        out.println("IDが指定されていません");
        return;
    }

    int id = Integer.parseInt(idParam);

    // ログインユーザーID（仮）
    Integer loginUserId = (Integer)session.getAttribute("user_id");
    if (loginUserId == null) {
        out.println("ログインしてください");
        return;
    }

    conn = DbConfig.getConnection();

    // ★自分の投稿だけ削除できるようにする（重要）
    String sql = "UPDATE diaries set deleted_at = now()  WHERE id = ? AND user_id = ?";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, id);
    ps.setInt(2, loginUserId);

    int result = ps.executeUpdate();

    if (result == 0) {
        out.println("削除できませんでした（権限がない可能性）");
    } else {
				//削除成功メッセージ
				session.setAttribute("success", "削除しました");
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
