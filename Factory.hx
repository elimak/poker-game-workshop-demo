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
import awe6.core.AFactory;
import awe6.core.TextStyle;
import awe6.interfaces.EScene;
import awe6.interfaces.ETextAlign;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IAssetManagerProcess;
import awe6.interfaces.IOverlayProcess;
import awe6.interfaces.IPreloader;
import awe6.interfaces.IScene;
import awe6.interfaces.ISceneTransition;
import awe6.interfaces.ISession;
import awe6.interfaces.ITextStyle;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.managers.Session;
import com.elimak.awe6demo.Overlay;
import com.elimak.awe6demo.scenes.Bank;
import com.elimak.awe6demo.scenes.EExtendedScene;
import com.elimak.awe6demo.scenes.Game;
import com.elimak.awe6demo.scenes.Intro;
import com.elimak.awe6demo.scenes.Menu;
import com.elimak.awe6demo.scenes.SceneTransition;
import flash.text.Font;


/**
 * The factory is used to configure the game and creates the managers.
 */

class Factory extends AFactory 
{
	private var _assetManager	: AssetManager;

	override private function _configurer( ?p_isPreconfig:Bool = false ):Void
	{
		id = "DemoByElimak";
		version = "0.0.1";
		author = "valerie.elimak - blog.elimak.com";
		isDecached = false;
		width = 900;
		height = 600;
		bgColor = 0xFF999999;
		// is being set in updateStartingScene()
		// startingSceneType = EScene.INTRO;
		targetFramerate = 30;
		isFixedUpdates = true;
	}
	
	// Called by the preloader to configure the StartingSceneType
	// usually, this happens in the _configurer
	public function updateStartingScene( p_scene: EScene ) 
	{
		startingSceneType = p_scene;
	}
	
	// create an extended AssetManager for our specific needs.
	override public function createAssetManager():IAssetManagerProcess 
	{
		if ( _assetManager == null ) 
		{
			_assetManager = new AssetManager( _kernel );
		}
		return _assetManager;
	}

	override public function createOverlay():IOverlayProcess 
	{
		var l_overlay:Overlay = new Overlay( _kernel );
		return l_overlay;
	}

	override public function createPreloader():IPreloader 
	{
		return new Preloader( _kernel,_getAssetUrls(), isDecached );
	}
	
	// Here we are creating 3 regular scenes and 1 extended scene, using SUB_TYPE()
	override public function createScene( p_type:EScene ):IScene 
	{
		switch ( p_type ) 
		{
			case GAME : return new Game( _kernel, p_type);
			case INTRO : return new Intro(_kernel, p_type);
			case MENU : return new Menu( _kernel, p_type );
			
			// Checking SUB_TYPE(type)
			case SUB_TYPE( l_value ) : 	
				switch ( l_value ){
					case EExtendedScene.BANK: return new Bank( _kernel, p_type );
				}
			default : null;
		}
		return super.createScene( p_type );
	}
	
	override public function createSceneTransition( ?p_typeIncoming:EScene, ?p_typeOutgoing:EScene ):ISceneTransition 
	{
		var l_sceneTransition:SceneTransition = new SceneTransition( _kernel );
		return l_sceneTransition;
	}
	
	override public function createSession( ?p_id:String ):ISession 
	{
		return new Session( _kernel, p_id );
	}
	
	// Predefined all the style used in the application.
	override public function createTextStyle( ?p_type:ETextStyle ):ITextStyle 
	{
		p_type = ( p_type == null )? BODY:p_type;
		
		var l_fontBold: Font = _kernel.assets.getAsset( _kernel.getConfig( "settings.font.bold" ), "");
		var l_fontBoldName:String = l_fontBold.fontName;
		var l_fontMedium: Font = _kernel.assets.getAsset( _kernel.getConfig( "settings.font.medium" ), "");
		var l_fontMediumName:String = l_fontMedium.fontName;

		var l_result:TextStyle;
		
		switch ( p_type ) {
			case HEADLINE : 
				l_result = new TextStyle( l_fontBoldName, 12, 0xffffff );
				l_result.size = 36;
				l_result.align = ETextAlign.CENTER;
			case OVERSIZED: 
				l_result = new TextStyle( l_fontBoldName, 12, 0xffffff );
				l_result.size = 56;
			case SUBHEAD : 
				l_result = new TextStyle( l_fontMediumName, 12, 0xffffff );
				l_result.size = 28;
				l_result.align = ETextAlign.CENTER;
			case BUTTON : 
				l_result = new TextStyle( l_fontMediumName, 12, 0x000000 );
				l_result.size = 20;
				l_result.align = ETextAlign.CENTER;
			case SMALLPRINT : 
				l_result = new TextStyle( l_fontMediumName, 12, 0xffffff );
				l_result.size = 18;	
			case BODY : 
				l_result = new TextStyle( l_fontMediumName, 12, 0xffffff );
				l_result.size = 28;
			default : 
				l_result = new TextStyle( l_fontMediumName, 12, 0xffffff );
				l_result.size = 28;
		}
		return l_result;
	}

// Configure the back() and next() functionalities of the SceneManager depending on the current scene playing
// Note that only the Game and the Bank Scene have a back button visible
	override public function getBackSceneType( p_type:EScene ):EScene 
	{
		switch ( p_type ) 
		{
			case GAME : return MENU;
			case SUB_TYPE(l_value) : 
				switch ( l_value ){
					case EExtendedScene.BANK: return MENU;
				}
			default : null;
		}
		return super.getBackSceneType( p_type );
	}	
	
// We only use _kernel.scenes.next() in the Bank scene
	override public function getNextSceneType( type:EScene ):EScene 
	{
		switch ( type ) 
		{
			case SUB_TYPE(l_value) : 
				switch ( l_value ){
					case EExtendedScene.BANK: return MENU;
				}
			default : null;
		}
		return super.getNextSceneType( type );
	}	
	
}
