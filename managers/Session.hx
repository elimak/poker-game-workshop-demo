/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.managers;
import awe6.core.ASession;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.models.Controller;
import haxe.Log;

/**
 * ...
 * @author valerie.elimak - blog.elimak.com
 */

class Session extends ASession 
{
	public var name		: String;
	public var cash		: Int;
	
// using an interface allows us to defined several controllers:
// * live * local * testing cases 
// and use the one we need during development
	public var controller	: IController; 
	
	public function new (  p_kernel: IKernel, p_id: String)
	{
		controller = new Controller(p_kernel, this);
		super(p_kernel, p_id);
	}
	
	override private function _init() 
	{
		_version = 1;// incremement this every time you make a structural change to the session (it will force a reset on all users' systems)
		super._init();
	}
	
// get the values ALREADY stored into the sharedObject
	override private function _getter():Void 
	{
		super._getter();
		//
		name = _data.name;
		cash = _data.cash;
		
		controller.updateCash(cash);
		controller.updateUserName (name);
	}
	
// get the values TO BE stored into the sharedObject
	override private function _setter():Void 
	{
		super._setter();
		//
		name = _data.name = controller.getUsername();
		cash = _data.cash = controller.getCash();

	}
	
// reset the values retrieved by the sharedObject
	override private function _resetter():Void 
	{
		super._resetter();
	
		name = "";
		cash = 75;

		controller.updateCash(cash);
		controller.updateUserName (name);	/**/

	}	
}
