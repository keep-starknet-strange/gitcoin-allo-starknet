// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ds-test/test.sol";
import {Funding} from "contracts/Funding.sol";

contract FundingTest isDsTest {
    Funding public funding;
    address public admin = address(0x1);
    address public user1 = address(0x2);

    function setUp() public {
        vm.startPrank(admin);
        funding = new Funding();
        vm.stopPrank();
    }

    function testAddFunding() public {
        vm.startPrank(admin);
        funding.addFunding(1, user1, 1000);
        
        // Verify funding was added
        vm.stopPrank();
    }

    function testOnlyAdminCanAddFunding() public {
        vm.startPrank(user1);
        vm.expectRevert();
        funding.addFunding(1, user1, 1000);
        vm.stopPrank();
    }
}
