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
import awe6.interfaces.IEntity;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.interfaces.msg.EMsgGameUpdate;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.managers.Session;
import com.elimak.awe6demo.models.CardsDealerModel;
import com.elimak.awe6demo.models.vo.CardPositionVO;
import com.elimak.awe6demo.views.entities.PlayingCard;

/**
 * This Entities holds the visual and the logic for the 5 playing cards 
 * For both mode: Playing & Doubling
 */

class GameCards extends PositionableEntity
{
	private var _controller		: IController;
	private var _assetManager	: AssetManager;
	
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
	
	override private function _init()
	{
		super._init();
		
		// add subscriptions
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.DEAL_CARDS_UPDATE(), handleGameAction, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.DRAW_CARDS_UPDATE(), handleGameAction, null, CardsDealerModel );
		_kernel.messenger.addSubscriber( this, EMsgGameUpdate.DOUBLE_CARDS_UPDATE(), handleGameAction, null, CardsDealerModel );
	}
	
// there are 3 main action; 
// - start over with 5 cards
// - held cards + new cards
// - show figure of first card only and try picking a stronger card with the 4 others.
	private function handleGameAction( msg: EMsgGameUpdate, from: IEntity ) : Bool 
	{
		var msgParam : Array<Dynamic> = Type.enumParameters(msg);
		var msgConst : String = Type.enumConstructor(msg);
		
		switch( msgConst ) {
			case Type.enumConstructor(EMsgGameUpdate.DEAL_CARDS_UPDATE()):
				var l_param : Array<CardPositionVO> = cast msgParam[0];
				updateAllCards(l_param);
				
			case Type.enumConstructor(EMsgGameUpdate.DRAW_CARDS_UPDATE()):
				var l_param : Array<CardPositionVO> = cast msgParam[0];
				updateCardsButHeld(l_param);
				
			case Type.enumConstructor(EMsgGameUpdate.DOUBLE_CARDS_UPDATE()):
				var l_param : Array<CardPositionVO> = cast msgParam[0];
				showDoubleChallenge(l_param);
				
			default:
		}
		return true;
	}	
	
// 1 - start over with 5 cards
	private function updateAllCards( p_setOfCards: Array<CardPositionVO> ) 
	{
		var l_entities: Array<IEntity> = getEntities();
		
		for (i in 0...l_entities.length) {
			l_entities[i].dispose();
		}
		
		for (i in 0...p_setOfCards.length) 
		{
			var l_playingCard : PlayingCard = new PlayingCard(_kernel, p_setOfCards[i]);
			addEntity(l_playingCard, null, true, 1);
			l_playingCard.showFigure(true);
			l_playingCard.setPosition((PlayingCard.WIDTH +8) * i, 0);
		}
	}
	
// 2 - held cards + new cards
	private function updateCardsButHeld( p_setOfCards: Array<CardPositionVO> ) 
	{
		var l_doNotUpdateCards : Array<Int> = new Array<Int>();
		var l_entities: Array<IEntity> = getEntities();
		
		for (i in 0...l_entities.length) {
			if( !cast(l_entities[i], PlayingCard).isHeld )
				l_entities[i].dispose();
			else
				l_doNotUpdateCards.push(i);
		}

		var l_count : Int = 0;
		for (i in 0...5) 
		{
			if (l_doNotUpdateCards.length == 0 || i != l_doNotUpdateCards[0])
			{
				var l_playingCard : PlayingCard = new PlayingCard(_kernel, p_setOfCards[l_count]);
				addEntity(l_playingCard, null, true, 1);
				l_playingCard.setPosition((PlayingCard.WIDTH + 8) * i, 0);
				l_playingCard.showFigure(true);
				l_count++;
			}
			else {
				l_doNotUpdateCards.shift();
			}
		}
	}
	
// 3 - show figure of first card only and try picking a stronger card with the 4 others.
	private function showDoubleChallenge( p_setOfCards: Array<CardPositionVO> ) 
	{
		var l_entities: Array<IEntity> = getEntities();
		
		for (i in 0...l_entities.length) {
			l_entities[i].dispose();
		}
		
		for (i in 0...p_setOfCards.length) {
			
			var l_playingCard : PlayingCard = new PlayingCard(_kernel, p_setOfCards[i]);
			addEntity(l_playingCard, null, true, 1);
			if ( i == 0 )
				l_playingCard.showFigure(true);
			else
				l_playingCard.showFigure(false);
			l_playingCard.setPosition((PlayingCard.WIDTH +8) * i, 0);
		}
	}
	
//***********************************//
// PUBLIC METHODS
//***********************************//
	
	public function createComponents () 
	{
		// show the back of the card to start
		for (i in 0...5) 
		{
			var l_playingCard : PlayingCard = new PlayingCard(_kernel);
			addEntity(l_playingCard, null, true, 1);
			l_playingCard.setPosition((PlayingCard.WIDTH + 8) * i, 0);
			l_playingCard.showFigure(false);
		}
	}
}