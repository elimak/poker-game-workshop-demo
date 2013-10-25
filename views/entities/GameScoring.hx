/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

 package com.elimak.awe6demo.views.entities;
import awe6.core.Context;
import awe6.core.View;
import awe6.extras.gui.Text;
import awe6.interfaces.ETextAlign;
import awe6.interfaces.IEntity;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.interfaces.EGameWinningDeals;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.interfaces.msg.EMsgGameUpdate;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.managers.Session;
import com.elimak.awe6demo.models.CardsDealerModel;
import com.elimak.awe6demo.models.CashFlowModel;

/**
 * This entity holds the visual and the logic for the top-right grid with the gain and the winning combinations
 */

class GameScoring extends PositionableEntity
{
	private var _grid 			: PositionableEntity;
	private var _winningRow 	: PositionableEntity;
	private var _betColumn 		: PositionableEntity;
	private var _controller		: IController;

	private var _assetManager	: AssetManager;
	
	private static inline var YELLOW 	: Int = 0xeea90b;
	private static inline var WHITE 	: Int = 0xffffff;
	private static inline var BLACK 	: Int = 0x000000;
	
	public function new( p_kernel: IKernel ) 
	{
		var l_session : Session = cast p_kernel.session;
		_assetManager = cast( p_kernel.assets, AssetManager );
		_controller = l_session.controller;
		super(p_kernel, new View(p_kernel, new Context()));
	}
	
//***********************************//
// PRIVATE METHODS
//***********************************//
	
// shows the red label below the winning combination and highlights the text
	private function showRankingSelection( msg: EMsgGameUpdate, from: IEntity ) : Bool
	{
		var msgParam : Array<Dynamic> = Type.enumParameters(msg);
		var l_param : EGameWinningDeals = cast msgParam[0];

		var l_rankHighlighted : Int = 0;
		switch(l_param)
		{
			case EGameWinningDeals.ROYALE_FLUSH 	: l_rankHighlighted = 0;
			case EGameWinningDeals.FOUR_OF_KIND 	: l_rankHighlighted = 1; 
			case EGameWinningDeals.STRAIGHT_FLUSH 	: l_rankHighlighted = 2; 
			case EGameWinningDeals.FLUSH 			: l_rankHighlighted = 3; 
			case EGameWinningDeals.STRAIGHT 		: l_rankHighlighted = 4; 
			case EGameWinningDeals.THREE_OF_KIND 	: l_rankHighlighted = 5; 
			case EGameWinningDeals.TWO_PAIRS 		: l_rankHighlighted = 6; 
			case EGameWinningDeals.JACKS_OR_BETTER 	: l_rankHighlighted = 7; 
			default:
		}
		
		_winningRow.view.isVisible = true;
		_winningRow.setPosition(5, 22 * l_rankHighlighted + 6);
		for (i in 0...8) 
		{
			var l_txtField : Text = cast getEntityById("rank" + i);
			l_txtField.textStyle.color = ( l_rankHighlighted == i ) ? WHITE : YELLOW;
		}
		
		return false;
	}	
	
// hide the red label below the last winning combination 
	private function hideRankingSelection( msg: EMsgGameUpdate, from: IEntity ) : Bool
	{
		_winningRow.view.isVisible = false;
		for (i in 0...8) {
			var l_txtField : Text = cast getEntityById("rank" + i);
			l_txtField.textStyle.color = YELLOW;
		}
		return false;
	}	
	
// update the position of the yellow background that shows the current bet
	private function handleBetUpdate( msg: EMsgGameUpdate, from: IEntity ) : Bool
	{
		var msgParam : Array<Dynamic> = Type.enumParameters(msg);
		var l_bet : Int = cast msgParam[0];
		
		var l_startX = 170;
		var l_columnWidth = 63;
		_betColumn.setPosition( l_startX + l_columnWidth * l_bet, 0);

		for (i in 1...6) {
			for (j in 0...8) {
				var l_txtField : Text = cast getEntityById("colum" + i + "_bet" + j);
				l_txtField.textStyle.color = ( i != (l_bet+1))? YELLOW: BLACK;
			}
		}
		
		return false;
	}
	
// create the textFields for the winning combination
	private function createRanking() 
	{
		for (i in 0...8) 
		{
			var l_label = _kernel.getConfig("gui.game.score" + i + "_title");
			var l_style = _kernel.factory.createTextStyle(SMALLPRINT);
			l_style.color = YELLOW;
			var l_tField = new Text(_kernel, 130, 25, l_label, l_style, false, true);
			l_tField.id = "rank" + i;
			addEntity(l_tField, null, true, 10+i);
			l_tField.setPosition(10, 22 * i+7);
		}
	}	
	
// create the textFields for the gains on the bets
	private function createBetColumn( p_multiplier: Int ) 
	{
		var l_offset 	= 62;
		var l_initPosX	= 74;
		for (i in 0...8) 
		{
			var l_value : Int = cast _kernel.getConfig("gui.game.value" + i);
			l_value *= p_multiplier;
			
			var l_style = _kernel.factory.createTextStyle(SMALLPRINT);
			l_style.color = (p_multiplier == 1)? BLACK: YELLOW;
			l_style.align = ETextAlign.CENTER;
			
			var l_tField = new Text(_kernel, 130, 25, Std.string(l_value), l_style, false, true);
			l_tField.id = "colum"+p_multiplier+"_bet" + i;
			addEntity(l_tField, null, true, 20+(p_multiplier*10)+i);
			l_tField.setPosition(l_initPosX + l_offset*p_multiplier, 22 * i+7);
		}
	}
	
//***********************************//
// PUBLIC METHODS
//***********************************//

// Create the sub components
// and add the message's subscriptions
	public function createComponents() 
	{
		_betColumn = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.BET_BACKGROUND));
		addEntity( _betColumn, null, true, 1);		
		_betColumn.setPosition(170, 0);

		_winningRow = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.WIN_BACKGROUND));
		addEntity( _winningRow, null, true, 2);		
		_winningRow.setPosition(5,5);
		_winningRow.view.isVisible = false;
		
		_grid = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.SCORE_GRID));
		addEntity( _grid, null, true, 3);		
		_grid.setPosition(0, 0);
		
		createRanking();
		
		for (i in 1...6) {
			createBetColumn(i);
		}
		
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.WINNING_DEAL(), showRankingSelection, null, CardsDealerModel );
		
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.LOST_DEAL, hideRankingSelection, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.DEAL_CARDS_UPDATE(), hideRankingSelection, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.COLLECT, hideRankingSelection, null, CashFlowModel );
		
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.BET_UPDATE(), handleBetUpdate, null, CashFlowModel );
	}
}