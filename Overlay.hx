/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo;
import awe6.interfaces.EOverlayButton;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IKernel;
import awe6.interfaces.ITextStyle;
import awe6.interfaces.IView;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.views.gui.SmartLabel;

/**
 * The overlay is a expecting by default the following gui:
 * Back button, Mute button, Unmute button, Pause button, Unpause button
 * 
 * If you do not use all of them. It is important to hide them via:
 * showButton( TypeOfButton, false);
 */

class Overlay extends awe6.core.Overlay 
{
	private var _assetManager	: AssetManager;
	
	public function new( p_kernel:IKernel ) 
	{
		_assetManager = cast( p_kernel.assets, AssetManager );
		
		// assets border
		var l_border : IView = _assetManager.getViewAsset(EAsset.BORDER);
		
		// TextStyle are pre-defined in the factory.
		var style: ITextStyle = p_kernel.factory.createTextStyle(ETextStyle.BUTTON);
		style.color = 0xffffff;
		
		// assets Back button (Up and Over)
		var l_BackLabelUp	: SmartLabel = new SmartLabel(p_kernel, 121, 58, _assetManager.getViewAsset(EAsset.BACK_UP), "Back", style, 8, 12);
		var l_BackLabelOver	: SmartLabel = new SmartLabel(p_kernel, 121, 58, _assetManager.getViewAsset(EAsset.BACK_OVER), "Back", style, 8, 12);
		
		// here we are only passing assets for the border and for the back button: Up and Over state, ignoring the mute, pause, unmute and unpause button
		super( p_kernel, 121, 58, l_border, l_BackLabelUp.view, l_BackLabelOver.view);
	}
	
	override private function _init():Void 
	{
		super._init();

		positionButton( EOverlayButton.BACK, 35, 0 );
		showButton( EOverlayButton.BACK, true);
		
		// hide the default buttons that are not used
		showButton( EOverlayButton.MUTE, false);
		showButton( EOverlayButton.UNMUTE, false);
		showButton( EOverlayButton.PAUSE, false);
		showButton( EOverlayButton.UNPAUSE, false);
	}
}
