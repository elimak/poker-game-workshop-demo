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
import awe6.core.BasicButton;
import awe6.core.Context;
import awe6.core.View;
import awe6.interfaces.EAgenda;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IEntity;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.interfaces.msg.EMsgGameUpdate;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.managers.Session;
import com.elimak.awe6demo.models.CardsDealerModel;
import com.elimak.awe6demo.models.vo.CardPositionVO;
import com.elimak.awe6demo.views.entities.PositionableEntity;
import com.elimak.awe6demo.views.gui.SmartLabel;

/**
 * This class is instancited for each playing card.
 * 
 * // CREATION
 * The playing card is made of 
 * 		2 BasicButtons (reversed card and figure)
 * 		1 SmartLabel (with the "Held" text)
 * 
 * // DISPOSAL
 * Because the game creates and removes card for each draw,
 * it is important to make sure that this entity is disposed properly
 * 
 */

class PlayingCard extends PositionableEntity
{	
	private var _cardFigure		: BasicButton;
	private var _cardBack		: BasicButton;
	
	private var _held			: SmartLabel;
	
	private var _assetManager 	: AssetManager;
	private var _controller		: IController;
	
	private var _cardVO 		: CardPositionVO;
	
	private var _isHeld	 			: Bool;
	private var _roundIsFinished	: Bool;
	private var _doubleMode			: Bool;
	
	public var isHeld(get_isHeld, null): Bool;
	
	public static inline var WIDTH	: Int = 167;
	public static inline var HEIGHT	: Int = 243;
	
	public function new( p_kernel: IKernel, ?p_card: CardPositionVO ) 
	{
		var l_session : Session = cast p_kernel.session;
		_assetManager = cast( p_kernel.assets, AssetManager );
		_controller = l_session.controller;
		
		_cardVO = p_card;
		super(p_kernel, new View(p_kernel, new Context()));
	}
	
//***********************************//
// PRIVATE METHODS
//***********************************//

	override private function _init()
	{
		super._init();
		
		// if no data was passed in the constructor (p_card), the card shows the back face on the figure ( this is the case when the game starts)
		_roundIsFinished = true;
		var p_back = _assetManager.getPlayingCard();
		var p_figure = (_cardVO != null)? _assetManager.getPlayingCard(_cardVO.symbol, _cardVO.card) : p_back;
		
		// Adding the back and the figure on their own agenda as they toggle
		_cardFigure = new BasicButton ( _kernel, p_figure, p_figure, WIDTH, HEIGHT, 0, 0, null, onHold );
		addEntity(_cardFigure, EAgenda.SUB_TYPE(_HelperEState.FIGURE), true, 1);
		
		_cardBack = new BasicButton ( _kernel, p_back, p_back, WIDTH, HEIGHT, 0, 0, null, onDouble );
		addEntity(_cardBack, EAgenda.SUB_TYPE(_HelperEState.BACK), true, 1);
		
		// create the smart label, add it and hide it
		var l_style = _kernel.factory.createTextStyle(ETextStyle.SUBHEAD);
		_held = new SmartLabel(_kernel, 167,45, _assetManager.getViewAsset(EAsset.HELD_BACKGROUND), _kernel.getConfig("gui.game.held"),l_style, 10, 8) ;
		_held.view.isVisible = _isHeld;
		addEntity(_held, true, 2);
		_held.setPosition(0, 135);
		
		// init variable and agenda
		setAgenda(EAgenda.SUB_TYPE(_HelperEState.BACK));
		_doubleMode = _roundIsFinished = false;
		
		// add the message subscriptions
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.WINNING_DEAL(), hideHeldLabel, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.LOST_DEAL, hideHeldLabel, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.DOUBLE_CARDS_UPDATE(), handleDoubleMode, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.WINNING_DOUBLE, handleDoubleMode, null, CardsDealerModel );
	}
	
// called when receiving messages from the models
	private function handleDoubleMode( msg: EMsgGameUpdate, from: IEntity ) : Bool
	{
		var msgParam : Array<Dynamic> = Type.enumParameters(msg);
		var msgConst : String = Type.enumConstructor(msg);
		
		switch( msgConst ) {
			// When the player doubles
			case Type.enumConstructor(EMsgGameUpdate.DOUBLE_CARDS_UPDATE()):
				_doubleMode = true;
				_roundIsFinished = false;
			// when the double was won
			case Type.enumConstructor(EMsgGameUpdate.WINNING_DOUBLE):
				_doubleMode = false;
				_roundIsFinished = true;
		}
		return false;
	}
	
// called when the deal is won or lost
	private function hideHeldLabel( msg: EMsgGameUpdate, from: IEntity ) : Bool 
	{
		_roundIsFinished = true;
		if ( _doubleMode ) _doubleMode = false;
		_held.view.isVisible = false;
		return false;
	}	
	
// called when clicking on a card in double mode
	private function onDouble() 
	{
		if ( !_doubleMode ) {
			return;
		}
		else {
			showFigure(true );
			_controller.selectCardWhenDouble( _cardVO);
		}
	}
	
// called when clicking on a card in play mode
	private function onHold() 
	{
		if ( !_isHeld && !_roundIsFinished ) {
			_isHeld = true;
			_controller.holdCard( _cardVO );
		}
		else {
			_isHeld = false;
			_controller.releaseCard( _cardVO );
		}
		_held.view.isVisible = _isHeld;
	} 	
	
/*
 * Disposing (or Pooling) is important when you create a lot of the same object.
 * remove references, remove subscriptions and dispose the children.
 */
	override private function _disposer():Void 
	{
		_controller.releaseCard( _cardVO );
		// remove subscription 
		_kernel.messenger.removeSubscribers( this, EMsgGameUpdate.WINNING_DEAL(), hideHeldLabel, null, CardsDealerModel );
		_kernel.messenger.removeSubscribers( this, EMsgGameUpdate.LOST_DEAL, hideHeldLabel, null, CardsDealerModel );
		_kernel.messenger.removeSubscribers( this, EMsgGameUpdate.DOUBLE_CARDS_UPDATE(), handleDoubleMode, null, CardsDealerModel );
		_kernel.messenger.removeSubscribers( this, EMsgGameUpdate.WINNING_DOUBLE, handleDoubleMode, null, CardsDealerModel );
		// dispose children
		_cardFigure.dispose();
		_cardBack.dispose();
		_held.dispose();
		// nullify manager/data reference
		_assetManager =  null;
		_controller = null;
		_cardVO = null;
	
		super._disposer();
	}
	
	private function get_isHeld():Bool {
		return _isHeld;
	}
	
//***********************************//
// PUBLIC METHODS
//***********************************//

/*
 * The Basic button uses a custom hitarea instead of an eventlistener.
 * Make sure to initialize the position of the button entities when the parent's position changes or when the states change
 */
	override public function setPosition( p_x:Float, p_y:Float ):Void
	{
		x = p_x;
		y = p_y;
		_cardFigure.setPosition(0, 0);
		_cardBack.setPosition(0, 0);	
	}

// update the agenda 
	public function showFigure( p_param : Bool)
	{
		if ( !p_param ) {
			setAgenda(EAgenda.SUB_TYPE(_HelperEState.BACK));
		}
		else {
			setAgenda(EAgenda.SUB_TYPE(_HelperEState.FIGURE));
		}
		setPosition(x, y);
	}
}

private enum _HelperEState
{
	FIGURE;
	BACK;
}