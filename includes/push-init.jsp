<%@ page pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.security.KeyPair" %>
<%@ page import="java.security.KeyPairGenerator" %>
<%@ page import="java.security.Security" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.concurrent.ConcurrentHashMap" %>
<%@ page import="org.bouncycastle.jce.ECNamedCurveTable" %>
<%@ page import="org.bouncycastle.jce.interfaces.ECPrivateKey" %>
<%@ page import="org.bouncycastle.jce.interfaces.ECPublicKey" %>
<%@ page import="org.bouncycastle.jce.provider.BouncyCastleProvider" %>
<%@ page import="org.bouncycastle.jce.spec.ECNamedCurveParameterSpec" %>
<%@ page import="nl.martijndwars.webpush.PushService" %>
<%@ page import="nl.martijndwars.webpush.Subscription" %>
<%@ page import="nl.martijndwars.webpush.Utils" %>
<%!
public String jsonString(String json, String key) {
    String needle = "\"" + key + "\"";
    int keyIndex = json.indexOf(needle);
    if (keyIndex < 0) {
        return "";
    }
    int colon = json.indexOf(':', keyIndex);
    int start = json.indexOf('"', colon + 1);
    int end = json.indexOf('"', start + 1);
    if (start < 0 || end < 0) {
        return "";
    }
    return json.substring(start + 1, end).replace("\\/", "/");
}

public String escapeJson(String value) {
    if (value == null) {
        return "";
    }
    return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
}
%>
<%
request.setCharacterEncoding("UTF-8");
synchronized (application) {
    if (application.getAttribute("pushService") == null) {
        if (Security.getProvider(BouncyCastleProvider.PROVIDER_NAME) == null) {
            Security.addProvider(new BouncyCastleProvider());
        }
        ECNamedCurveParameterSpec parameterSpec = ECNamedCurveTable.getParameterSpec(Utils.CURVE);
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(Utils.ALGORITHM, BouncyCastleProvider.PROVIDER_NAME);
        keyPairGenerator.initialize(parameterSpec);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        String publicKey = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(Utils.encode((ECPublicKey) keyPair.getPublic()));
        String privateKey = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(Utils.encode((ECPrivateKey) keyPair.getPrivate()));
        application.setAttribute("vapidPublicKey", publicKey);
        application.setAttribute("pushService", new PushService(publicKey, privateKey, "mailto:diary@localhost"));
        application.setAttribute("pushSubscriptions", new ConcurrentHashMap<String, Subscription>());
    }
}
String vapidPublicKey = (String) application.getAttribute("vapidPublicKey");
PushService pushService = (PushService) application.getAttribute("pushService");
Map<String, Subscription> subscriptions = (Map<String, Subscription>) application.getAttribute("pushSubscriptions");
%>
