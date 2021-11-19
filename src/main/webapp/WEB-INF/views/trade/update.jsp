<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:import url="/WEB-INF/views/layout/head.jsp" />
<c:import url="/WEB-INF/views/layout/header.jsp" />
<!-- header end -->

<!-- 개별 스타일 및 스크립트 영역 -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/tradeWrite.css" />
<!-- 스마트 에디터 2 라이브러리 로드 -->
<script type="text/javascript" src="/resources/se2/js/service/HuskyEZCreator.js"></script>

<script type="text/javascript">


/* -------------------------------------------------------- */

$(function () {
	
    $(document).on("click", "#confirm", function () {
        action_popup.confirm("되돌릴 수 없습니다. 정말로 삭제 하시겠습니까?", function (res) {
            if (res) {
            	
        		$.ajax({
        			type: "post"
        			, url: "/trade/update/deletefile"
        			, dataType: "json"
        			, data: {
        				fileStored: "${tradeDetail.FILE_STORED }"
        			}
        			, success: function(data){
        				if(data.success) {
        					$("#fileArea").html("기존에 있던 파일을 삭제했습니다!");
        				} else {
        					action_popup.alert("삭제 실패!");
        				}
        			}
        			, error: function() {
        				console.log("error");
        			}
        		});
            	
                action_popup.alert("삭제가 완료되었습니다.");
            }
        })
    });

    $(document).on("click", "#alert", function () {
        action_popup.alert("경고창");
    });

    $(".modal_close").on("click", function () {
        action_popup.close(this);
    });
    
});

var action_popup = {
    timer: 300,
    confirm: function (txt, callback) {
        if (txt == null || txt.trim() == "") {
            console.warn("confirm message is empty.");
            return;
        } else if (callback == null || typeof callback != 'function') {
            console.warn("callback is null or not function.");
            return;
        } else {
            $(".type-confirm .btn_ok").on("click", function () {
                $(this).unbind("click");
                callback(true);
                action_popup.close(this);
            });
            this.open("type-confirm", txt);
        }
    },

    alert: function (txt) {
        if (txt == null || txt.trim() == "") {
            console.warn("confirm message is empty.");
            return;
        } else {
            this.open("type-alert", txt);
        }
    },

    open: function (type, txt) {
        var popup = $("." + type);
        popup.find(".menu_msg").text(txt);
        $("body").append("<div class='dimLayer'></div>");
        $(".dimLayer").css('height', $(document).height()).attr("target", type);
        popup.fadeIn(this.timer);
    },

    close: function (target) {
        var modal = $(target).closest(".modal-section");
        var dimLayer;
        if (modal.hasClass("type-confirm")) {
            dimLayer = $(".dimLayer[target=type-confirm]");
            $(".type-confirm .btn_ok").unbind("click");
        } else if (modal.hasClass("type-alert")) {
            dimLayer = $(".dimLayer[target=type-alert]")
        } else {
            console.warn("close unknown target.")
            return;
        }
        modal.fadeOut(this.timer);
        setTimeout(function () {
            dimLayer != null ? dimLayer.remove() : "";
        }, this.timer);
    }
}


/* -------------------------------------------------------- */

$(document).ready(function() {
	$("input:file[name='file']").change(function () {
	    var str = $(this).val();
	    var fileName = str.split('\\').pop().toLowerCase() + ' 로 업로드하면 기존 파일이 삭제됩니다.';
	    
	    if(str == '') {
		    $('#fileName').html('<span id="fileName">${tradeDetail.FILE_STORED } <a id="confirm">X</a></span>');
	    } else {
		    $('#fileName').html(fileName);
	    }
	});
});


function submitContents(elClickedObj) {
	oEditors.getById["tradeContent"].exec("UPDATE_CONTENTS_FIELD", []);
	
	try {
		elClickedObj.form.submit();
	} catch(e) {}
}

$(document).ready(function() {
	
	$("#btnUpdate").click(function() {
		submitContents($("#btnUpdate"));
		
		$('#fileArea').before('<input type="hidden" name="tradeNo" value="'+ ${param.tradeNo } +'" />');
		
		$("form").submit();
	})
	
	$("#btnCancel").click(function() {
		history.go(-1);
	})
})

</script>
<!-- 개별 영역 끝 -->

<div class="wrap">
<div class="container">

	
	<div id="writeMain">
	
		<h1>거래 게시글 수정</h1>
		<hr style="margin-top: 20px;">
	
		<form id="updateForm" action="/trade/update" method="post" enctype="multipart/form-data">
		
			<input type="text" style="width: 60%;" name="tradeTitle" value="${tradeDetail.TRADE_TITLE }" placeholder="제목을 입력해주세요"/>
			<select name="tradeCategory">
				<option value="0">팝니다</option>
				<option value="1">삽니다</option>
			</select>
			<p style="text-align: left;">** 카테고리에 알맞은 주제에 대한 글을 올려주세요.</p>
		
			<div class="form-group">
				<label for="tradeContent"></label>
				<textarea rows="10" style="width: 100%; height: 400px;" id="tradeContent" name="tradeContent">
				${tradeDetail.TRADE_CONTENT }
				</textarea>
			</div>
			
			<label>기존에 업로드한 파일</label>
			
			<div id="fileArea" class="panel panel-default text-center">
				<c:if test="${empty tradeDetail.FILE_STORED }">
					<span id="fileName">기존에 업로드한 파일이 없습니다!</span>
				</c:if>
				<c:if test="${!empty tradeDetail.FILE_STORED }">
					<span id="fileName">${tradeDetail.FILE_STORED } <a id="confirm">X</a></span>
				</c:if>
			</div>
			
			<div class="form-group" style="float: left;">
				<label for="file">첨부파일</label>
				<input type="file" id="file" name="file" />
			</div>
			
			<div class="text-right">
				<button type="button" id="btnCancel" class="btn btn-default">취소</button>
				<button type="button" id="btnUpdate" class="btn btn-info">수정</button>
			</div>
		
		</form>
	</div>

</div><!-- .container end -->

<!-- footer start -->
<c:import url="/WEB-INF/views/layout/footer.jsp" />


	<!-- confirm 모달을 쓸 페이지에 추가 start-->
	<section class="modal modal-section type-confirm">
	    <div class="enroll_box">
	        <p class="menu_msg"></p>
	    </div>
	    <div class="enroll_btn">
	        <button class="btn pink_btn btn_ok">확인</button>
	        <button class="btn gray_btn modal_close">취소</button>
	    </div>
	</section>
	<!-- confirm 모달을 쓸 페이지에 추가 end-->
	
	<!-- alert 모달을 쓸 페이지에 추가 start-->
	<section class="modal modal-section type-alert">
	    <div class="enroll_box">
	        <p class="menu_msg"></p>
	    </div>
	    <div class="enroll_btn">
	        <button class="btn pink_btn modal_close">확인</button>
	    </div>
	</section>
	<!-- alert 모달을 쓸 페이지에 추가 end-->


</div><!-- .wrap end -->


<script type="text/javascript">
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "tradeContent",
	sSkinURI: "/resources/se2/SmartEditor2Skin.html",
	fCreator: "createSEditor2"
});
</script>