<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	// ログアウト
	session.removeAttribute("user_id");
	session.setAttribute("success", "ログアウトしました");
	response.sendRedirect("/diary-app-java/");
%>
