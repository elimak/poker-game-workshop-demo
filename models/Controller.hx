/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.models;
import awe6.interfaces.EAudioChannel;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.EGameAction;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.managers.Session;
import com.elimak.awe6demo.models.vo.CardPositionVO;

/**
 * The controller holds a reference to all our Models and to our Session.
 * It behaves as a bridge between the views and the models and can hold logic that requieres data from 
 * several models or that requires a call to a service.
 * 
 * It can be setup in order to mock some data or some service's call back.
 */

class Controller implements IController
{
	private var _cardsDealer	: CardsDealerModel;
	private var _playerModel	: PlayerModel;
	private var _cashFlowModel	: CashFlowModel;
	private var _session		: Session;
	private var _kernel			: IKernel;
	
	public function new( p_kernel : IKernel, p_session: Session) 
	{
		_session	= p_session;
		_kernel		= p_kernel;
		
		_cardsDealer 	= new CardsDealerModel(p_kernel);
		_cashFlowModel 	= new CashFlowModel(p_kernel, _session);
		_playerModel	= new PlayerModel(p_kernel);
	}
	
	public function holdCard( p_card: CardPositionVO )
	{
		_cardsDealer.holdCard(p_card);
	}
	
	public function releaseCard( p_card: CardPositionVO )
	{
		_cardsDealer.releaseCard(p_card);
	}
	
	public function selectCardWhenDouble (p_card: CardPositionVO)
	{
		_cardsDealer.selectCardOnDouble(p_card);
	}
	
	public function onGameAction ( p_gameAction: EGameAction )
	{
		switch(p_gameAction) 
		{
			case EGameAction.BET_MAX:
				_cashFlowModel.betMax();
				onGameAction(EGameAction.DEAL);
				
			case EGameAction.BET_1:
				_cashFlowModel.betAdd1();
				_kernel.audio.start( _kernel.getConfig( "settings.audio.click" ), EAudioChannel.EFFECTS);
				
			case EGameAction.DEAL:
				// reset the held cards
				_cardsDealer.newDeal();
				_cashFlowModel.placeBet();
				_kernel.audio.start( _kernel.getConfig( "settings.audio.click" ), EAudioChannel.EFFECTS);
				
			case EGameAction.DOUBLE:
				_cardsDealer.double();

			case EGameAction.DRAW:
				_cardsDealer.draw( _cashFlowModel.currentBet );

			case EGameAction.COLLECT:
				_cashFlowModel.addCollectedCash ( _cardsDealer.cashInDouble );
				_kernel.audio.start( _kernel.getConfig( "settings.audio.collect" ), EAudioChannel.EFFECTS);
		}
	}
	
	public function updateCash( p_value: Int ) 
	{
		_cashFlowModel.currentCash = p_value;
	}
	
	public function updateUserName( p_value: String ) 
	{
		_playerModel.name = p_value;
	}
	
	public function getCash () : Int
	{
		return _cashFlowModel.currentCash;
	}
	
	public function getUsername() : String
	{
		return _playerModel.name;
	}
}