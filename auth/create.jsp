<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
	request.setCharacterEncoding("UTF-8");
	String error	= (String) session.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
	<main>
		<section class="container">
			<%
			List<String> errors = (List<String>) session.getAttribute("errors");

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
			<h1 class="page-title">新規作成</h1>

			<form action="/diary-app-java/auth/insert.jsp" method="POST">

				<div class="form">
					<label for="name">名前</label>
					<input class="" type="name" placeholder="田中太郎"
						name="name" id="name"
						value="">
				</div>

				<div class="form">
					<label for="email">メールアドレス</label>
					<input class="" type="email"
						placeholder="sample@hogehoge.com" name="email" id="email"
						value="">
				</div>

				<div class="form">
					<label for="password">パスワード</label>
					<input class="" class="" type="password"
						placeholder="半角英数字で8文字以上" name="password" id="password">
				</div>

				<div class="form">
					<label for="rePassword">パスワード(確認)</label>
					<input class="" type="rePassword"
						placeholder="パスワードと同じ値を入力" name="rePassword" id="rePassword">
				</div>

				<div class="right">
					<div class="register-button">
						<button class="" type="submit">登録</button>
					</div>
					<div class="register-button-back">
						<a class="back-button" href="/login">戻る</a>
					</div>
				</div>

			</form>
		</section>
	</main>
<%@ include file="/includes/footer.jsp" %>
</body>
</html>
