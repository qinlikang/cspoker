package org.cspoker.client.gui.swt.control;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.NavigableMap;
import java.util.Map.Entry;

import org.cspoker.common.elements.pots.Pots;
import org.cspoker.common.elements.table.Table;
import org.cspoker.common.events.gameevents.playeractionevents.ActionChangedPotEvent;
import org.cspoker.common.events.gameevents.playeractionevents.BigBlindEvent;
import org.cspoker.common.player.SeatedPlayer;

/**
 * The game state at a table
 * 
 * @author Stephan Schmidt
 */
public class GameState {
	
	/**
	 * Table snapshot retrieved from the server upon initialization (for
	 * GameProperty Info etc.)
	 */
	private Table tableMemento;
	private Pots pots;
	private List<NavigableMap<Chip, Integer>> currentBetPile = new ArrayList<NavigableMap<Chip, Integer>>();
	
	public List<NavigableMap<Chip, Integer>> getCurrentBetPile() {
		return currentBetPile;
	}
	
	private int moneyInMiddle;
	
	public void setMoneyInMiddle(int moneyInMiddle) {
		this.moneyInMiddle = moneyInMiddle;
	}
	
	private SeatedPlayer user;
	
	public GameState(Table table) {
		setTableMemento(table);
		pots = new Pots(0);
		currentBetPile = new ArrayList<NavigableMap<Chip, Integer>>();
	}
	
	/**
	 * @return the tableMemento
	 */
	public Table getTableMemento() {
		return tableMemento;
	}
	
	/**
	 * @param tableMemento the tableMemento to set
	 */
	public void setTableMemento(Table tableMemento) {
		this.tableMemento = tableMemento;
	}
	
	/**
	 * @return the pots
	 */
	public Pots getPots() {
		return pots;
	}
	
	/**
	 * @param pots the pots to set
	 */
	public void setPots(Pots pots) {
		this.pots = pots;
	}
	
	public int getToCallAmount() {
		return getValue(currentBetPile) - user.getBetChipsValue();
	}
	
	public int getMinRaiseAmount() {
		return Math.max(0, Math.min(user.getStackValue() - getToCallAmount(), Math.max(getMinBetAmount(),
				getToCallAmount())));
	}
	
	public int getMinBetAmount() {
		return Math.max(0, Math.min(user.getStackValue() - getToCallAmount(), tableMemento.getGameProperty()
				.getBigBlind()));
	}
	
	public int getPotRaiseAmount() {
		return Math.max(0, Math.min(user.getStackValue() - getToCallAmount(), getToCallAmount()
				+ getPots().getTotalValue()));
	}
	
	public void newRound(String roundName) {
		if (roundName.equalsIgnoreCase("pre-flop round")) {
			setPots(new Pots(0));
		}
		currentBetPile.clear();
		moneyInMiddle = getPots().getTotalValue();
	}
	
	public int getMoneyInMiddle() {
		return moneyInMiddle;
	}
	
	public static int getValue(List<NavigableMap<Chip, Integer>> chipPiles) {
		int amount = 0;
		for (Map<Chip, Integer> chips : chipPiles) {
			for (Entry<Chip, Integer> chipEntry : chips.entrySet()) {
				amount += chipEntry.getKey().getValue() * chipEntry.getValue();
			}
		}
		return amount;
	}
	
	/**
	 * TODO Adjust when more game types are supported
	 * 
	 * @return number of hole cards dealt to each player in this game type
	 */
	public int getNumberOfHoleCards() {
		return 2;
	}
	
	public List<NavigableMap<Chip, Integer>> addToCurrentBetPile(ActionChangedPotEvent e) {
		
		int lastBetRaiseAmount = Math.max(0, e.getPlayer().getBetChipsValue() - getValue(currentBetPile));
		// Draw big blind on top of small blind value
		if (e instanceof BigBlindEvent) {
			currentBetPile.clear();
			currentBetPile.add(Chip.getDistribution(lastBetRaiseAmount * 2));
		} else {
			currentBetPile.add(Chip.getDistribution(lastBetRaiseAmount));
		}
		
		return currentBetPile;
		
	}
	
	public void setUser(SeatedPlayer playerToAct) {
		user = playerToAct;
		
	}
	
	public SeatedPlayer getUser() {
		return user;
	}
}
