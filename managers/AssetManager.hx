/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.managers;
import awe6.core.AAssetManager;
import awe6.core.Context;
import awe6.core.View;
import awe6.interfaces.IView;
import com.elimak.awe6demo.interfaces.EAsset;
import com.elimak.awe6demo.interfaces.ESuitSymbols;
import com.elimak.awe6demo.interfaces.EPlayingCards;
import com.elimak.awe6demo.views.entities.PlayingCard;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

/**
 * Retrieve all the assets with type safe route.
 */

class AssetManager extends AAssetManager 
{	
	override private function _init():Void 
	{
		super._init();
	}	
	
	private function _createView ( p_id : String, p_package: String ) : IView
	{
		var l_context	: Context = new Context();
		var l_libBitmap	: Bitmap = cast getAsset(p_id, p_package);
		var l_bitmap	: Bitmap = new Bitmap();
		l_bitmap.bitmapData = l_libBitmap.bitmapData.clone();
		l_context.addChild( l_bitmap );
		
		return new View( _kernel, l_context );
	}
	
	public function getViewAsset ( p_id: EAsset ) : IView
	{
		switch( p_id)
		{
			case RED_OVER			: return _createView( "RedOver", 			"assets.img");
			case RED_UP				: return _createView( "RedUp", 				"assets.img");
			case RED_DISABLED		: return _createView( "RedDisabled", 		"assets.img");
			
			case YELLOW_UP			: return _createView( "YellowUp", 			"assets.img");
			case YELLOW_OVER		: return _createView( "YellowOver", 		"assets.img");
			case YELLOW_DISABLED	: return _createView( "YellowDisabled", 	"assets.img");
			
			case WIN_BACKGROUND		: return _createView( "WinBackground", 		"assets.img");
			case SCORE_GRID			: return _createView( "ScoreGrid", 			"assets.img");
			case MENU_ILLUSTRATION	: return _createView( "MenuIllustration", 	"assets.img");
			case LOGO_MENU			: return _createView( "LogoMenu", 			"assets.img");
			case LOGO_INTRO			: return _createView( "LogoIntro", 			"assets.img");
			case LOGO_GAME			: return _createView( "LogoGame", 			"assets.img");
			case LOGO_BANK			: return _createView( "LogoBank", 			"assets.img");
			case INTRO_ILLUSTRATION	: return _createView( "IntroIllustration", 	"assets.img");
			case INPUTS_BACKGROUND	: return _createView( "InputsBackground", 	"assets.img");
			case HELD_BACKGROUND	: return _createView( "HeldBackground", 	"assets.img");
			case GAME_BOTTOM_BAR	: return _createView( "GameBottomBar", 		"assets.img");
			case BORDER				: return _createView( "Border", 			"assets.img");
			case BET_BACKGROUND		: return _createView( "BetBackground", 		"assets.img");
			case BANK_ILLUSTRATION	: return _createView( "BankIllustration", 	"assets.img");
			case BACK_UP			: return _createView( "BackUp", 			"assets.img");
			case BACK_OVER			: return _createView( "BackOver", 			"assets.img");
			case BACKGROUND			: return _createView( "Background", 		"assets.img");
		}
	}
	
/**
 * Get a Bitmap sample of the spritesheet
 * @param	?p_symbol
 * @param	?p_card
 * @return
 */
	public function getPlayingCard( ?p_symbol: ESuitSymbols, ?p_card: EPlayingCards ) : IView
	{
		var l_context	: Context = new Context();
		var l_libBitmap	: Bitmap = cast getAsset("CardsSheet", "assets.img");
		var l_bitmap	: Bitmap = new Bitmap();
		l_context.addChild( l_bitmap );

		var l_matrix  = new Matrix();
		
		var l_row =  ( p_symbol != null )? Type.enumIndex(p_symbol) : 4;
		var l_column = ( p_card != null )?  Type.enumIndex(p_card) : 2;
		
		l_matrix.tx = -PlayingCard.WIDTH *  l_column;
		l_matrix.ty = -PlayingCard.HEIGHT * l_row;
		
		l_bitmap.bitmapData = new BitmapData( PlayingCard.WIDTH, PlayingCard.HEIGHT, true, 0x000000 );
		l_bitmap.bitmapData.draw( l_libBitmap.bitmapData, l_matrix, true );

		return new View( _kernel, l_context );

	}
}