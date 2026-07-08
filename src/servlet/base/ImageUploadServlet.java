package servlet.base;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/uploadImage")
@MultipartConfig(
        maxFileSize = 10 * 1024 * 1024,    // 10MB
        maxRequestSize = 20 * 1024 * 1024
)
public class ImageUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        try {
            Part filePart = req.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                resp.getWriter().write("{\"errno\":1, \"message\":\"未选择文件\"}");
                return;
            }

            // 生成唯一文件名
            String submittedFileName = filePart.getSubmittedFileName();
            String ext = "";
            int dotIndex = submittedFileName.lastIndexOf(".");
            if (dotIndex >= 0) {
                ext = submittedFileName.substring(dotIndex);
            }
            String newFileName = UUID.randomUUID().toString() + ext;

            // 保存到服务器 uploads 目录
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + newFileName);

            // 返回可访问的 URL
            String imageUrl = req.getContextPath() + "/uploads/" + newFileName;
            resp.getWriter().write("{\"errno\":0, \"data\":{\"url\":\"" + imageUrl + "\"}}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"errno\":1, \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}