<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer>
	<div class="flex">
		<!-- ロゴ -->
		<div class="">
			<a href="/diary-app-java/diary/" class="flex">
				<img src="${pageContext.request.contextPath}/images/defaults/default.png" class="logo-mid">
			</a>
		</div>
		<!-- ナビ -->
		<nav class="">
			<ul class="flex right">
				<li class="">
					<a href="/diary-app-java/diary/create.jsp">新規作成</a>
				</li>
				<li class="">
					<a href="/diary-app-java/myDiary/">自分日記一覧</a>
				</li>
				<li class="">
					<a href="/diary-app-java/myPage/">
						マイページ
					</a>
				</li>
				<li class="">
					<a href="/diary-app-java/diary/" class="">
						公開日記
					</a>
				</li>
				<li class="">
					<form method="POST" action="/diary-app-java/auth/logout.jsp" class="">
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
