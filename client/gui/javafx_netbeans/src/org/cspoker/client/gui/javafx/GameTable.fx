/**
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
package org.cspoker.client.gui.javafx;
import javafx.ui.*;
import javafx.ui.canvas.*;
import javafx.ui.filter.*;
import java.lang.*;
import org.cspoker.client.gui.javafx.elements.TableInterface;
import org.cspoker.client.gui.javafx.elements.TableItem;
import java.rmi.RemoteException;
import org.cspoker.common.exceptions.IllegalActionException;
import org.cspoker.common.player.Player;

class GameTable {
    attribute client:JavaFxClient;
    attribute main:Main inverse Main.gametable;
    
    attribute screen:Frame;
    
    attribute players:Player*;
    attribute state:Integer;
    attribute amount:String;
    attribute events:String;
    
    attribute stateactions:WidgetArray*;
    
    operation relogin();
    
    operation startgame();
    operation deal();
    operation bet();
    operation call();
    operation check();
    operation fold();
    operation raise();
    operation allin();
    
    function eventHtml():String;
}

trigger on new GameTable{
    var padx = 50;
    var pady = 50;
    var tablex = 300;
    var tabley = 180;
    var logofontsize = (tablex+tabley)/10;
    state = 0;
    events="Welcome to CSPoker!<br/>";
    screen = Frame{
        title: "Game Table"
        width: 2*padx+tablex*2
        height: 2*pady+tabley*2+100
        visible: true
        centerOnScreen: true
        onClose: operation() {System.exit(0);}
        menubar: MenuBar {
            menus: Menu {
                text: "Options"
                mnemonic: F
                items:[
                MenuItem{
                    sizeToFitRow: true
                    text: "Logout"
                    mnemonic: L
                    action: operation() {
                        relogin();
                    }
                }]
            }
        }
        content: BorderPanel{
            center:Canvas {
                content: Group {
                    transform: []
                    content:
                        [
                        Ellipse {
                        cx: tablex+padx
                        cy: tabley+pady
                        radiusX: tablex
                        radiusY: tabley
                        fill: LinearGradient {
                            x1: 0.1, y1: 0, x2: 0.9, y2: 1
                            stops:
                                [Stop {
                                offset: 0.0
                                color: lightgreen
                            },
                            Stop {
                                offset: 1.0
                                color: green
                            }]
                            spreadMethod: PAD
                        }
                        stroke: darkgreen
                        strokeWidth: 1
                    },
                    Group{
                        content: [Text {
                            x: padx+tablex
                            y: pady+tabley
                            content: "CSPoker"
                            font: new Font("Tahoma", "BOLD", logofontsize)
                            stroke: darkorange
                            fill: orange
                            strokeWidth: 2
                            opacity: 0.25
                            valign: CENTER
                            halign: CENTER
                        }]
                    },
                    Group{
                        transform:[]
                        content:[
                        
                        ]
                    }
                    ]
                }
                background: black
            }
            bottom: BorderPanel{
                center:GroupPanel{
                    var singleRow= Row{alignment: BASELINE}
                    
                    var buttonsColumn= Column{ alignment:TRAILING}
                    var chatColumn= Column {alignment:LEADING resizable:true }
                    
                    rows: [singleRow]
                    columns: [buttonsColumn,chatColumn]
                    
                    content:[
                    FlowPanel{
                        row: singleRow
                        column: buttonsColumn
                        content: bind stateactions[state].widgets
                    },
                    TextField{
                        row: singleRow
                        column: chatColumn
                        value: "chat"
                    }]
                }
            }
        }
    };
    stateactions = [
    WidgetArray{
        widgets: [Button {
            text: "Start Game"
            toolTipText: "Start the game at this table."
            action: operation() {
                startgame();
            }
        }]},
        WidgetArray{
        widgets: [
        Button {
            text: "Deal"
            toolTipText: "Deal"
            action: operation() {
                deal();
            }
        }
        ]},
        WidgetArray{
        widgets: [
        TextField{
            value: bind amount
            columns: 5
        },Button {
            text: "Bet"
            toolTipText: "Bet the entered amount"
            action: operation() {
                bet();
            }
        },Button {
            text: "Check"
            toolTipText: "Check"
            action: operation() {
                check();
            }
        },Button {
            text: "Call"
            toolTipText: "Call"
            action: operation() {
                call();
            }
        },Button {
            text: "Fold"
            toolTipText: "Fold"
            action: operation() {
                fold();
            }
        },Button {
            text: "Raise"
            toolTipText: "Raise"
            action: operation() {
                raise();
            }
        },Button {
            text: "All In"
            toolTipText: "Go All In"
            action: operation() {
                allin();
            }
        }
        ]}];
}

operation GameTable.relogin(){
    //TODO fix
    main.relogin();
}

operation GameTable.startgame(){
    try{
        client.startGame();
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to start game"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.bet(){
    try{
        client.bet(amount);
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to bet {amount}"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.call(){
    try{
        client.call();
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to bet {amount}"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.fold(){
    try{
        client.fold();
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to bet {amount}"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.check(){
    try{
        client.check();
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to bet {amount}"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.raise(){
    try{
        client.raise(amount);
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to raise {amount}"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.deal(){
    try{
        client.deal();
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to deal"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

operation GameTable.allin(){
    try{
        client.allIn();
    }catch(e:RemoteException){
        relogin();
    }catch(e:IllegalActionException){
        MessageDialog{
            title: "Failed to go all in"
            visible: true
            message: e.getMessage()
            messageType: ERROR
        }
    }
}

function GameTable.eventHtml():String{
    return "<html><body>{events}</body></html>";
}