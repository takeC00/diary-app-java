<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
<main>
	<section class="container">
		<h1 class="page-title">チャット通知テスト</h1>
		<ol>
			<li>Chrome か Firefox で開く</li>
			<li>「通知をオン」を押す（この端末を通知先として登録）</li>
			<li>このタブを閉じる</li>
			<li>別タブでこのページを開き、メッセージを送信する</li>
		</ol>

		<h2>1. 通知を受け取る側</h2>
		<button type="button" id="subscribe-button">通知をオン</button>
		<p id="subscribe-status"></p>

		<h2>2. メッセージを送る側</h2>
		<div class="input-area">
			<div class="form">
				<label for="name">送信者名</label>
				<input type="text" id="name" value="相手">
			</div>
			<div class="form">
				<label for="message">メッセージ</label>
				<input type="text" id="message" value="こんにちは">
			</div>
		</div>
		<button type="button" id="send-button">メッセージを送信</button>
		<p id="send-status"></p>
	</section>
</main>
<%@ include file="/includes/footer.jsp" %>
<script>
(function () {
	const ctx = '${pageContext.request.contextPath}';

	function urlBase64ToUint8Array(base64String) {
		const padding = '='.repeat((4 - base64String.length % 4) % 4);
		const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
		const rawData = atob(base64);
		const outputArray = new Uint8Array(rawData.length);
		for (let i = 0; i < rawData.length; ++i) {
			outputArray[i] = rawData.charCodeAt(i);
		}
		return outputArray;
	}

	document.getElementById('subscribe-button').addEventListener('click', async function () {
		const status = document.getElementById('subscribe-status');
		try {
			if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
				status.textContent = 'このブラウザは Web Push に対応していません（Chrome / Firefox を使ってください）';
				return;
			}

			const permission = await Notification.requestPermission();
			if (permission !== 'granted') {
				status.textContent = '通知が許可されませんでした';
				return;
			}

			const registration = await navigator.serviceWorker.register(ctx + '/sw.js', { updateViaCache: 'none' });
			await registration.update();
			await navigator.serviceWorker.ready;

			const existing = await registration.pushManager.getSubscription();
			if (existing) {
				await existing.unsubscribe();
			}

			const keyRes = await fetch(ctx + '/push/key.jsp');
			const { publicKey } = await keyRes.json();
			const subscription = await registration.pushManager.subscribe({
				userVisibleOnly: true,
				applicationServerKey: urlBase64ToUint8Array(publicKey)
			});

			const saveRes = await fetch(ctx + '/push/subscribe.jsp', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(subscription)
			});
			if (!saveRes.ok) {
				throw new Error(await saveRes.text());
			}

			status.textContent = '登録しました。このタブを閉じても、メッセージ送信で通知が届きます。';
		} catch (e) {
			status.textContent = 'エラー: ' + (e && e.message ? e.message : e);
		}
	});

	document.getElementById('send-button').addEventListener('click', async function () {
		const status = document.getElementById('send-status');
		try {
			const sendRes = await fetch(ctx + '/push/send.jsp', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					name: document.getElementById('name').value,
					message: document.getElementById('message').value
				})
			});
			if (!sendRes.ok) {
				throw new Error(await sendRes.text());
			}
			const result = await sendRes.json();
			status.textContent = '送信しました（' + result.sent + '件）。閉じたタブ側の通知を確認してください。';
		} catch (e) {
			status.textContent = 'エラー: ' + (e && e.message ? e.message : e);
		}
	});
})();
</script>
</body>
</html>
