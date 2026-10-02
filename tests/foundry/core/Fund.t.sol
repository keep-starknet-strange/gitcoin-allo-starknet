// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ds-test/test.sol";
import {Fund} from "contracts/Fund.sol";
import {IPayoutStrategy} from "contracts/interfaces/IPayoutStrategy.sol";

contract MockPayoutStrategy is IPayoutStrategy {
    function distribute() external pure override {
        // Mock implementation
    }
    
    function initialize(address) external pure override {
        // Mock implementation
    }
}

contract FundTest isDsTest {
    Fund public fund;
    MockPayoutStrategy public strategy;
    address public admin = address(0x1);
    address public user1 = address(0x2);

    function setUp() public {
        vm.startPrank(admin);
        strategy = new MockPayoutStrategy();
        fund = new Fund();
        vm.stopPrank();
    }

    function testCreateFund() public {
        vm.startPrank(admin);
        fund.createFund("Test Fund", user1, address(strategy));
        
        // Verify fund was created
        vm.stopPrank();
    }

    function testOnlyAdminCanCreateFund() public {
        vm.startPrank(user1);
        vm.expectRevert();
        fund.createFund("Unauthorized", user1, address(strategy));
        vm.stopPrank();
    }
}
