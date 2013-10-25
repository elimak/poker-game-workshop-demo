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
import awe6.interfaces.EKey;
import awe6.interfaces.ETextStyle;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.views.entities.PositionableEntity;
import com.elimak.awe6demo.views.gui.InputField;
import com.elimak.awe6demo.views.gui.RedLabelButton;

/**
 * Intro scene: The player must submit his name (at least 3 characters)
 * The username will be saved in a session / shared Object
 */

class Intro extends AScene 
{
	private var _background 		: PositionableEntity;
	private var _logo				: PositionableEntity;
	private var _illustration		: PositionableEntity;
	private var _inputBackground	: PositionableEntity;
	
	private var _welcomeMessage		: Text;
	private var _inputUsername		: InputField;
	
	private var _redButton			: RedLabelButton;
	
	override private function _init():Void 
	{
		super._init();
		// add the visual components 
		createIntroComponents();
	}
	
	private function createIntroComponents() 
	{
		_background = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND) );
		addEntity( _background, true, 1);		
		
		_logo = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.LOGO_INTRO) );
		addEntity( _logo, null, true, 2);		
		_logo.setPosition(33, 67);
		
		_illustration = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.INTRO_ILLUSTRATION) );
		addEntity( _illustration, null, true, 3);		
		_illustration.setPosition(450, 130);
		
		_inputBackground = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.INPUTS_BACKGROUND) );
		addEntity( _inputBackground, null, true, 4);	
		_inputBackground.setPosition(127, 367);
		
		_welcomeMessage = new Text(_kernel, 300, 90, _kernel.getConfig("gui.intro.welcome"), _kernel.factory.createTextStyle( ETextStyle.HEADLINE ), true);
		addEntity(_welcomeMessage, null, true, 5);
		_welcomeMessage.setPosition(133, 268);
		
		_inputUsername = new InputField(_kernel, 225, 40, "",_kernel.factory.createTextStyle( ETextStyle.BODY), false, true);
		addEntity(_inputUsername, null, true, 6);
		_inputUsername.setPosition(140, 380);

		// button submit with callBack 
		_redButton = new RedLabelButton(_kernel, new View(_kernel, new Context()), onSubmitUsername, _kernel.getConfig("gui.intro.submit"), EKey.ENTER);
		addEntity(_redButton, null, true, 7);
		_redButton.setPosition(213, 456);
	}
	
// save the username of the payer in the model but also in a sharedObject, using the session.save() functionality
	private function onSubmitUsername() 
	{
		_controller.updateUserName ( _inputUsername.getInputText());
		_session.save();
		_kernel.scenes.setScene(MENU);
	}
	
// check whether or not the username's lenght is acceptable to be saved.
// also check if the enter key was pressed 
	override private function _updater( ?p_deltaTime:Int = 0 )
	{
		super._updater();
		_redButton.enabled = (_inputUsername.getInputText().length > 2);
		
		if ( _kernel.inputs.keyboard.getIsKeyRelease( EKey.ENTER ) && _redButton.enabled)
			onSubmitUsername();
		
	}
}
