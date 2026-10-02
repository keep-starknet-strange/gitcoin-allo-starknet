// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ds-test/test.sol";
import {Distribution} from "contracts/Distribution.sol";

contract DistributionTest isDsTest {
    Distribution public distribution;
    address public admin = address(0x1);

    function setUp() public {
        vm.startPrank(admin);
        distribution = new Distribution();
        vm.stopPrank();
    }

    function testDistribute() public {
        vm.startPrank(admin);
        // Test basic distribution logic
        vm.stopPrank();
    }
}
