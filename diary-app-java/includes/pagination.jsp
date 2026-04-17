			<!-- ページが2以上ならページネーション -->
			<?php if ($totalPages > 1): ?>
			<div class="pagination">

				<!-- 1ページ目は戻るボタン無効化 -->
				<?php
					$isFirstPage = ($page === 1);
					$nextPage = $page - 1;
				?>

				<?php if ($isFirstPage): ?>
					<button class="page-button arrow gray"><</button>
				<?php else: ?>
					<a href="?page=<?= $nextPage ?>" class="page-button arrow"><</a>
				<?php endif; ?>

				<?php for ($i = 1; $i <= $totalPages; $i++): ?>
					<?php if ($page === $i): ?>
						<button class="page-button current"><?= $i ?></button>
					<?php else: ?>
						<a href="?page=<?= $i ?>"><button class="page-button"><?= $i ?></button></a>
					<?php endif; ?>
				<?php endfor; ?>

				<!-- 最終ページ目は進むボタン無効化 -->
				<?php
					$isLastPage = ($page === $totalPages);
					$nextPage = $page + 1;
				?>

				<?php if ($isLastPage): ?>
					<button class="page-button arrow gray">></button>
				<?php else: ?>
					<a href="?page=<?= $nextPage ?>" class="page-button arrow">></a>
				<?php endif; ?>

			</div>
			<?php endif; ?>
