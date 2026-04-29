
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
	<main>
		<section class="container">
			<h1 class="page-title">ログイン</h1>

			<form action="/login" method="POST">

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
						<a class="back-button" href="/diary-app-java/auth/register.jsp">アカウント作成がまだの方はこちらから</a>
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
