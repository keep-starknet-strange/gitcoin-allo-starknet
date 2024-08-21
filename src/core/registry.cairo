use starknet::{ContractAddress, get_caller_address, get_contract_address, contract_address_const};

#[derive(Drop, Serde, starknet::Store)]
struct Metadata {
    protocol: u256,
    pointer: ByteArray,
}


// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⢿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⡟⠘⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⣾⠻⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⡿⠀⠀⠸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⠀⠀⢀⣠⣴⣴⣶⣶⣶⣦⣦⣀⡀⠀⠀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⡿⠃⠀⠙⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠁⠀⠀⠀⢻⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡀⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠘⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⠃⠀⠀⠀⠀⠈⢿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⣰⣿⣿⣿⡿⠋⠁⠀⠀⠈⠘⠹⣿⣿⣿⣿⣆⠀⠀⠀
// ⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⢰⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⡀⠀⠀
// ⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣟⠀⡀⢀⠀⡀⢀⠀⡀⢈⢿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡇⠀⠀
// ⠀⠀⣠⣿⣿⣿⣿⣿⣿⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡿⢿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣿⣿⣿⣷⡀⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠸⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠂⠀⠀
// ⠀⠀⠙⠛⠿⠻⠻⠛⠉⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣧⠀⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⢻⣿⣿⣿⣷⣀⢀⠀⠀⠀⡀⣰⣾⣿⣿⣿⠏⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣧⠀⠀⢸⣿⣿⣿⣗⠀⠀⠀⢸⣿⣿⣿⡯⠀⠀⠀⠀⠹⢿⣿⣿⣿⣿⣾⣾⣷⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀
// ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠙⠋⠛⠙⠋⠛⠙⠋⠛⠙⠋⠃⠀⠀⠀⠀⠀⠀⠀⠀⠠⠿⠻⠟⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠟⠿⠟⠿⠆⠀⠸⠿⠿⠟⠯⠀⠀⠀⠸⠿⠿⠿⠏⠀⠀⠀⠀⠀⠈⠉⠻⠻⡿⣿⢿⡿⡿⠿⠛⠁⠀⠀⠀⠀⠀⠀
//                    allo.gitcoin.co

/// Registry contract
/// Solidity equivalent: https://github.com/allo-protocol/allo-v2/blob/main/contracts/core/Registry.sol

/// Registry contract interface
/// Interface for the Registry contract.
#[starknet::interface]
pub trait IRegistry<TContractState> {
    fn is_owner_of_profile(self: @TContractState, profile_id: u256, owner: ContractAddress) -> bool;
    fn update_profile_pending_owner(
        ref self: TContractState, profile_id: u256, pending_owner: ContractAddress
    );
    fn add_members(ref self: TContractState, profile_Id: u256, members: Array<ContractAddress>);
    fn update_profile_metadata(ref self: TContractState, profile_id: u256, metadata: Metadata);
}
#[starknet::contract]
pub mod Registry {
    use alexandria_encoding::sol_abi::encode::SolAbiEncodeTrait;
    use alexandria_bytes::{Bytes, BytesTrait};
    use starknet::ContractAddress;
    use core::poseidon::PoseidonTrait;
    use core::hash::HashStateTrait;
    use allo::core::libraries::errors::Errors;
    use openzeppelin::access::accesscontrol::AccessControlComponent;
    use openzeppelin::introspection::src5::SRC5Component;
    use starknet::{get_caller_address, contract_address_const};
    use super::{Metadata};

    component!(path: SRC5Component, storage: SRC5_supported_interfaces, event: SRC5ComponentEvent);

    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    component!(
        path: AccessControlComponent, storage: accessControl, event: AccessControlComponentEvent
    );

    #[abi(embed_v0)]
    impl AccessControlComponentImpl =
        AccessControlComponent::AccessControlImpl<ContractState>;
    impl AccessControlComponentInternalImpl = AccessControlComponent::InternalImpl<ContractState>;

    // ==========================
    // === Structs ==============
    // ==========================

    #[derive(Drop, starknet::Event)]
    struct ProfileMetadataUpdated {
        #[key]
        profile_id: u256,
        metadata: Metadata,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Profile {
        id: u256,
        nonce: u256,
        name: ByteArray,
        metadata: Metadata,
        owner: ContractAddress,
        anchor: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfilePendingOwnerUpdated {
        #[key]
        profile_id: u256,
        pending_owner: ContractAddress,
    }

    // ==========================
    // === Storage Variables ====
    // ==========================
    #[storage]
    struct Storage {
        profiles_by_id: LegacyMap<u256, Profile>,
        #[substorage(v0)]
        SRC5_supported_interfaces: SRC5Component::Storage,
        #[substorage(v0)]
        accessControl: AccessControlComponent::Storage,
        anchor_to_profile_id: LegacyMap<ContractAddress, u256>,
        profile_id_to_pending_owner: LegacyMap<u256, ContractAddress>,
        member_length: u256
    }

    /// ======================
    /// ======= Events =======
    /// ======================
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        SRC5ComponentEvent: SRC5Component::Event,
        #[flat]
        AccessControlComponentEvent: AccessControlComponent::Event,
        ProfilePendingOwnerUpdated: ProfilePendingOwnerUpdated,
        ProfileMetadataUpdated: ProfileMetadataUpdated
    }


    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        assert(_owner.into() == 0, Errors::ZERO_ADDRESS);

        let allo_owner_role = PoseidonTrait::new().update('ALLO_OWNER').finalize();

        self.accessControl.initializer();
        self.accessControl._grant_role(allo_owner_role, _owner)
    }


    /// ====================================
    /// ==== External/Public Functions =====
    /// ====================================
    #[abi(embed_v0)]
    impl Registry of super::IRegistry<
        ContractState
    > { // Issue no. #15 Implement the functionality to retrieve profile by profileId
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L94
        // Use _profileID as u256 

        // Issue no. #14 Implement the functionality to retrieve profile by anchor
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L102

        // Issue no. #13 Implement the functionality of createProfile
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L118C5-L125C18

        // Issue no. #12 Implement the functionality of updateProfileName
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L182C14-L182C31

        // Issue no. #11 Implement the functionality of updateProfileMetadata
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L214C14-L214C35

        fn update_profile_metadata(ref self: ContractState, profile_id: u256, metadata: Metadata) {
            // Get the address of the caller
            let caller = get_caller_address();
            // Ensure the caller is the owner of the profile
            assert(self._is_owner_of_profile(profile_id, caller), 'Not profile owner');

            // Read the profile from storage
            let mut profile = self.profiles_by_id.read(profile_id);

            // Update the profile's metadata with the new protocol and pointer
            profile
                .metadata =
                    Metadata {
                        protocol: metadata.protocol,
                        pointer: metadata
                            .pointer
                            .clone(), //// Clone the pointer to prevent move errors
                    };

            // Write the updated profile back to storage
            self.profiles_by_id.write(profile_id, profile);

            //ProfileMetaDataUpdated Event Emit
            self.emit(ProfileMetadataUpdated { profile_id, metadata });
        }

        // Issue no. #10 Implement the functionality of isOwnerOrMemberOfProfile
        // Use u256 instead of bytes32
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L229

        // Issue no. #3 Implement the functionality of isOwnerOfProfile
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L245

        fn is_owner_of_profile(
            self: @ContractState, profile_id: u256, owner: ContractAddress
        ) -> bool {
            return self._is_owner_of_profile(profile_id, owner);
        }
        // Issue no. #5 Implement the functionality of isMemberOfProfile
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L245

        // Issue no. #9 Implement the functionality of UpdateProfilePendingOwner
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L253
        fn update_profile_pending_owner(
            ref self: ContractState, profile_id: u256, pending_owner: ContractAddress
        ) {
            let caller = get_caller_address();
            assert(self._is_owner_of_profile(profile_id, caller), 'Not profile owner');

            self.profile_id_to_pending_owner.write(profile_id, pending_owner);

            self.emit(ProfilePendingOwnerUpdated { profile_id, pending_owner, });
        }
        // Issue no. #8 Implement the functionality of acceptProfileOwnership
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L267

        // Issue no. #7 Implement the functionality of addMembers
        // Use u256 instead of bytes32
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L289
        fn add_members(ref self: ContractState, profile_Id: u256, members: Array<ContractAddress>) {
            let profile_id: felt252 = profile_Id.try_into().unwrap();
            self.member_length.write(members.len().into());
            let mut i = 0;
            loop {
                if (i >= members.len().into()) {
                    break;
                }
                let member: ContractAddress = *members.at(i);
                assert(member != contract_address_const::<0>(), 'Error:ZERO_ADDRESS');
                self.accessControl._grant_role(profile_id, member);
                i += 1;
            }
        }
    // Issue no. #6 Implement the functionality of removeMembers
    // Use u256 instead of bytes32
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L311

    // Issue no. #16 Implement the functionality of recoverFunds
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L392C14-L392C26

    }

    /// ====================================
    /// ==== Internal Functions ============
    /// ====================================
    #[generate_trait]
    impl RegistryInternalImpl of RegistryInternalTrait { // Issue no. #19 Implement the functionality of _generateProfileId
        // Internal function to create a profile
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L366
        // Reference on how to implement keccak256(abi.encodePacked) 
        // Solidity - https://github.com/celestiaorg/blobstream-contracts/blob/0b4bcf69d1ce96df000da7f95fba8c03aa15a45e/src/lib/tree/namespace/TreeHasher.sol#L33
        // Cairo - https://github.com/keep-starknet-strange/blobstream-starknet/blob/b74777e5fb479e5b4aa5a1419135e0826343fc37/src/tree/namespace/hasher.cairo#L10
        // More about it - https://github.com/keep-starknet-strange/alexandria/tree/main/src/encoding

        // Issue no. #18 Implement the functionality of _generateAnchor
        // Internal function to create a _generateAnchor
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L340
        fn _generateProfileId(_nonce: u256, owner: ContractAddress) -> u256 {
            let profileId = BytesTrait::new_empty()
                .encode_packed(_nonce)
                .encode_packed(owner)
                .keccak();
            return profileId;
        }
        // Issue no. #17 Implement the functionality of _checkOnlyProfileOwner
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L331

        // Issue no. #4 Implement the functionality of _generateProfileId
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L375C14-L375C31

        // Issue no. #3 Implement the functionality of _isOwnerOfProfile
        // Down below is the function that is to be implemented in the contract but in cairo.
        // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L375C14-L375C31

        fn _is_owner_of_profile(
            self: @ContractState, _profile_id: u256, _owner: ContractAddress
        ) -> bool {
            return self.profiles_by_id.read(_profile_id).owner == _owner;
        }
    // Issue n. #5 Implement the functionality of _isMemberOfProfile
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L384C14-L384C32

    }
}
