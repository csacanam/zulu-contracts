// SPDX-License-Identifier: GPL-3.0-or-later	
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "../interfaces/IZuluToken.sol";

contract Relayer is AccessControlEnumerableUpgradeable {
	IZuluToken public zulu;

	bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
	//uint256 public constant FIXED_COST_100 = 100 * 1e18;
	uint256 public constant FIXED_COST_100 = 0;


	function initialize(
		address _defaultAdmin,
		address _firstRelayer,
		IZuluToken _zulu
	) public initializer {
		__AccessControlEnumerable_init();
		_setupRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
		_setupRole(RELAYER_ROLE, _firstRelayer);
		zulu = _zulu;
	}

	/**
	 * @notice transfer tokens to recipient using permit signature
	 * @dev permit signature will only allow the exact amount to the msg.sender
	 */
	function transferWithPermit(
		address owner,
		address recipient,
		uint256 value,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external onlyRole(RELAYER_ROLE) {
		require(
			getCost() < value,
			"The value is not enough to cover the cost and a transfer"
		);
		zulu.permit(owner, address(this), value, deadline, v, r, s);
		// Send the amount without the fee for the relayer
		zulu.transferFrom(owner, recipient, value - getCost());
		// Send the fee to the relayer
		zulu.transferFrom(owner, msg.sender, getCost());
	}

	/**
	 * @notice getCost returns the fee that is currently charged by the relayer
	 */
	function getCost() public pure returns (uint256) {
		return FIXED_COST_100;
	}
}
