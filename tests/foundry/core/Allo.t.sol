// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ds-test/test.sol";
import {Allo, IPayoutStrategy, Operation} from "contracts/Allo.sol";
import {ERC20} from "openzeppelin/token/ERC20/ERC20.sol";
import {MockDipDistribution} from "tests/foundry/core/MockDipDistribution.sol";
import {Math} from "lib/openzeppelin-contracts/contracts/utils/Math.sol";

contract AlloTest isDsTest {
    Allo public allo;
    ERC20 public token;
    MockDipDistribution public dip;
    address public admin = address(0x1);

    function setUp() public {
        vm.startPrank(admin);

        token = new ERC20("Test Token", "TST", 18);
        dip = new MockDipDistribution();

        allo = new Allo(address(token), address(dip));

        // Fund the Allo contract with tokens for test payouts
        token.mint(address(allo), 1000 * 10 ** 18);

        vm.stopPrank();
    }

    function testInitializaton() public view {
        assertEq(allo.token(), address(token));
        assertEq(allo.dip(), address(dip));
    }

    function testRejectsZeroAddressForToken() public {
        vm.expectRevert();
        new Allo(address(0), address(dip));
    }

    function testRejectsZeroAddressForDip() public {
        vm.expectRevert();
        new Allo(address(token), address(0));
    }
}
