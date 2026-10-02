// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ds-test/test.sol";
import {Registry} from "contracts/Registry.sol";

contract RegistryTest isDsTest {
    Registry public registry;
    address public admin = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);

    function setUp() public {
        vm.startPrank(admin);
        registry = new Registry();
        vm.stopPrank();
    }

    function testAddScheme() public {
        vm.startPrank(admin);
        registry.addScheme(1, "Test Scheme");
        
        (uint256 id, string memory name) = registry.schemes(1);
        assertEq(id, 1);
        assertEq(name, "Test Scheme");
        vm.stopPrank();
    }

    function testRejectsZeroName() public {
        vm.startPrank(admin);
        vm.expectRevert();
        registry.addScheme(1, "");
        vm.stopPrank();
    }

    function testOnlyAdminCanAddScheme() public {
        vm.startPrank(user1);
        vm.expectRevert();
        registry.addScheme(1, "Unauthorized");
        vm.stopPrank();
    }

    function testUpdateScheme() public {
        vm.startPrank(admin);
        registry.addScheme(1, "Old Name");
        registry.updateScheme(1, "New Name");
        
        (uint256 id, string memory name) = registry.schemes(1);
        assertEq(id, 1);
        assertEq(name, "New Name");
        vm.stopPrank();
    }

    function testRemoveScheme() public {
        vm.startPrank(admin);
        registry.addScheme(1, "Test Scheme");
        registry.removeScheme(1);
        
        (uint256 id, ) = registry.schemes(1);
        assertEq(id, 0);
        vm.stopPrank();
    }
}
