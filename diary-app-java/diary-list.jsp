
<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="ja">
	<%@ include file="includes/head.jsp"%>
	<%@ include file="includes/headder.jsp"%>
	<body>
		<main>
			<section>
				<h1>公開日記一覧</h1>
				<div>
					<div class="diary-list">
						<article class="diary-card">
							<a href="/show/80?from=public&page=1">
								<img src="/images/defaults/diary/diary_080.jpeg" alt="日記画像"	class="diary-image">
								<h2 class="diary-title">日記080 </h2>
								<div class="diary-date">2026-03-21 </div>
								<p class="diary-user">金子テスト </p>
							</a>
						</article>
					</div>
				</div>

				<!-- ページが2以上ならページネーション -->
				<div class="pagination">
					<!-- 1ページ目は戻るボタン無効化 -->
					<button class="page-button arrow gray"><</button>
						<button class="page-button current">1</button>
						<a href="?page=2"><button class="page-button">2</button></a>
						<a href="?page=3"><button class="page-button">3</button></a>
						<a href="?page=4"><button class="page-button">4</button></a>
						<a href="?page=5"><button class="page-button">5</button></a>
						<a href="?page=6"><button class="page-button">6</button></a>
						<a href="?page=7"><button class="page-button">7</button></a>
						<!-- 最終ページ目は進むボタン無効化 -->
						<a href="?page=2" class="page-button arrow">></a>
					</div>
				</section>
			</main>
		</body>
		<%@ include file="includes/footer.jsp"%>
	</html>
