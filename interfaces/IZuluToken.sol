// SPDX-License-Identifier: GPL-3.0-or-later	
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

interface IZuluToken is IERC20Permit, IERC20 {
}
