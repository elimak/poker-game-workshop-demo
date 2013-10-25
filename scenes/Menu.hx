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
import awe6.interfaces.EScene;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.views.entities.PositionableEntity;
import com.elimak.awe6demo.views.gui.RedLabelButton;

class Menu extends AScene 
{
	private var _background 		: PositionableEntity;
	private var _logo				: PositionableEntity;
	private var _illustration		: PositionableEntity;
	private var _inputBackground	: PositionableEntity;

	private var _welcomeMessage		: Text;

	private var _bankButton			: RedLabelButton;
	private var _gameButton			: RedLabelButton;
	
	override private function _init():Void 
	{
		super._init();
		// extend / addentities
		createIntroComponents();
	}
	
// add all the visual entity for this scene
	private function createIntroComponents() 
	{
		_background = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND));
		addEntity( _background, true,1);
		
		_logo = new PositionableEntity(_kernel,_assetManager.getViewAsset(EAsset.LOGO_MENU));
		addEntity( _logo, true,2);
		_logo.setPosition(33, 67);
		
		_illustration = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.MENU_ILLUSTRATION));
		addEntity( _illustration, true,3);
		_illustration.setPosition(45, 228);
		
		var l_welcomeMsg = cast _kernel.getConfig("gui.menu.welcome");
		l_welcomeMsg = StringTools.replace(l_welcomeMsg, "{playername}", _controller.getUsername());
		_welcomeMessage = new Text(_kernel, 225, 40, l_welcomeMsg,_kernel.factory.createTextStyle(SMALLPRINT), true, true);
		addEntity(_welcomeMessage, true,4);
		_welcomeMessage.setPosition(330, 140);

		var l_label : String = cast _kernel.getConfig("gui.menu.bank");
		_bankButton = new RedLabelButton(_kernel, new View(_kernel, new Context()), onClickBank, l_label);
		addEntity(_bankButton, true,5);
		_bankButton.setPosition(590, 300);
		_bankButton.enabled = true;
		
		l_label = cast _kernel.getConfig("gui.menu.game");
		_gameButton = new RedLabelButton(_kernel, new View(_kernel, new Context()), onClickGame, l_label);
		addEntity(_gameButton, true,6);
		_gameButton.setPosition(590, 400);
		_gameButton.enabled = true;
	}
	
// Navigation from a scene to a scene
	private function onClickGame() 
	{
		_kernel.scenes.setScene(GAME);	
	}
	
	private function onClickBank() 
	{
		_kernel.scenes.setScene(EScene.SUB_TYPE(EExtendedScene.BANK));
	}
}
