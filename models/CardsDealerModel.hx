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
import awe6.interfaces.EAudioChannel;
import awe6.interfaces.IKernel;
import com.elimak.awe6demo.interfaces.EGameWinningDeals;
import com.elimak.awe6demo.interfaces.msg.EMsgGameUpdate;
import com.elimak.awe6demo.models.vo.CardPositionVO;
import com.elimak.awe6demo.interfaces.EPlayingCards;
import com.elimak.awe6demo.interfaces.ESuitSymbols;
import haxe.Log;

/**
 * This model holds the logic of the playing cards game
 * It manages the rounds and the final outcome.
 */

class CardsDealerModel extends Entity
{
	private var _pileCards : Array<CardPositionVO>;
	private var _heldCards : Array<CardPositionVO>;
	private var _roundCards : Array<CardPositionVO>;
	
	private var _winningCombination : EGameWinningDeals;  
	
	public var cashInDouble		: Int;
	
	public function new( p_kernel: IKernel ) 
	{
		super(p_kernel);
	}
	
//***********************************//
// PRIVATE METHODS
//***********************************//

	override private function _init()
	{
		super._init();

		_pileCards = new Array<CardPositionVO>();
		_heldCards = new Array<CardPositionVO>();
		_roundCards = new Array<CardPositionVO>();
		
		for ( l_cardEnumValue in Type.allEnums(EPlayingCards) ) 
		{
			var l_pCardConstructor 	= Type.enumConstructor(l_cardEnumValue); 			// String
			var l_pCardEnumName		= Type.getEnumName(Type.getEnum(l_cardEnumValue)); 	// String

			for ( l_symbEnumValue in Type.allEnums(ESuitSymbols) ) 
			{
				// var l_symbolCard : EnumValue = cast symbEnum;
				var l_pSymbConstructor 	= Type.enumConstructor(l_symbEnumValue); 			// String
				var l_pSymbEnumName		= Type.getEnumName(Type.getEnum(l_symbEnumValue)); 	// String

				var l_cardPositionVO : CardPositionVO = new CardPositionVO();
				l_cardPositionVO.id = "card_" + l_pCardConstructor + "_" + l_pSymbConstructor;
				
				// there might be a better way to resolve the enum, I didnt not find faster.
				l_cardPositionVO.card = Reflect.field(Type.resolveEnum(l_pCardEnumName), l_pCardConstructor);
				l_cardPositionVO.symbol = Reflect.field(Type.resolveEnum(l_pSymbEnumName), l_pSymbConstructor);

				_pileCards.push(l_cardPositionVO);
			}
		}
		shuffle();
	}

	private function shuffle()
	{
		var l_cards = _pileCards.length;
		var l_shuffled = new Array<CardPositionVO>();
		var l_randomNR : Int;
		
		for ( i in 0...l_cards) 
		{
			l_randomNR = Math.round(Math.random() * (_pileCards.length-1));
			l_shuffled.push(_pileCards.splice(l_randomNR, 1)[0]);
		}
		_pileCards = l_shuffled;
	}
	
// card used in the current round
	private function isUsedInRound ( p_card: CardPositionVO ) : Bool
	{
		for ( l_card in _roundCards ) 
		{
			if ( l_card.id == p_card.id ) return true;
		}
		return false;
	}
	
// get random cards from the pile. check if they are avalaible first
	private function getCards ( p_nrOfCards: Int ) : Array<CardPositionVO>
	{
		shuffle();
		var l_result = new Array<CardPositionVO>();
		for ( i in 0..._pileCards.length) {
			if ( !isUsedInRound(_pileCards[i])) {
				l_result.push(_pileCards[i]);
			}
			if ( l_result.length == p_nrOfCards) {
				return l_result;
			}
		}
		return l_result;
	}
	
// function used to sort an array numeric
	private function numSort( p_nr1:Int, p_nr2:Int):Int
    {        
        if (p_nr1 < p_nr2) return -1;
        if (p_nr1 > p_nr2) return 1;
        return 0;
    }
	
// return  if the selected card is stronger than the card in the double.
	private function isWinningDouble( p_selectedCard: CardPositionVO ) : Bool
	{
		var cardIndexToBeat = Type.enumIndex(_roundCards[0].card);
		var selectedCardIndex = Type.enumIndex(p_selectedCard.card);
		return ( _roundCards[0].card != EPlayingCards.ACE && cardIndexToBeat < selectedCardIndex || cardIndexToBeat > 0 &&  p_selectedCard.card == EPlayingCards.ACE);
	}
	
// return  if the selected card is equal than the card in the double.
	private function isEqualDouble( p_selectedCard: CardPositionVO ) : Bool
	{
		return ( _roundCards[0].card == p_selectedCard.card);
	}
	
// get the gain for the double. the values are set in the config and mapped below based on the currentBet.
	private function getGain( p_betIndex: Int, p_winningCombination: EGameWinningDeals) : Int
	{
		switch( p_winningCombination)
		{
			case EGameWinningDeals.ROYALE_FLUSH		: return Std.parseInt(_kernel.getConfig("gui.game.value0")) * p_betIndex;
			case EGameWinningDeals.FOUR_OF_KIND		: return Std.parseInt(_kernel.getConfig("gui.game.value1")) * p_betIndex;
			case EGameWinningDeals.STRAIGHT_FLUSH	: return Std.parseInt(_kernel.getConfig("gui.game.value2")) * p_betIndex;
			case EGameWinningDeals.FLUSH			: return Std.parseInt(_kernel.getConfig("gui.game.value3")) * p_betIndex;
			case EGameWinningDeals.STRAIGHT			: return Std.parseInt(_kernel.getConfig("gui.game.value4")) * p_betIndex;
			case EGameWinningDeals.THREE_OF_KIND	: return Std.parseInt(_kernel.getConfig("gui.game.value5")) * p_betIndex;
			case EGameWinningDeals.TWO_PAIRS		: return Std.parseInt(_kernel.getConfig("gui.game.value6")) * p_betIndex;
			case EGameWinningDeals.JACKS_OR_BETTER	: return Std.parseInt(_kernel.getConfig("gui.game.value7")) * p_betIndex;
			default:
		}
		return 0;
	}
	
// check wheter or not the set of card that was selected is winning or not
	private function isWinningDeal( p_setOfCards : Array<CardPositionVO> ) : Bool
	{
		_winningCombination = EGameWinningDeals.NONE;
		
		var l_symbolsIndex	: Array<Int> = new Array<Int>();
		var l_cardsIndex 	: Array<Int> = new Array<Int>();
		
		for (l_cardVO in p_setOfCards) {
			l_symbolsIndex.push(Type.enumIndex(l_cardVO.symbol));
			l_cardsIndex.push(Type.enumIndex(l_cardVO.card));
		}
		l_symbolsIndex.sort(numSort);
		l_cardsIndex.sort(numSort);
		
		// all cards are the same symbols 
		var l_flush 	: Bool = (l_symbolsIndex[0] == l_symbolsIndex[1] && l_symbolsIndex[0] == l_symbolsIndex[2] 
									&& l_symbolsIndex[0] == l_symbolsIndex[3] && l_symbolsIndex[0] == l_symbolsIndex[4]); 	// winning
		// cards follow each others
		var l_straight 	: Bool = (l_cardsIndex[0] + 1 == l_cardsIndex[1] && l_cardsIndex[1] + 1 == l_cardsIndex[2] 
								&& l_cardsIndex[2] + 1 == l_cardsIndex[3] && l_cardsIndex[3] + 1 == l_cardsIndex[4]); 		// winning
		// cards follow eachother starting from 10 to Ace
		var l_royalStraight : Bool = ( l_cardsIndex[1] == Type.enumIndex(EPlayingCards.TEN) && l_cardsIndex[2] == Type.enumIndex(EPlayingCards.JACK) 
									&& l_cardsIndex[3] == Type.enumIndex(EPlayingCards.QUEEN) && l_cardsIndex[4] == Type.enumIndex(EPlayingCards.KING)  
									&& l_cardsIndex[0]  == Type.enumIndex(EPlayingCards.ACE));								// winning
		
		// same of a kind
		var l_sameOfAKind : Hash<Int> = new Hash<Int>();
		for (i in 0...l_cardsIndex.length) {
			if ( l_sameOfAKind.exists(Std.string(l_cardsIndex[i]))) {
				var l_newValue = l_sameOfAKind.get(Std.string(l_cardsIndex[i])) + 1;
				l_sameOfAKind.set(Std.string(l_cardsIndex[i]), l_newValue);
			}
			else l_sameOfAKind.set(Std.string(l_cardsIndex[i]), 1);
		}
		var l_sameOfAKindMax : Int = 0;
		for (key in l_sameOfAKind.keys()) {
			l_sameOfAKindMax = (l_sameOfAKindMax < l_sameOfAKind.get(key))? l_sameOfAKind.get(key) : l_sameOfAKindMax;
		}

		var l_4ofKind : Bool = l_sameOfAKindMax == 4; // winning
		var l_3ofKind : Bool = l_sameOfAKindMax == 3; // winning
		var l_2ofKind : Bool = l_sameOfAKindMax == 2;
		
		// if 2 of a kind, check if we have 1 or 2 pairs and the same type of card
		var l_pairs	: Array<Int> = new Array<Int>(); // store the type of the cards 
		if ( l_2ofKind ) {
			for (key in l_sameOfAKind.keys()) {
				if (  l_sameOfAKind.get(key) == 2 ) 
					l_pairs.push(Std.parseInt(key));
			}
		}

		var l_2Pairs : Bool = l_pairs.length == 2; // winning
		var l_1Pair : Bool = l_pairs.length == 1;
		var l_jacksOrBetter : Bool = l_1Pair && (l_pairs[0] == 0 || l_pairs[0] == 10 || l_pairs[0] == 11 || l_pairs[0] == 12); // winning
		
		switch( true)
		{
			case l_flush && l_royalStraight : _winningCombination = EGameWinningDeals.ROYALE_FLUSH;
			case l_4ofKind					: _winningCombination = EGameWinningDeals.FOUR_OF_KIND;
			case l_straight && l_flush		: _winningCombination = EGameWinningDeals.STRAIGHT_FLUSH;
			case l_flush					: _winningCombination = EGameWinningDeals.FLUSH;
			case l_straight					: _winningCombination = EGameWinningDeals.STRAIGHT;
			case l_3ofKind					: _winningCombination = EGameWinningDeals.THREE_OF_KIND;
			case l_2Pairs					: _winningCombination = EGameWinningDeals.TWO_PAIRS;
			case l_jacksOrBetter			: _winningCombination = EGameWinningDeals.JACKS_OR_BETTER;
		}
		return _winningCombination != EGameWinningDeals.NONE;
	}
	
//***********************************//
// PUBLIC METHODS
//***********************************//
	
	public function selectCardOnDouble(p_param:CardPositionVO) 
	{
		if ( isWinningDouble(p_param)) {
			cashInDouble *= 2;
			// winning
			_kernel.messenger.sendMessage( EMsgGameUpdate.WINNING_DOUBLE, this, false, false, true);
			_kernel.audio.start( _kernel.getConfig( "settings.audio.win" ), EAudioChannel.EFFECTS);
		}
		else if ( !isEqualDouble(p_param) && !isWinningDouble(p_param) ) { 
			_kernel.audio.start( _kernel.getConfig( "settings.audio.lost" ), EAudioChannel.EFFECTS);
			_kernel.messenger.sendMessage( EMsgGameUpdate.LOST_DEAL, this, false, false, true);
		}
		else {
			// equal 
			_kernel.messenger.sendMessage( EMsgGameUpdate.WINNING_DOUBLE, this, false, false, true);
		}
	}
	
	public function holdCard ( p_card : CardPositionVO)
	{
		_heldCards.push(p_card);
	}
	
	public function releaseCard( p_card : CardPositionVO )
	{
		if ( p_card == null ) return;
		var l_index: Int = -1;
		for ( i in 0..._heldCards.length) {
			if ( p_card.id == _heldCards[i].id) {
				l_index = i;
			}
		}
		if ( l_index != -1) {
			_heldCards.splice(l_index, 1);
		}
	}
	
	public function newDeal() 
	{
		cashInDouble = 0;
		_heldCards = new Array<CardPositionVO>();
		_roundCards = getCards(5);
		_kernel.messenger.sendMessage( EMsgGameUpdate.DEAL_CARDS_UPDATE(_roundCards), this, false, false, true);
	}
	
	public function double() 
	{
		_roundCards = getCards(5);
		_kernel.messenger.sendMessage( EMsgGameUpdate.DOUBLE_CARDS_UPDATE(_roundCards), this, false, false, true);
	}	
	
	public function draw( p_currentBet: Int ) 
	{
		var l_setOfCards = getCards((5 - _heldCards.length));
		_roundCards = _heldCards.concat(l_setOfCards);
		_kernel.messenger.sendMessage( EMsgGameUpdate.DRAW_CARDS_UPDATE(l_setOfCards), this, false, false, true);

		if ( isWinningDeal( _roundCards )) {
			cashInDouble = getGain( p_currentBet, _winningCombination) ;
			_kernel.messenger.sendMessage( EMsgGameUpdate.WINNING_DEAL(_winningCombination), this, false, false, true);
			_kernel.audio.start( _kernel.getConfig( "settings.audio.win" ), EAudioChannel.EFFECTS);
		}
		else {
			_kernel.messenger.sendMessage( EMsgGameUpdate.LOST_DEAL, this, false, false, true);
			_kernel.audio.start( _kernel.getConfig( "settings.audio.lost" ), EAudioChannel.EFFECTS);
		}
	}
}