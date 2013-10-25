package com.elimak.awe6demo.models.vo;
import com.elimak.awe6demo.interfaces.EPlayingCards;
import com.elimak.awe6demo.interfaces.ESuitSymbols;

/**
 * ...
 * @author valerie.elimak - blog.elimak.com
 */

class CardPositionVO 
{
	public function new() {}
	public var id			: String;
	public var card			: EPlayingCards;
	public var symbol		: ESuitSymbols;
	
	
	public function toString() : String {
		var l_result = "CardPositionVO {\n";
		l_result += "\t id: " + id + "\n"; 
		l_result += "\t card: " + card + "\n"; 
		l_result += "\t symbol: " + symbol + "\n"; 
		l_result += "}\n"; 
		return l_result;
	}
}