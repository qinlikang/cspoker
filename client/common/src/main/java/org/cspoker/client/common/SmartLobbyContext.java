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
package org.cspoker.client.common;

import java.rmi.RemoteException;

import net.jcip.annotations.Immutable;

import org.cspoker.common.api.lobby.context.ForwardingRemoteLobbyContext;
import org.cspoker.common.api.lobby.context.RemoteLobbyContext;
import org.cspoker.common.api.lobby.holdemtable.listener.HoldemTableListener;
import org.cspoker.common.api.shared.exception.IllegalActionException;

@Immutable
public class SmartLobbyContext extends ForwardingRemoteLobbyContext {

	public SmartLobbyContext(RemoteLobbyContext lobbyContext) {
		super(lobbyContext);
	}
	
	@Override
	public SmartHoldemTableContext joinHoldemTable(long tableId,
			HoldemTableListener holdemTableListener) throws RemoteException,
			IllegalActionException {
		SmartHoldemTableListener smartListener = new SmartHoldemTableListener(holdemTableListener);
		return new SmartHoldemTableContext(super.joinHoldemTable(tableId, smartListener),smartListener);
	}

}
