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
import awe6.interfaces.EKey;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IKernel;
import awe6.interfaces.IView;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.views.entities.PositionableEntity;
import com.elimak.awe6demo.views.gui.SmartLabel;

/**
 * Red button, contains an instance of 
 * StatedButton ( _kernel, enabledUI: BasicButton, disabledUI: SmartLabel)
 */

class RedLabelButton extends PositionableEntity
{
	private static inline var WIDTH 	: Int = 161;
	private static inline var HEIGHT 	: Int = 65;
	
	private var _statedButton : StatedButton;
	private var _assetManager : AssetManager;
	
	private var _handler 	: Dynamic;
	private var _label 		: String;
	private var _keyType 	: EKey;

	public var enabled(get_enabled, set_enabled):Bool;
	
	public function new( p_kernel:IKernel, p_view: IView, p_handler: Dynamic, ?p_label:String, ?p_id: String, ?p_keyType:EKey ) 
	{
		_assetManager = cast( p_kernel.assets, AssetManager );
		_handler = p_handler;
		_label = p_label;
		_keyType = p_keyType;
		
		super(p_kernel, p_view, p_id);
	}
	
	override private function _init()
	{
		super._init();
		// extends here

		// retrieve the IView assets for the red button
		var l_upView 		: IView = _assetManager.getViewAsset(EAsset.RED_UP);
		var l_overView 		: IView = _assetManager.getViewAsset(EAsset.RED_OVER);
		var l_disabledView 	: IView = _assetManager.getViewAsset(EAsset.RED_DISABLED);
		
		// create the views for the enabled state
		var l_activeLabelUp    : SmartLabel = new SmartLabel(_kernel, WIDTH, HEIGHT, l_upView, _label, _kernel.factory.createTextStyle(ETextStyle.SUBHEAD), 12, 12);
		var l_activeLabelOver  : SmartLabel = new SmartLabel(_kernel, WIDTH, HEIGHT, l_overView, _label, _kernel.factory.createTextStyle(ETextStyle.SUBHEAD), 12, 12);
		
		// create the enabled button
		var l_activeButton 	 : BasicButton = new BasicButton(_kernel, l_activeLabelUp.view, l_activeLabelOver.view, WIDTH, HEIGHT, 0, 0, _keyType, _handler);
		// create the disabled ui
		var l_inactiveLabel  : SmartLabel = new SmartLabel(_kernel, WIDTH, HEIGHT, l_disabledView, _label, _kernel.factory.createTextStyle(ETextStyle.SUBHEAD), 12, 12);
		
		// create and add the stated button with the 2 previous uis
		_statedButton = new StatedButton(_kernel, l_activeButton, l_inactiveLabel );
		addEntity(_statedButton, null, true);
	}
	
	override public function setPosition( p_x:Float, p_y:Float ):Void
	{
		x = p_x;
		y = p_y;
	}
	
	private function get_enabled():Bool 
	{
		return _statedButton.enabled;
	}
	
	private function set_enabled(value:Bool):Bool 
	{
		_statedButton.enabled = value;
		return value;
	}
}