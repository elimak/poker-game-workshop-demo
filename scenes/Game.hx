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
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.views.entities.GameBottomMenu;
import com.elimak.awe6demo.views.entities.GameCards;
import com.elimak.awe6demo.views.entities.GameScoring;
import com.elimak.awe6demo.views.entities.PositionableEntity;

class Game extends AScene 
{
	private var _background 		: PositionableEntity;
	private var _logo				: PositionableEntity;
	
	private var _bottomMenu			: GameBottomMenu;
	private var _scoring			: GameScoring;
	private var _cards				: GameCards;
	
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
		
		_logo = new PositionableEntity(_kernel, _assetManager.getViewAsset(EAsset.LOGO_GAME));
		addEntity( _logo, null, true, 2);		
		_logo.setPosition(33, 67);		
		
		_bottomMenu = new GameBottomMenu(_kernel );
		addEntity( _bottomMenu, null, true, 3);
		_bottomMenu.setPosition(0, 504);
		// create the component after the entity was initialize to avoid positionning issues on the children (especially button types)
		_bottomMenu.createComponents();		
		
		_scoring = new GameScoring(_kernel );
		addEntity( _scoring, null, true, 4);
		_scoring.setPosition(402, 12);
		// create the component after the entity was initialized to avoid positionning issues on the children
		//(children need to know the position of their parents)
		_scoring.createComponents();		
		
		_cards = new GameCards(_kernel);
		addEntity( _cards, null, true, 5);
		_cards.setPosition(10, 250);
		// same as above
		_cards.createComponents();	
	}
}