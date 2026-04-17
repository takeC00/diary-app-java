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
			<?php if(!empty($_SESSION['user'])) :?>

				<li class="">
					<a href="/diary/create">新規作成</a>
				</li>

				<li class="">
					<a href="/myDiaries">自分日記一覧</a>
				</li>

				<li class="">
					<a href="/myPage/<?= $_SESSION['user']['id'] ?>">
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
				<?php endif ;?>
			</ul>
		</nav>
	</div>
	<div class="copy-light">
		<small>&copy; 2026 PhotoDiaryApp-PHP.</small>
	</div>
</footer>
