/* eslint-disable @typescript-eslint/naming-convention */

export type DevProductPurchaseEvent = (receiptInfo: ReceiptInfo, player: Player) => void;

export const developerProducts: Record<number, DevProductPurchaseEvent> = {
	// DO NOT YIELD WHEN MODIFYING PLAYER DATA
	// Example:
	/**
	 *  12345: (receiptInfo: ReceiptInfo) => {
	 *      const playerId = tostring(receiptInfo.PlayerId);
	 *      store.addClick(playerId, 1000);
	 *  },
	 */
};
