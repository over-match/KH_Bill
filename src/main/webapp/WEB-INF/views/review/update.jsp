<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!doctype html>
<html lang="ko">
<head>
    <%--page title--%>
    <title>이건못참조</title>
	<c:import url="/WEB-INF/views/layout/head.jsp" />
</head>
<body>
<%--header--%>
<c:import url="/WEB-INF/views/layout/header.jsp" />

<!-- 스마트 에디터 2 라이브러리 로드 -->
<script type="text/javascript" src="/resources/se2/js/service/HuskyEZCreator.js"></script>

<script type="text/javascript">
function submitContents(elClickedObj) {
	oEditors.getById["reviewContent"].exec("UPDATE_CONTENTS_FIELD", []);
	
	try {
		elClickedObj.form.submit();
	} catch(e) {}
}

$(document).ready(function() {
	$("#btnWrite").click(function() {
		submitContents($("#btnWrite"));
		
		var limit = uncomma($('input[name=itemPrice]').val()); //건들지마
		var price = parseInt(limit); //건들지마
		var result = confirm("게시글을 수정하시겠습니까?");
		
		if (result == true) {
			$('input[name=itemPrice]').val(price);
			$("form").submit();
		} else {
			
			$("#reviewContent").focus();
		}
		
	})
	
	$("#cancel").click(function() {
		history.go(-1);
	})
})
</script>

<div class="wrap">
<div class="container">

<h1>후기 글쓰기 수정페이지</h1>
<hr>

<form action="/review/update" method="post" enctype="multipart/form-data">
<input type="hidden" name="reviewNo" value="${review.REVIEW_NO }">

<div class="form-group">
	<label for="userNick">작성자</label>
	<input type="text" id="userNick" value="${userNick }" class="form-control" readonly="readonly"/>
	
</div>
<div class="form-group">
	<label for="reviewTitle">제목</label>
	<input type="text" id="reviewTitle" value="${review.REVIEW_TITLE }" name="reviewTitle" class="form-control"/>
</div>


<div class="form-group">
	<label for="itemBrand">브랜드</label>
	<input type="text" id="itemBrand" value="${item.itemBrand }" name="itemBrand" class="form-control" readonly="readonly"/>
</div>
<div class="form-group">
	<label for="itemName">상품명</label>
	<input type="text" id="itemName" value="${item.itemName }" name="itemName" class="form-control" readonly="readonly"/>
</div>
<div class="form-group">
	<label for="itemPrice">가격</label>
<%-- 	<input type="text" id="itemPrice" value="${item.itemPrice }" name="itemPrice" class="form-control" readonly="readonly"/> --%>
	<input type="text" id="itemPrice" name="itemPrice" class="form-control" value="<fmt:formatNumber type="number" maxFractionDigits="3"
									value="${item.itemPrice }"/>" readonly="readonly"/>
</div>


<div id="fileBox">	
<div id="originFile">
	<a href="/review/download?fileNo=${file.fileNo }">${file.fileStored }</a>
	<span id="delFile">X</span>
</div>
<br>
	
<div id="newFile">
	<label for="file">새로운 첨부파일</label>
	<input type="file" name="file" id="file" /><br>
	<small>** 새로운 파일을 첨부하면 기존파일이 삭제됩니다</small>
</div>
</div>


<div class="form-group">
	<label for="reviewContent">본문</label>
	<textarea rows="10" style="width: 100%;" id="reviewContent" name="reviewContent">${review.REVIEW_CONTENT }</textarea>
</div>


<div class="text-center">
	<button class="btn btn-primary" id="btnWrite">작성</button>
	<input type="reset" id="cancel" class="btn btn-danger" value="취소"/>
</div>
</form>


<script type="text/javascript">
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "reviewContent",
	sSkinURI: "/resources/se2/SmartEditor2Skin.html",
	fCreator: "createSEditor2"
});


//---인풋창 3자리마다콤마찍기---
var $input = $(".commaInput [type='text']");
//입력 값 알아내기
$input.on('keyup', function() {
  var _this = this;
  numberFormat(_this)
});
//콤마 찍기
function comma(str) {
  str = String(str);
  return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
  
}
//---인풋창 3자리마다콤마찍기end---

//--------- 콤마 풀기
function uncomma(str) {
  str = String(str);
  return str.replace(/[^\d]+/g, '');
}
function numberFormat(obj) {
  obj.value = comma(uncomma(obj.value));
}
//--------- 콤마 풀기end
</script>

</div><!-- .container -->

<%--footer--%>
<c:import url="/WEB-INF/views/layout/footer.jsp" />

</div><!-- .wrap end -->
