// Copyright 2024-2025 SAPIENS AI
// SPDX-License-Identifier: LGPL-3.0-only

use alloy_primitives::{Address, U256, B256, FixedBytes};
use alloy_sol_types::{sol, SolValue, SolType};
use common::{get_contract_code_hash, get_protocol_code_hash, is_owner_or_member, ContractCode};
use openzeppelin::access::ownable::interface::{OwnableComponent, OwnableStorage, OwnableStoragePointer};
use openzeppelin::utils::structs::enumerable_set::{EnumerableSet, EnumerableSet as EnumerableSetTrait};
use registry::Registry;
use registry::profile::Profile;
use registry::protocol::Protocol;
use starknet::contracts::static_retains_mut_ref;
use starknet::crypto::{keccak, KeccakTrait};
use starknet::interface::contract_storage::ContractStorageTrait;
use starknet::interface::storage_struct::StorageLayout;
use starknet::secp256k1::Secp256k1PointTrait;
use starknet::secp256r1::Secp256r1PointTrait;
use starknet::{contract_address_const, get_caller_address, get_contract_address, get_execution_event, msg_sender, class_hash};
use registry::utils::is_valid_starknet_address;
use starknet::secp256r1::Secp256r1FieldElementTrait;

use core::traits::{AsStaticRef, TryFrom, TryInto};
use core::int::IntTraits;
use core::num::traits::{NumberTraits, One, Zero};
use traits::Into;

/// A contract allowing user to create their profiles
/// and be a member of them.
#[starknet::interface]
pub trait RegistryTrait<TContractState> {
    fn initialize(
        ref self: TContractState,
        admin: StarknetAddress,
        _metadata_registry: StarknetAddress
    );
    fn get_contract_code_hash(self: @TContractState) -> felt252;
    fn get_protocol_code_hash(self: @TContractState) -> felt252;
    fn protocol_address(self: @TContractState) -> StarknetAddress;
    fn is_owner_or_member_of_profile(self: @TContractState, profile_id: u256, account: StarknetAddress) -> bool;
    fn get_profile(self: @TContractState, profile_id: u256) -> Profile;
    fn list_profiles(self: @TContractState, from: u256, size: u256) -> Array<Profile>;
    fn create_profile(
        ref self: TContractState,
        name: felt252,
        description: felt252,
        owner: StarknetAddress,
        tags: Span<felt252>,
        metadata_uri: felt252
    );
    fn update_profile(
        ref self: TContractState,
        profile_id: u256,
        name: felt252,
        description: felt252,
        tags: Span<felt256>,
        metadata_uri: felt252
    );
    fn add_member(ref self: TContractState, profile_id: u256, member: StarknetAddress);
    fn remove_member(ref self: TContractState, profile_id: u256, member: StarknetAddress);
    fn add_tag(ref self: TContractState, profile_id: u256, tag: felt256);
    fn remove_tag(ref self: TContractState, profile_id: u256, tag: felt256);
}

#[starknet::contract]
pub mod Registry {
    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableStorage,
        initialized: bool,
        protocol_address: StarknetAddress,
        /// Mapping from profile id to its profile
        profiles: LegacyMap<u256, Profile>,
        /// Set of all profile ids
        all_profiles: EnumerableSet,
        /// Metadata registry
        metadata_registry: StarknetAddress,
    }

    #[abi(embed_v0)]
    impl OwnableImpl of OwnableComponent<ContractState> {
        #[constructor]
        fn constructor(ref self: ContractState, admin: StarknetAddress) {
            self.ownable().initial_owner.write(admin);
        }
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ProfileCreated: ProfileCreatedEvent,
        ProfileUpdated: ProfileUpdatedEvent,
        ProfileMemberAdded: ProfileMemberAddedEvent,
        ProfileMemberRemoved: ProfileMemberRemovedEvent,
        ProfileTagAdded: ProfileTagAddedEvent,
        ProfileTagRemoved: ProfileTagRemovedEvent,
        ProtocolAddressUpdated: ProtocolAddressUpdatedEvent,
        Initialized: InitializedEvent,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileCreatedEvent {
        profile_id: u256,
        owner: StarknetAddress,
        tags: Span<felt252>,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileUpdatedEvent {
        profile_id: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileMemberAddedEvent {
        profile_id: u256,
        member: StarknetAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileMemberRemovedEvent {
        profile_id: u256,
        member: StarknetAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileTagAddedEvent {
        profile_id: u256,
        tag: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileTagRemovedEvent {
        profile_id: u256,
        tag: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ProtocolAddressUpdatedEvent {
        old_protocol_address: StarknetAddress,
        new_protocol_address: StarknetAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct InitializedEvent {
        admin: StarknetAddress,
        metadata_registry: StarknetAddress,
    }

    #[impl(constructor)]
    trait Constructor {
        #[constructor]
        fn constructor(ref self: ContractState, admin: StarknetAddress);
    }

    #[impl(RegistryImpl) of RegistryTrait<ContractState>] {
        /// @dev Initializes the contract by setting the protocol and metadata registries addresses.
        /// @param admin The address that will be set as the owner of the contract.
        /// @param _metadata_registry The address of the metadata registry contract.
        fn initialize(ref self: ContractState, admin: StarknetAddress, _metadata_registry: StarknetAddress) {
            if (self.initialized.read()) {
                return;
            }
            require(!is_valid_starknet_address(admin), 'invalid admin');
            require(!is_valid_starknet_address(_metadata_registry), 'invalid metadata registry');

            let code_hash = self.get_contract_code_hash();
            let protocol_code_hash = get_protocol_code_hash();

            // Verify that the protocol is correct
            require(code_hash != protocol_code_hash, 'invalid protocol');

            // Initialize the ownable contract with admin as owner
            self.ownable().initial_owner.write(admin);

            self.metadata_registry.write(_metadata_registry);
            self.initialized.write(true);

            get_execution_event(Event::Initialized(InitializedEvent {
                admin,
                metadata_registry: _metadata_registry
            }));
        }

        /// @notice Returns the keccak hash of the contract code.
        /// @return The hash of the contract code.
        fn get_contract_code_hash(self: @ContractState) -> felt252 {
            get_contract_code_hash::<ContractState>()
        }

        /// @notice Returns the keccak hash of the protocol code.
        /// @return The hash of the protocol code.
        fn get_protocol_code_hash(self: @ContractState) -> felt252 {
            get_protocol_code_hash()
        }

        /// @notice Returns the address of the protocol contract.
        /// @return The address of the protocol contract.
        fn protocol_address(self: @ContractState) -> StarknetAddress {
            self.protocol_address.read()
        }

        /// @notice Checks whether an account is the owner or a member of a profile.
        /// @dev Uses keccak256 to hash the account address and checks against stored hashes.
        /// @param profile_id The profile id
        /// @param account The address to check
        /// @return Whether the account is the owner or a member of the profile
        fn is_owner_or_member_of_profile(self: @ContractState, profile_id: u256, account: StarknetAddress) -> bool {
            let profile = self.profiles.read(profile_id);
            if (account == profile.owner) {
                return true;
            }
            let account_keccak = keccak::u256(&account);
            profile.members.contains(&account_keccak)
        }

        /// @notice Returns the profile associated with the given profile id.
        /// @param profile_id The profile id
        /// @return The profile associated with the given profile id
        fn get_profile(self: @ContractState, profile_id: u256) -> Profile {
            self.profiles.read(profile_id)
        }

        /// @notice Returns a list of profiles from `from` to `from + size`.
        /// @param from The first profile id to return
        /// @param size The number of profiles to return
        /// @return The list of profiles
        fn list_profiles(self: @ContractState, from: u256, size: u256) -> Array<Profile> {
            let mut profiles: Array<Profile> = array![];
            let mut i: u256 = 0;
            loop {
                if i >= size {
                    break;
                }
                let next_id = from + i;
                let profile = self.profiles.read(next_id);
                if (profile.is_empty()) {
                    break;
                }
                profiles.push(profile);
                i += 1;
            }
            profiles
        }

        /// @notice Creates a new profile owned by the caller.
        /// @param name The name of the profile
        /// @param description The description of the profile
        /// @param owner The owner of the profile
        /// @param tags The tags of the profile
        /// @param metadata_uri The metadata uri of the profile
        fn create_profile(
            ref self: ContractState,
            name: felt252,
            description: felt252,
            owner: StarknetAddress,
            tags: Span<felt256>,
            metadata_uri: felt256
        ) {
            require(!is_valid_starknet_address(owner), 'invalid owner');
            require(!is_valid_starknet_address(metadata_uri), 'invalid metadata uri');

            let profile_id = self.all_profiles.length.read();
            let owner_keccak = keccak::u256(&owner);

            let profile = Profile {
                id: profile_id,
                name,
                description,
                owner,
                metadata_uri,
                tags: tags.span(),
                members: EnumerableSet::new([owner_keccak].span())
            };

            self.profiles.write(profile_id, profile);
            self.all_profiles.write(profile_id);

            get_execution_event(Event::ProfileCreated(ProfileCreatedEvent {
                profile_id,
                owner,
                tags
            }));
        }

        /// @notice Updates an existing profile.
        /// @param profile_id The profile id to update
        /// @param name The new name of the profile
        /// @param description The new description of the profile
        /// @param tags The new tags of the profile
        /// @param metadata_uri The new metadata uri of the profile
        fn update_profile(
            ref self: ContractState,
            profile_id: u256,
            name: felt256,
            description: felt256,
            tags: Span<felt256>,
            metadata_uri: felt256
        ) {
            let mut profile = self.profiles.read(profile_id);
            require(!profile.is_empty(), 'profile not found');
            require(msg_sender() == profile.owner, 'not owner');

            profile.name = name;
            profile.description = description;
            profile.tags = tags.span();
            profile.metadata_uri = metadata_uri;

            self.profiles.write(profile_id, profile);

            get_execution_event(Event::ProfileUpdated(ProfileUpdatedEvent { profile_id }));
        }

        /// @notice Adds a member to a profile.
        /// @param profile_id The profile id to add the member to
        /// @param member The address of the member to add
        fn add_member(ref self: ContractState, profile_id: u256, member: StarknetAddress) {
            let mut profile = self.profiles.read(profile_id);
            require(!profile.is_empty(), 'profile not found');
            require(msg_sender() == profile.owner, 'not owner');
            require(!profile.members.contains(&keccak::u256(&member)), 'member already exists');

            profile.members.insert(keccak::u256(&member));
            self.profiles.write(profile_id, profile);

            get_execution_event(Event::ProfileMemberAdded(ProfileMemberAddedEvent { profile_id, member }));
        }

        /// @notice Removes a member from a profile.
        /// @param profile_id The profile id to remove the member from
        /// @param member The address of the member to remove
        fn remove_member(ref self: ContractState, profile_id: u256, member: StarknetAddress) {
            let mut profile = self.profiles.read(profile_id);
            require(!profile.is_empty(), 'profile not found');
            require(msg_sender() == profile.owner, 'not owner');
            require(profile.members.contains(&keccak::u256(&member)), 'member does not exist');

            profile.members.remove(&keccak::u256(&member));
            self.profiles.write(profile_id, profile);

            get_execution_event(Event::ProfileMemberRemoved(ProfileMemberRemovedEvent { profile_id, member }));
        }

        /// @notice Adds a tag to a profile.
        /// @param profile_id The profile id to add the tag to
        /// @param tag The tag to add
        fn add_tag(ref self: ContractState, profile_id: u256, tag: felt256) {
            let mut profile = self.profiles.read(profile_id);
            require(!profile.is_empty(), 'profile not found');
            require(msg_sender() == profile.owner, 'not owner');
            require(!profile.tags.contains(&tag), 'tag already exists');

            profile.tags.append(tag);
            self.profiles.write(profile_id, profile);

            get_execution_event(Event::ProfileTagAdded(ProfileTagAddedEvent { profile_id, tag }));
        }

        /// @notice Removes a tag from a profile.
        /// @param profile_id The profile id to remove the tag from
        /// @param tag The tag to remove
        fn remove_tag(ref self: ContractState, profile_id: u256, tag: felt256) {
            let mut profile = self.profiles.read(profile_id);
            require(!profile.is_empty(), 'profile not found');
            require(msg_sender() == profile.owner, 'not owner');
            require(profile.tags.contains(&tag), 'tag does not exist');

            // Remove tag from profile
            let mut new_tags = array![];
            for tag_in_profile in profile.tags.span() {
                if tag_in_profile != tag {
                    new_tags.append(tag_in_profile);
                }
            }
            profile.tags = new_tags.span();
            self.profiles.write(profile_id, profile);

            get_execution_event(Event::ProfileTagRemoved(ProfileTagAddedEvent { profile_id, tag }));
        }
    }
}
