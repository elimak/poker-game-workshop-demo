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
import awe6.core.Entity;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.msg.EMsgGameUpdate;
import com.elimak.awe6demo.managers.Session;
import haxe.Log;

/**
 * Model to hold the User's cash and his current bet.
 */

class CashFlowModel extends Entity
{
	public var currentBet		: Int;
	public var currentCash		: Int;
	
	private var _session : Session;
	
	public function new( p_kernel: IKernel, p_session: Session ) 
	{
		currentCash = 75;
		currentBet = 1;
		_session = p_session;
		super(p_kernel);
	}
	
	override private function _init()
	{
		super._init();
	}
	
	public function betAdd1()
	{
		currentBet ++;
		if ( currentBet > 5 ) 
			currentBet = 1;

		_kernel.messenger.sendMessage( EMsgGameUpdate.BET_UPDATE(currentBet-1), this, false, false, true);
	}
	
	public function betMax()
	{
		currentBet = 5;
		_kernel.messenger.sendMessage( EMsgGameUpdate.BET_UPDATE(currentBet-1), this, false, false, true);
	}
	
	public function placeBet()
	{
		currentCash -= currentBet;
		_session.save();
		_kernel.messenger.sendMessage( EMsgGameUpdate.CASH_UPDATE, this, false, false, true);
	}
	
	public function addCollectedCash ( p_cash: Int )
	{
		currentCash += p_cash;
		_kernel.messenger.sendMessage( EMsgGameUpdate.COLLECT, this, false, false, true);
		_kernel.messenger.sendMessage( EMsgGameUpdate.CASH_UPDATE, this, false, false, true);
		
		_session.save();
	}
}