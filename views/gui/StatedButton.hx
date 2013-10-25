/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.views.gui;
import awe6.core.BasicButton;
import awe6.core.Context;
import awe6.core.drivers.flash.View;
import awe6.interfaces.EAgenda;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.views.entities.PositionableEntity;
import com.elimak.awe6demo.views.gui.SmartLabel;

/**
 * Button with 2 states: Enabled and Disabled
 * -> using the extension of EAgenda
 */

class StatedButton extends PositionableEntity
{
	private var _activeButton 	: BasicButton;
	private var _inactiveButton : SmartLabel;
	private var _enabled 		: Bool;
	
	public var enabled(get_enabled, set_enabled):Bool;
	
	public function new( p_kernel: IKernel, p_activeButton : BasicButton, p_inactiveButton: SmartLabel ) 
	{
		_activeButton = p_activeButton;
		_inactiveButton = p_inactiveButton;
		
		super(p_kernel, new View(p_kernel, new Context()));
	}
	
	override private function _init():Void 
	{
		super._init();
		
		// attach the entities on a specific Agenda.
		addEntity(_activeButton, EAgenda.SUB_TYPE( _HelperEState.ENABLED ), true, 1);
		addEntity(_inactiveButton, EAgenda.SUB_TYPE( _HelperEState.DISABLED ), true, 1);
	}
	
/**
 * The Basic button uses a custom hitarea instead of an eventlistener.
 * Make sure to initialize the position of the entities when the parent's position changes or when the states change
 * 
 * @param	p_x
 * @param	p_y
 */
	override public function setPosition( p_x:Float, p_y:Float ):Void
	{
		x = p_x;
		y = p_y;
		_inactiveButton.setPosition(0, 0);
		_activeButton.setPosition(0, 0);
	}
	
/**
 * Get / Set the enabled and disabled states, update the Agenda accordingly
 * @return
 */
	private function get_enabled():Bool { return _enabled; }
	
	private function set_enabled(value:Bool):Bool 
	{
		if ( !value ) {
			setAgenda(EAgenda.SUB_TYPE( _HelperEState.DISABLED ));
		}
		else {
			setAgenda(EAgenda.SUB_TYPE( _HelperEState.ENABLED ));
		}
		setPosition(0, 0);
		return _enabled = value;
	}
}

private enum _HelperEState
{
	ENABLED;
	DISABLED;
}