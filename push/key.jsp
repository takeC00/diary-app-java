<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/includes/push-init.jsp" %>
<%
out.print("{\"publicKey\":\"" + vapidPublicKey + "\",\"subscribers\":" + subscriptions.size() + "}");
%>
