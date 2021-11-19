<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:import url="/WEB-INF/views/layout/head.jsp" />
<c:import url="/WEB-INF/views/layout/header.jsp" />
<!-- header end -->

<!-- 개별 스타일 및 스크립트 영역 -->
<style>
table {
	margin: 0 auto;
}

</style>

<script type="text/javascript">
$(document).ready(function(){
	
	$("#btnDelete").click(function() {
		var answer = confirm("쪽지를 삭제하시겠습니까?\n 해당 작업은 되돌릴 수 없습니다.")

		if( answer == true ){
			location.href="/message/send/delete?msgNo=";
		} else {
			return false;
		}
	})

})
</script>

<!-- 개별 영역 끝 -->

<div class="wrap">
<div class="container">

<h3>보낸 쪽지</h3>

<table class="table table-hover" style="width:500px;">
	<tr>
		<td>받는 사람</td>
		<td>${userNick } </td>
		<td>보낸 시간</td>
		<td><fmt:formatDate value="${msg.msgDate }" pattern="yy-MM-dd HH:mm" /></td>
	</tr>
	<tr>
		<td colspan="4">${msg.msgTitle }</td>
	</tr>

	<tr>
		<td colspan="4" height="200px;">${msg.msgContent }</td>
	</tr>
	
</table>


<a href="/message/send/delete?msgNo=${msg.msgNo }"><button id="btnDelete">삭제</button></a>

</div><!-- .container end -->
</div><!-- .wrap end -->

<!-- footer start -->
<c:import url="/WEB-INF/views/layout/footer.jsp" />

