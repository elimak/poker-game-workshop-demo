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
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IEntity;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.interfaces.EGameAction;
import com.elimak.awe6demo.interfaces.EGameState;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.interfaces.msg.EMsgGameUpdate;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.managers.Session;
import com.elimak.awe6demo.models.CardsDealerModel;
import com.elimak.awe6demo.models.CashFlowModel;
import com.elimak.awe6demo.views.gui.YellowLabelButton;

/**
 * This entity holds the visual and the logic for the 5 buttons at the bottom of the game
 * Double / Collect / Bet 1 / Bet Max / Deal & Draw
 * and the status of the cash
 */

class GameBottomMenu extends PositionableEntity
{
	private var _background 	: PositionableEntity;
	private var _assetManager	: AssetManager;

	private var _controller		: IController;
	
	private var _cashAmount		: Text;
	
	private var _state 					: EGameState;
	public var state(null, set_state)	: EGameState;
	
	private var _dealButton: YellowLabelButton;
	private var _drawButton: YellowLabelButton;
	
	public function new( p_kernel: IKernel) 
	{
		var l_session : Session = cast p_kernel.session;
		_assetManager = cast( p_kernel.assets, AssetManager );
		_controller = l_session.controller;
		
		super(p_kernel, new View(p_kernel, new Context()));
	}
	
//***********************************//
// PRIVATE METHODS
//***********************************//

	override private function _init():Void 
	{
		super._init();
		
		// add subscriptions
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.WINNING_DEAL(), handleRoundResult, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.LOST_DEAL, handleRoundResult, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.WINNING_DOUBLE, handleRoundResult, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.CASH_UPDATE, handleCashUpdate, null, CashFlowModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.DOUBLE_CARDS_UPDATE(), handleCashUpdate, null, CashFlowModel );
	}
	
	private function handleCashUpdate( msg: EMsgGameUpdate, from: IEntity ) : Bool 
	{
		_cashAmount.text = "$" + _controller.getCash();
		return false;
	}

// update the possible round states
	private function handleRoundResult( msg: EMsgGameUpdate, from: IEntity ) : Bool 
	{
		var msgParam : Array<Dynamic> = Type.enumParameters(msg);
		var msgConst : String = Type.enumConstructor(msg);
		
		switch( msgConst ) {
			case Type.enumConstructor(EMsgGameUpdate.WINNING_DEAL()): state = EGameState.COLLECT_DOUBLE;
			case Type.enumConstructor(EMsgGameUpdate.WINNING_DOUBLE): state = EGameState.COLLECT_DOUBLE;
			case Type.enumConstructor(EMsgGameUpdate.LOST_DEAL): state = EGameState.DEAL;
			case Type.enumConstructor(EMsgGameUpdate.DOUBLE_CARDS_UPDATE()): state = EGameState.COLLECT_DOUBLE;
			default:
		}
		return false;
	}	
	
// set the possible round states and call the controller to update the model
	private function onMenuClick ( p_id: String)
	{
		switch( p_id )
		{
			case "deal"	: 
				_controller.onGameAction( EGameAction.DEAL );
				state = EGameState.DRAW;
			case "collect": 
				_controller.onGameAction( EGameAction.COLLECT );
				state = EGameState.DEAL;
			case "bet1"	: 
				_controller.onGameAction( EGameAction.BET_1 );
			case "betMax": 
				_controller.onGameAction( EGameAction.BET_MAX );
				state = EGameState.DRAW;
			case "draw"	: 
				_controller.onGameAction( EGameAction.DRAW );
				// to know if the draw won, we need to get feedback from the model.
				// this is done by listening to the messenger.
			case "double": 
				_controller.onGameAction( EGameAction.DOUBLE );
				state = EGameState.DISABLE_ALL;
		}
	}

// update the states of the botton buttons according to the game's state.
	private function set_state(value:EGameState):EGameState 
	{
		// toggle Draw / Deal
		if ( value == EGameState.DRAW)
		{
			removeEntity(_dealButton, true);
			addEntity(_drawButton, true);
		}
		else
		{
			removeEntity(_drawButton, true);
			addEntity(_dealButton, true);
		}
		_dealButton.enabled = _drawButton.enabled = (value != EGameState.DISABLE_ALL && value != EGameState.COLLECT_DOUBLE) ;

		cast (getEntityById("betMax"), YellowLabelButton).enabled 	= ( value == EGameState.DEAL );
		cast (getEntityById("bet1"), YellowLabelButton).enabled		= ( value == EGameState.DEAL );
		
		cast (getEntityById("collect"), YellowLabelButton).enabled	= ( value == EGameState.COLLECT_DOUBLE );
		cast (getEntityById("double"), YellowLabelButton).enabled	= ( value == EGameState.COLLECT_DOUBLE );

		return _state = value;
	}
	
//***********************************//
// PUBLIC METHODS
//***********************************//

	public function createComponents() 
	{
		_background = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.GAME_BOTTOM_BAR));
		addEntity( _background, null, true, 1);		
		_background.setPosition(0, 0);

		var l_posX = 305;
		var l_offset = 115;
		var l_posY = 32;
		var buttonsId = ["double","collect","bet1","betMax","deal", "draw" ];
		var l_bt : YellowLabelButton;
		
		for (i in 0...buttonsId.length) 
		{
			var l_btID = buttonsId[i];
			var l_label = _kernel.getConfig("gui.game." + l_btID);
			
			l_bt = new YellowLabelButton (_kernel, new View(_kernel, new Context()), callback( onMenuClick, l_btID), l_label, l_btID);
			addEntity(l_bt, null, true, i + 10);

			l_bt.setPosition(l_posX + l_offset * i, l_posY);
			
			// store button "Deal" and "Draw" as member to toggle them more easily and avoid their disposal when they are removed from the view.
			if ( l_btID == "deal") {
				_dealButton = l_bt;
			}
			// add "draw" on the same position than "deal" as those 2 toggle.
			if ( l_btID == "draw") {
				_drawButton = l_bt;
				_drawButton.setPosition(l_posX + l_offset * (i - 1), l_posY);
			}
		}
		
		var l_text = "$" + _controller.getCash();
		_cashAmount = new Text(_kernel, 300, 120, l_text ,_kernel.factory.createTextStyle( ETextStyle.OVERSIZED ), true);
		addEntity(_cashAmount, null, true, 20);
		_cashAmount.setPosition(160, 20);
		
		state = EGameState.DEAL;
	}
}
