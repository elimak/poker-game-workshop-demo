/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.interfaces.msg;
import com.elimak.awe6demo.interfaces.EGameWinningDeals;
import com.elimak.awe6demo.models.vo.CardPositionVO;

enum EMsgGameUpdate 
{
	BET_UPDATE(?currentBet: Int);
	
	DEAL_CARDS_UPDATE(?setOfCards: Array<CardPositionVO>);
	DRAW_CARDS_UPDATE(?setOfCards: Array<CardPositionVO>);
	DOUBLE_CARDS_UPDATE(?setOfCards: Array<CardPositionVO>);
	
	WINNING_DEAL(?combination: EGameWinningDeals);
	LOST_DEAL;
	WINNING_DOUBLE;
	COLLECT;
	CASH_UPDATE;
}