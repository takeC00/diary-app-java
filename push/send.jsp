<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="nl.martijndwars.webpush.Encoding" %>
<%@ page import="nl.martijndwars.webpush.Notification" %>
<%@ page import="nl.martijndwars.webpush.Subscription" %>
<%@ include file="/includes/push-init.jsp" %>
<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    return;
}

try {
    if (subscriptions.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/plain; charset=UTF-8");
        out.print("通知先がまだ登録されていません。先に「通知をオン」してください。");
        return;
    }

    String body = request.getReader().lines().collect(Collectors.joining());
    String name = jsonString(body, "name");
    String message = jsonString(body, "message");
    if (name.isEmpty()) {
        name = "相手";
    }
    if (message.isEmpty()) {
        message = "新しいメッセージが届きました";
    }

    String payload = "{\"title\":\"" + escapeJson(name) + "\",\"body\":\"" + escapeJson(message) + "\"}";
    int sent = 0;

    for (Subscription subscription : subscriptions.values()) {
        HttpResponse pushResponse = pushService.send(new Notification(subscription, payload), Encoding.AES128GCM);
        int status = pushResponse.getStatusLine().getStatusCode();
        if (status >= 200 && status < 300) {
            sent++;
        } else if (status == 404 || status == 410) {
            subscriptions.remove(subscription.endpoint);
        }
    }

    out.print("{\"ok\":true,\"sent\":" + sent + "}");
} catch (Exception e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    response.setContentType("text/plain; charset=UTF-8");
    out.print(e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName());
}
%>
