package com.khbill.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.khbill.dto.Ask;
import com.khbill.dto.Item;
import com.khbill.dto.Review;
import com.khbill.dto.Trade;
import com.khbill.dto.User;
import com.khbill.service.face.AskService;
import com.khbill.service.face.ItemService;
import com.khbill.service.face.MemberService;
import com.khbill.service.face.MypageService;
import com.khbill.util.Paging;

@Controller
public class MypageController {
	
	private static final Logger logger = LoggerFactory.getLogger(MypageController.class);
	
	@Autowired AskService askService;
	@Autowired ItemService itemService;
	@Autowired MemberService memberService;
	@Autowired MypageService mypageService;
	
	@RequestMapping(value="/mypage/item/list")
	public void itemList(HttpSession session, Model model, Paging paramData) {
		logger.info("/mypage/item/list [GET]");
		
		int userNo = (int)session.getAttribute("userNo");
		logger.info("세션에 저장된 유저 번호 : {}", userNo);
		
		Paging paging = itemService.getPaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<HashMap<String, Object>> resultMapList = itemService.getItemList(map);
		
		logger.info("resultMapList 정보 : {}", resultMapList);
		
		model.addAttribute("list", resultMapList);
		model.addAttribute("paging", paging);		

	}
	
	@RequestMapping(value="/mypage/item/status")
	public String itemStatus(Item item) {
		logger.info("/mypage/item/status [GET]");
		
		int askNo = itemService.getAskNoByItemNo(item);
		
		//아이템 결제 상태를 변경하기
		itemService.setItemStatus(askNo);
		
		return "redirect:/mypage/item/list";
		
	}
	
	@RequestMapping(value="/mypage/info")
	public void userInfo(User user, HttpSession session, Model model) {
		logger.info("/mypage/info [GET]");
		
		int userNo = (int)session.getAttribute("userNo");
		
		user = memberService.getUserByUserNo(userNo);
		
		User userInfo = memberService.getUserInfo(user);
		
		session.setAttribute("userNick", userInfo.getUserNick());
		
		model.addAttribute("user", user);
		
	}
	
	@RequestMapping(value="/mypage/update", method=RequestMethod.GET)
	public void userUpdate(User user, HttpSession session, Model model) {
		logger.info("/mypage/update [GET])");
		
		//세션에 있는 유저번호 가져오기
		int userNo = (int)session.getAttribute("userNo");
		
		//유저 번호로 유저 정보를 찾기
		user = memberService.getUserByUserNo(userNo);
		
		//조회한 유저 정보 전달
		
		if(session.getAttribute("login") != null) {
			model.addAttribute("user", user);			
		}
		
	}

	@RequestMapping(value="/mypage/update", method=RequestMethod.POST)
	public String userUpdateProc(User user, HttpSession session) {
		logger.info("/mypage/update [GET])");

		memberService.setUserUpdate(user);
		
		User userInfo = memberService.getUserInfo(user);
		
		session.setAttribute("login", true);
		session.setAttribute("userNick", userInfo.getUserNick());
		session.setAttribute("userNo", userInfo.getUserNo());
		
		return "redirect:/mypage/info";
	}
	
	@RequestMapping(value="/mypage/delete", method=RequestMethod.POST)
	public String userDelete(User user, HttpSession session) {
		logger.info("/mypage/delete [POST])");
		
		int userNo = (int)session.getAttribute("userNo");
		logger.info("userNo 정보 : {}", userNo);
		
		memberService.setUserDelete(userNo);
		
		session.invalidate();
		
		return "redirect:/main";

	}

	@RequestMapping(value="/mypage/ask/list", method=RequestMethod.GET)
	public void myAskList(Paging paramData, HttpSession session, Model model) {
		logger.info("/mypage/ask/list [GET])");
		
		int userNo = (int)session.getAttribute("userNo");
		Paging paging = mypageService.getMyAskPaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<Ask> askList = mypageService.getMyAskList(map);
		
		logger.info("작성한 질문글 목록 : {} ", askList);

		model.addAttribute("ask", askList);
		model.addAttribute("paging", paging);
		
	}
	
	@RequestMapping(value="/mypage/ask/delete", method=RequestMethod.GET)
	public String myAskDelete(int[] askNo) {
		logger.info("/mypage/ask/delete [GET]");

		for(int i=0; i<askNo.length; i++) {
			askService.setAskComDelete(askNo[i]);
			askService.setAskDelete(askNo[i]);
		}	

		return "redirect:/mypage/ask/list";
	}
	
	@RequestMapping(value="/mypage/ask/scrap/list", method=RequestMethod.GET)
	public void myAskScrapList(Paging paramData, HttpSession session, Model model) {
		logger.info("/mypage/ask/scrap/list [GET]");
	
		int userNo = (int)session.getAttribute("userNo");
		Paging paging = mypageService.getMyAskScrapPaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<HashMap<String, Object>> askScrapList = mypageService.getMyAskScrapList(map);
		
		logger.info("스크랩한 질문글 목록 : {} ", askScrapList);

		model.addAttribute("ask", askScrapList);
		model.addAttribute("paging", paging);
		
	}
	
	@RequestMapping(value="/mypage/review/list", method=RequestMethod.GET)
	public void myReviewList(Paging paramData, HttpSession session, Model model) {
		logger.info("/mypage/review/list [GET])");
		
		int userNo = (int)session.getAttribute("userNo");
		Paging paging = mypageService.getMyReviewPaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<Review> reviewList = mypageService.getMyReviewList(map);
		
		logger.info("작성한 후기글 목록 : {} ", reviewList);
		
		model.addAttribute("review", reviewList);
		model.addAttribute("paging", paging);
		
	}
	
	@RequestMapping(value="/mypage/review/scrap/list", method=RequestMethod.GET)
	public void myreviewScrapList(Paging paramData, HttpSession session, Model model) {
		logger.info("/mypage/review/scrap/list [GET]");
	
		int userNo = (int)session.getAttribute("userNo");
		Paging paging = mypageService.getMyReviewScrapPaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<HashMap<String, Object>> reviewScrapList = mypageService.getMyReviewScrapList(map);
		
		logger.info("스크랩한 후기글 목록 : {} ", reviewScrapList);

		model.addAttribute("review", reviewScrapList);
		model.addAttribute("paging", paging);
		
	}
	
	@RequestMapping(value="/mypage/trade/list", method=RequestMethod.GET)
	public void myTradeList(Paging paramData, HttpSession session, Model model) {
		logger.info("/mypage/trade/list [GET])");
		
		int userNo = (int)session.getAttribute("userNo");
		Paging paging = mypageService.getMyTradePaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<Trade> tradeList = mypageService.getMyTradeList(map);
		
		logger.info("작성한 거래글 목록 : {} ", tradeList);

		model.addAttribute("trade", tradeList);
		model.addAttribute("paging", paging);
		
	}
	
	@RequestMapping(value="/mypage/trade/scrap/list", method=RequestMethod.GET)
	public void mytradeScrapList(Paging paramData, HttpSession session, Model model) {
		logger.info("/mypage/trade/scrap/list [GET]");
	
		int userNo = (int)session.getAttribute("userNo");
		Paging paging = mypageService.getMyTradeScrapPaging(paramData, userNo);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("paging", paging);
		
		List<HashMap<String, Object>> tradeScrapList = mypageService.getMyTradeScrapList(map);
		
		logger.info("스크랩한 거래글 목록 : {} ", tradeScrapList);

		model.addAttribute("trade", tradeScrapList);
		model.addAttribute("paging", paging);
		
	}
	
	
	
	
}
