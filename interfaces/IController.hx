/*
 * Copyright (c) June 2012, Valerie.Elimak - blog.elimak.com
 * 
 * This application was built in the context of a workshop on awe6
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * - Redistributions of source code must retain the above copyright notice.
 */

package com.elimak.awe6demo.interfaces;
import com.elimak.awe6demo.models.vo.CardPositionVO;

interface IController 
{
	function holdCard( p_card: CardPositionVO ): Void;
	function releaseCard( p_card: CardPositionVO ): Void;
	function selectCardWhenDouble (p_card: CardPositionVO): Void;
	function onGameAction ( p_gameAction: EGameAction ): Void;
	function updateCash( p_value: Int ) : Void;
	function updateUserName( p_value: String ) : Void;
	function getCash () : Int;
	function getUsername() : String;

}