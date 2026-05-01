
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
	String success = (String) session.getAttribute("success");
	String error = (String) session.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
	<main>
		<section class="container">
				<% if(success != null) { %>
					<p class="green-message"><%= success %></p>
				<%
					}
					session.removeAttribute("success");
				%>

				<% if(error != null) { %>
					<p class="error-message"><%= error %></p>
				<%
					}
					session.removeAttribute("error");
				%>
			<h1 class="page-title">ログイン</h1>

			<form action="/diary-app-java/auth/login.jsp" method="POST">

				<div class="input-area">
					<div class="form">
						<label for="email">メールアドレス</label>
						<input class="" type="email" name="email" id="email"
							value="">
					</div>

					<div class="form">
						<label for="password">パスワード</label>
						<input class="" type="password" name="password"
							id="password">
					</div>
				</div>
				<div class="right">
					<div class="register-link-button">
						<a class="back-button" href="/diary-app-java/auth/create.jsp">アカウント作成がまだの方はこちらから</a>
					</div>
					<div class="login-button">
						<button class="" type="submit">ログイン</button>
					</div>
				</div>

			</form>
		</section>
	</main>
<%@ include file="/includes/footer.jsp" %>
</body>
</html>
