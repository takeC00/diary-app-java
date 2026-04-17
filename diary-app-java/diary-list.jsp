
<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="ja">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>写真日記一覧</title>
		<link rel="stylesheet" href="/css/common.css">
		<link rel="stylesheet" href="/css/header.css">
		<link rel="stylesheet" href="/css/footer.css">
		<link rel="stylesheet" href="/css/diaries.css">
		<link rel="stylesheet" href="/css/detail.css">
		<link rel="stylesheet" href="/css/register.css">
		<link rel="stylesheet" href="/css/edit.css">
		<link rel="stylesheet" href="/css/userPage.css">
	</head>
	<header class="">
		<div class="flex">
			<!-- ロゴ -->
			<div class="flex">
				<a href="/" class="flex">
					<img src="/images/defaults/default.png" class="logo">
					<span class="">Photo Diary</span>
				</a>
			</div>
			<!-- ナビ -->
			<nav class="right">
				<ul class="flex right">
					<li class="">
						<a href="/diary/create">新規作成</a>
					</li>
					<li class="">
						<a href="/myDiaries">自分日記一覧</a>
					</li>
					<li class="">
						<a href="/myPage/1">
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
	</header>

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
							<a href="/myPage/1">
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
