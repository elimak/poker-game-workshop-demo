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
import awe6.interfaces.EKey;
import awe6.extras.gui.Text;
import awe6.interfaces.IKernel;
import awe6.interfaces.ITextStyle;
import flash.events.KeyboardEvent;

/**
 * Provide a basic inputField with a background image.
 * Stop propagation unless the ENTER Key was pressed
 */

class InputField extends Text
{
	
	public function new( p_kernel:IKernel, p_width:Float, p_height:Float, ?p_text:String = "", ?p_textStyle:ITextStyle, ?p_isMultiline:Bool = false, ?p_isInput:Bool = false )
	{
		super(p_kernel, p_width, p_height, p_text, p_textStyle, p_isMultiline, p_isInput);
	}
	
	override private function _stopEventPropogation( p_event:KeyboardEvent ):Void
	{
		if( Std.int(p_event.keyCode) != _kernel.inputs.keyboard.getKeyCode(EKey.ENTER))
			p_event.stopImmediatePropagation();
	}
	
	public function getInputText() : String {
		return _textField.text;
	}

}