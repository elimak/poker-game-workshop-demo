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
import awe6.core.Context;
import awe6.core.drivers.AView;
import awe6.extras.gui.Text;
import awe6.interfaces.IKernel;
import awe6.interfaces.ITextStyle;
import awe6.interfaces.IView;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.views.entities.PositionableEntity;


/**
 * This is an positionable Entity that only contains a text field with some margin around and a View for background
 */

class SmartLabel extends PositionableEntity
{
	private var _label			: String;
	private var _marginWidth	: Int;
	private var _marginHeight	: Int;
	private var _style			: ITextStyle;
	private var _width			: Int;
	private var _height			: Int;
	
	private var _assetManager	: AssetManager;
	
	public function new( p_kernel:IKernel, p_width: Int, p_height: Int, p_view: IView, ?p_label:String, p_style: ITextStyle, p_marginWidth: Int, p_marginHeight: Int ) 
	{
		_label = p_label;
		_style = p_style;
		_marginWidth = p_marginWidth;
		_marginHeight = p_marginHeight;
		_width = p_width;
		_height = p_height;
		_style = p_style;
		
		super( p_kernel, p_view );
	}
	
	override private function _init():Void
	{
		super._init();

		var l_context 	: Context = cast(view, AView).context;
		var l_text		: Text = new Text( _kernel, _width - ( 2 * _marginWidth ), _height - ( 2 * _marginHeight ), _label, _style );
		l_text.setPosition( _marginWidth, _marginHeight );
		l_context.addChild( untyped l_text._sprite ); // safe ancestry cast
	}
}