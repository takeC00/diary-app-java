import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.util.List;
import java.util.ArrayList;

@WebServlet("/diary/update")
@MultipartConfig
public class DiaryUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String diaryDate = request.getParameter("diary_date");
        String body = request.getParameter("body");
        String isPublic = request.getParameter("is_public");
				String pageParam = request.getParameter("pageParam");

				if (pageParam == null || pageParam.isEmpty() || "null".equals(pageParam)) {
					pageParam = "1";
				}

        Integer loginUserId = (Integer) session.getAttribute("user_id");

        if (loginUserId == null) {
            session.setAttribute("error", "ログインしてください");
            response.sendRedirect("/diary-app-java/login.jsp");
            return;
        }

        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "IDが指定されていません");
            response.sendRedirect("/diary-app-java/diary/index.jsp");
            return;
        }

        if (isPublic == null) {
            isPublic = "0";
        }

        int id = Integer.parseInt(idParam);

        String imagePath = null;

        Part filePart = request.getPart("diary_image");

        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName())
                    .getFileName()
                    .toString();

            String extension = "";
            int dotIndex = originalFileName.lastIndexOf(".");
            if (dotIndex != -1) {
                extension = originalFileName.substring(dotIndex);
            }

            String fileName = "diary_" + id + "_" + System.currentTimeMillis() + extension;

            String uploadDirPath = getServletContext().getRealPath("/images/diaries");
            File uploadDir = new File(uploadDirPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String savePath = uploadDirPath + File.separator + fileName;
            filePart.write(savePath);

            imagePath = "/diary-app-java/images/diaries/" + fileName;
        }

				// バリデーション
				List<String> errors = new ArrayList<>();

				if (title == null || title.trim().isEmpty()) {
						errors.add("タイトルは必須です");
				}

				if (diaryDate == null || diaryDate.trim().isEmpty()) {
						errors.add("日付は必須です");
				}

				if (!errors.isEmpty()) {
					session.setAttribute("errors", errors);
					response.sendRedirect("/diary-app-java/diary/edit.jsp?diary_id=" + id + "&page=" + pageParam);
					return;
				}
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://localhost:8889/diary_app_php?useSSL=false&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8";
            String user = "root";
            String password = "root";

            conn = DriverManager.getConnection(url, user, password);

            String sql;

            if (imagePath != null) {
                sql = "UPDATE diaries "
                    + "SET title = ?, diary_date = ?, image = ?, is_public = ?, body = ? "
                    + "WHERE id = ? AND user_id = ?";

                ps = conn.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, diaryDate);
                ps.setString(3, imagePath);
                ps.setString(4, isPublic);
                ps.setString(5, body);
                ps.setInt(6, id);
                ps.setInt(7, loginUserId);
            } else {
                sql = "UPDATE diaries "
                    + "SET title = ?, diary_date = ?, is_public = ?, body = ? "
                    + "WHERE id = ? AND user_id = ?";

                ps = conn.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, diaryDate);
                ps.setString(3, isPublic);
                ps.setString(4, body);
                ps.setInt(5, id);
                ps.setInt(6, loginUserId);
            }

            int result = ps.executeUpdate();

            if (result == 0) {
                session.setAttribute("error", "更新できませんでした。存在しない日記、または権限がありません。");
                response.sendRedirect("/diary-app-java/diary/index.jsp");
                return;
            }

            session.setAttribute("success", "更新しました");
            response.sendRedirect("/diary-app-java/diary/show.jsp?diary_id=" + id + "&page=" + pageParam);
						return;

        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
}
