/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.models;
import awe6.core.Entity;
import awe6.interfaces.IKernel;

/**
 * Very minimalist Model to hold the user's properties
 */

class PlayerModel extends Entity
{
	public var name	 	: String;
	
	public function new( p_kernel: IKernel ) 
	{
		super(p_kernel);
	}
	
	override private function _init()
	{
		super._init();
		name = "";
	}
}