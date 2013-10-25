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
import awe6.core.drivers.ASceneTransition;
import awe6.core.View;
import awe6.interfaces.IKernel;
import flash.display.Bitmap;
import flash.display.BitmapData;


class SceneTransition extends ASceneTransition 
{
	public function new( p_kernel:IKernel ) 
	{
		var l_duration:Int = 200;
		super( p_kernel, l_duration );
	}
	
	override private function _init():Void 
	{
		super._init();
		// extend
		var l_bitmapData:BitmapData = new BitmapData( _kernel.factory.width, _kernel.factory.height, true, _kernel.factory.bgColor );
		try
		{
			var l_view:View = cast _kernel.scenes.scene.view;
			l_bitmapData.draw( l_view.context );
		}
		catch ( l_error:Dynamic ) {}
		_context.addChild( new Bitmap( l_bitmapData ) );
	}
	
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		//extend
		if ( !isDisposed )
			_context.alpha = 1 - progress;
	}
}
