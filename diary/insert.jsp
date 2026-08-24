<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="com.diary.db.DbConfig" %>
<%
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement ps = null;
boolean imageCheck = false;
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    session.setAttribute("error", "ログインしてください");
    response.sendRedirect("/diary-app-java/");
    return;
}

try {
		// パラメータ用変数の初期化
		String title = "";
		String diaryDate = "";
		String body = "";
		String isPublic = "0";
		String imagePath = "";

		ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
		List<FileItem> items = upload.parseRequest(request);

		for (FileItem item : items) {
			if (item.isFormField()) {
					// テキスト
					String name = item.getFieldName();
					String value = item.getString("UTF-8");

					if ("title".equals(name)) title = value;
					if ("diary_date".equals(name)) diaryDate = value;
					if ("body".equals(name)) body = value;
					if ("is_public".equals(name)) isPublic = value;

			} else {
				// ファイル
				if (item.getSize() > 0) {
					String originalFileName = new File(item.getName()).getName();

					String ext = "";
					int dotIndex = originalFileName.lastIndexOf(".");
					if (dotIndex != -1) {
							ext = originalFileName.substring(dotIndex);
					}

					String fileName = "diary_" + new java.util.Date().getTime() + ext;

					String uploadDirPath = application.getRealPath("/images/diaries");
					File uploadDir = new File(uploadDirPath);
					if (!uploadDir.exists()) {
							uploadDir.mkdirs();
					}

					File saveFile = new File(uploadDir, fileName);
					item.write(saveFile);

					imagePath = "/diary-app-java/images/diaries/" + fileName;
					imageCheck = true;
				}
			}
		}

		// バリデーション
		List<String> errors = new ArrayList<>();

		if (title == null || title.trim().isEmpty()) {
				errors.add("タイトルは必須です");
		}

		if (diaryDate == null || diaryDate.trim().isEmpty()) {
				errors.add("日付は必須です");
		}

		if (!imageCheck){
			errors.add("画像は必須です");
		}

		if (!errors.isEmpty()) {
			session.setAttribute("errors", errors);
			response.sendRedirect("/diary-app-java/diary/create.jsp");
			return;
		}


    conn = DbConfig.getConnection();

		String sql = "INSERT INTO diaries (`user_id`, `title`, `diary_date`, `is_public`, `body`, `image`, `created_at`,`updated_at`)"
						+ " VALUES (?, ?, ?, ?, ?, ?, now(), now())";
		ps = conn.prepareStatement(sql);
    ps.setInt(1, userId);
    ps.setString(2, title);
    ps.setString(3, diaryDate);
    ps.setString(4, isPublic);
    ps.setString(5, body);
		ps.setString(6, imagePath);

    int result = ps.executeUpdate();

    if (result == 0) {
        out.println("更新できませんでした（権限がない可能性）");
    } else {
				//削除成功メッセージ
				session.setAttribute("success", "日記作成しました");
        // 一覧へリダイレクト
        response.sendRedirect("/diary-app-java/diary/index.jsp");
    }

} catch (Exception e) {
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
} finally {
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
