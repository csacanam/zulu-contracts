// SPDX-License-Identifier: GPL-3.0-or-later	
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ZuluToken is
	AccessControlEnumerable,
	ERC20Burnable,
	ERC20Permit
{
	// Roles
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

	modifier notThisAddress(address account) {
		require(
			account != address(this),
			"Address can not be the token contract's address"
		);
		_;
	}

	constructor(
		address defaultAdmin,
		address minter)
        ERC20("Zulu COP", "ZCOP") ERC20Permit("ZuluCopToken") {
		_setupRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
		_setupRole(MINTER_ROLE, minter);

	}

	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
	 * the total supply.
	 *
	 * Emits a {Transfer} event with `from` set to the zero address.
	 *
	 * Requirements:
	 *
	 * - `account` cannot be the zero address.
	 * - `msg.sender` should have the minter role (MINTER_ROLE).
	 */
	function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
		_mint(to, amount);
	}

	/**
	 * @dev See {IERC20-transfer}.
	 *
	 * Requirements:
	 *
	 * - `recipient` cannot be the zero address.
	 * - the caller must have a balance of at least `amount`.
	 */
	function transfer(address recipient, uint256 amount)
		public
		virtual
		override(ERC20)
		notThisAddress(recipient)
		returns (bool)
	{
		return super.transfer(recipient, amount);
	}

	/**
	 * @dev See {IERC20-transferFrom}.
	 *
	 * Emits an {Approval} event indicating the updated allowance. This is not
	 * required by the EIP. See the note at the beginning of {ERC20}.
	 *
	 * Requirements:
	 *
	 * - `sender` and `recipient` cannot be the zero address.
	 * - `sender` must have a balance of at least `amount`.
	 * - the caller must have allowance for ``sender``'s tokens of at least
	 * `amount`.
	 */
	function transferFrom(
		address sender,
		address recipient,
		uint256 amount
	)
		public
		virtual
		override(ERC20)
		notThisAddress(recipient)
		returns (bool)
	{
		return super.transferFrom(sender, recipient, amount);
	}

}
