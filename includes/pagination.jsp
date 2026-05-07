<%
String userIdParamForPaging = request.getParameter("user_id");
String userIdQuery = "";
String listPageUrl = "";

if (userIdParamForPaging != null && !userIdParamForPaging.isEmpty()) {
    userIdQuery = "&user_id=" + userIdParamForPaging;
}
%>
<% if (totalPages > 1) { %>
<div class="pagination">
    <%
		if (!myPage){
			listPageUrl = "/diary-app-java/myPage/index.jsp?page=";
		} else {
			listPageUrl = "/diary-app-java/diary/index.jsp?page=";
		}


    if (currentPage <= 1) {
    %>
        <span class="page-button arrow gray">&lt;</span>
    <%
    } else {
    %>
        <a href="<%= listPageUrl %><%= currentPage - 1 %>" class="page-button arrow">&lt;</a>
    <%
    }

    for (int i = 1; i <= totalPages; i++) {
        if (i == currentPage) {
    %>
        <span class="page-button current"><%= i %></span>
    <%
        } else {
    %>
        <a href="<%= listPageUrl %><%= i %>" class="page-button"><%= i %></a>
    <%
        }
    }

    if (currentPage >= totalPages) {
    %>
        <span class="page-button arrow gray">&gt;</span>
    <%
    } else {
    %>
        <a href="<%= listPageUrl %><%= currentPage + 1 %>" class="page-button arrow">&gt;</a>
    <%
    }
    %>
</div>
<% } %>
