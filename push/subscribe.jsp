<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="nl.martijndwars.webpush.Subscription" %>
<%@ include file="/includes/push-init.jsp" %>
<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    return;
}

try {
    String body = request.getReader().lines().collect(Collectors.joining());
    String endpoint = jsonString(body, "endpoint");
    String p256dh = jsonString(body, "p256dh");
    String auth = jsonString(body, "auth");

    if (endpoint.isEmpty() || p256dh.isEmpty() || auth.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/plain; charset=UTF-8");
        out.print("購読情報が不足しています");
        return;
    }

    subscriptions.put(endpoint, new Subscription(endpoint, new Subscription.Keys(p256dh, auth)));
    out.print("{\"ok\":true,\"subscribers\":" + subscriptions.size() + "}");
} catch (Exception e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    response.setContentType("text/plain; charset=UTF-8");
    out.print(e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName());
}
%>
