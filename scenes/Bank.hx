/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.scenes;
import awe6.core.Context;
import awe6.core.View;
import awe6.extras.gui.Text;
import awe6.interfaces.ETextStyle;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.views.entities.PositionableEntity;
import com.elimak.awe6demo.views.gui.RedLabelButton;
import com.elimak.awe6demo.views.gui.YellowLabelButton;

class Bank extends AScene 
{
	private var _background 		: PositionableEntity;
	private var _logo				: PositionableEntity;
	private var _illustration		: PositionableEntity;
	
	private var _add10Button	: YellowLabelButton;
	private var _add50Button	: YellowLabelButton;
	private var _add100Button	: YellowLabelButton;
	
	private var _doneButton		: RedLabelButton;
	private var _infoText		: Text;
	
	override private function _init():Void 
	{
		super._init();
		// add the visual components 
		createIntroComponents();
	}
	
	private function createIntroComponents() 
	{
	
		_background = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND));
		addEntity( _background, null, true, 1);		
				
		_logo = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.LOGO_BANK));
		addEntity( _logo, null, true, 2);		
		_logo.setPosition(33, 67);				
		
		_illustration = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.BANK_ILLUSTRATION));
		addEntity( _illustration, null, true, 3);
		_illustration.setPosition(16, 300);
		
		// Yellow buttons
		_add10Button = new YellowLabelButton(_kernel, new View(_kernel, new Context()), callback(addCash, 10), _kernel.getConfig("gui.bank.add10"));
		addEntity(_add10Button, null, true, 4);
		_add10Button.setPosition(477, 264);
		_add10Button.enabled = true;		
		
		_add50Button = new YellowLabelButton(_kernel, new View(_kernel, new Context()), callback(addCash, 50), _kernel.getConfig("gui.bank.add50"));
		addEntity(_add50Button, null, true, 5);
		_add50Button.setPosition(597, 264);
		_add50Button.enabled = true;
		
		_add100Button = new YellowLabelButton(_kernel, new View(_kernel, new Context()), callback(addCash, 100), _kernel.getConfig("gui.bank.add100"));
		addEntity(_add100Button, null, true, 6);
		_add100Button.setPosition(720, 264);
		_add100Button.enabled = true;
		
		// Red button	
		_doneButton = new RedLabelButton(_kernel, new View(_kernel, new Context()), onClickDone, _kernel.getConfig("gui.bank.done"));
		addEntity(_doneButton, null, true, 7);
		_doneButton.setPosition(572, 370);
		_doneButton.enabled = true;		
		
		// Text info
		var l_label =  _kernel.getConfig("gui.bank.credit") + " $" + _controller.getCash();
		_infoText = new Text(_kernel, 300, 90,l_label, _kernel.factory.createTextStyle( ETextStyle.HEADLINE ), true);
		addEntity(_infoText, null, true, 8);
		_infoText.setPosition(510, 200);
	}
	
	private function addCash( p_amount: Int )
	{
		_controller.updateCash( _controller.getCash() +  p_amount);
		_infoText.text = _kernel.getConfig("gui.bank.credit") + " $"+ _controller.getCash();
	}
	
	private function onClickDone () 
	{
		_kernel.scenes.next();
	}
}