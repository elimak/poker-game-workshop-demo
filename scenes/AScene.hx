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
import awe6.core.Scene;
import awe6.interfaces.EScene;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.IController;
import com.elimak.awe6demo.managers.AssetManager;
import com.elimak.awe6demo.managers.Session;

/**
 * Base class for all the Scenes
 */

class AScene extends Scene 
{
	private var _assetManager	: AssetManager;
	private var _controller		: IController;
	private var _session		: Session;
	
	public function new( p_kernel:IKernel, p_type:EScene ) 
	{
		_session = cast p_kernel.session;
		_controller = _session.controller;
		_assetManager = cast( p_kernel.assets, AssetManager );
		
		super( p_kernel, p_type, false, false, false );
	}
}
