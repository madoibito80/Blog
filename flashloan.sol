// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.10;

import "https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract MyFlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)){
        owner = payable(msg.sender);
    }

    function main(address _asset, uint256 _amount) external {
        POOL.flashLoanSimple(address(this), _asset, _amount, "0x", uint16(0));
    }

    function checkFee() external view returns (uint128) {
        return POOL.FLASHLOAN_PREMIUM_TOTAL();
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool){

        uint256 retAmount = amount + premium;
        IERC20(asset).approve(address(POOL), retAmount);
        return true;
    }

    receive() external payable {}
}
