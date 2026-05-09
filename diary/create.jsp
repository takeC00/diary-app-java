<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<% Boolean myPage = false; %>
<% List<String> errors = (List<String>) session.getAttribute("errors"); %>

<!DOCTYPE html>
<html lang="ja">
<%@ include file="/includes/head.jsp" %>
<body>
<%@ include file="/includes/headder.jsp" %>
	<main>
		<section>
			<%
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
			<div class="button-section">
				<a href="/diary-app-java/diary/"><button class="back">戻る</button></a>
			</div>

			<form action="/diary-app-java/diary/insert.jsp" method="POST" enctype="multipart/form-data">

				<div class="form-row">
					<p class="mini-title">タイトル：</p>
					<input type="text" name="title"
						value=""
						class="">
				</div>

				<div class="form-row">
					<p class="mini-title">日付：</p>
					<input type="date" name="diary_date"
						value=""
						class="">
				</div>

				<div class="form-row">
					<p class="mini-title">画像：</p>
					<div>
						<input type="file" name="diary_image" id="imageInput"
							class="">
						<img id="preview" class="preview">
					</div>
				</div>

				<div class="form-row">
					<p class="mini-title public">公開設定：</p>
					<div class="radio-group">

						<label>
							<input type="radio" name="is_public" value="1" checked>
							公開
						</label>

						<label>
							<input type="radio" name="is_public" value="0" >
							非公開
						</label>
					</div>
				</div>

				<div class="form-row">
					<p class="mini-title">本文：</p>
					<textarea class=""
						name="body"></textarea>
				</div>

				<div class="button-section">
					<button class="create" type="submit">新規作成</button>
				</div>
			</form>
		</section>
	</main>
	<%@ include file="/includes/footer.jsp" %>
</html>

<script>
document.getElementById('imageInput').addEventListener('change', function(e) {
	const file = e.target.files[0];

	if (!file) return;

	const reader = new FileReader();

	reader.onload = function(event) {
		const img = document.getElementById('preview');
		img.src = event.target.result;
		img.style.display = 'block';
	};

	reader.readAsDataURL(file);
});
</script>
