<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>

<% String error	 = (String) session.getAttribute("error"); %>
	<main>
		<section>
			<% if(error != null) { %>
			<p class="error-message"><%= error %></p>
			<%
				}
				session.removeAttribute("error");
			%>
			<img class="err-img" src = "/images/defaults/404.jpeg">
		</section>
	</main>
</body>
<footer>
	<div class="flex">

		<!-- ロゴ -->
		<div class="">
			<a href="/" class="flex">
				<img src="/images/defaults/default.png" class="logo-mid">
			</a>
		</div>

		<!-- ナビ -->
		<nav class="">
			<ul class="flex">

				<li class="">
					<a href="/diary/create">新規作成</a>
				</li>

				<li class="">
					<a href="/myDiaries">自分日記一覧</a>
				</li>

				<li class="">
					<a href="/myPage/22">
						マイページ
					</a>
				</li>

				<li class="">
					<a href="/" class="">
						公開日記
					</a>
				</li>


				<li class="">
					<form method="POST" action="/logout" class="">
						<button type="submit" class="">
							ログアウト
						</button>
					</form>
				</li>
							</ul>
		</nav>
	</div>
	<div class="copy-light">
		<small>&copy; 2026 PhotoDiaryApp-PHP.</small>
	</div>
</footer>

</html>
