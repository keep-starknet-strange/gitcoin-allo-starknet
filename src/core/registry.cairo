use starknet::{ContractAddress, get_caller_address, get_contract_address, contract_address_const};

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
    fn updateProfileMetadata (ref self: TContractState, _profileId: u256, _metadata: Registry::Metadata);
}

#[starknet::contract]
pub mod Registry {
    use starknet::{ContractAddress, get_caller_address};

    // ==========================
    // === Storage Variables ====
    // ==========================
    #[storage]
    struct Storage {
        profilesById: LegacyMap::<u256, Profile>,  
        metadata: Metadata,    
    }

    #[derive(Drop, Serde, starknet::Store)]
    pub struct Metadata {
        protocol: u256,
        pointer: felt252,
    }
    
    #[derive(Drop, Serde, starknet::Store)]
    pub struct Profile {
        nonce: u256,
        name: felt252,
        metadata: Metadata,
        owner: ContractAddress,
        members: ContractAddress,

    }

    /// ======================
    /// ======= Events =======
    /// ======================
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ProfileMetadataUpdated: ProfileMetadataUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileMetadataUpdated{
        #[key]
        _profileId: u256,
        _metadata: Metadata,
    }
    


    #[constructor]
    fn constructor(ref self: ContractState) { // Issue no #19
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L78C40-L79C9
    // Implement the functionality of making sure the address is not zero and
    // grant the Allo owner role to the owner.
    // You can use the posiedon hashing for hasing storing Allo owner
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

    fn updateProfileMetadata(ref self: ContractState, _profileId: u256, _metadata: Metadata) {
        let msg_sender = get_caller_address();
        let caller = self.Profile.owner.read();
        assert( caller == msg_sender, 'Not profile owner');
        self.Profile.Metadata.write(_metadata);

        self.emit(ProfileMetadataUpdated{_profileId, _metadata});        
    } 
    // Issue no. #9 Implement the functionality of UpdateProfilePendingOwner
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L253

    // Issue no. #8 Implement the functionality of acceptProfileOwnership
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L267

    // Issue no. #7 Implement the functionality of addMembers
    // Use u256 instead of bytes32
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L289

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

    // Issue no. #17 Implement the functionality of _checkOnlyProfileOwner
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L331

    // Issue no. #4 Implement the functionality of _generateProfileId
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L375C14-L375C31

    // Issue no. #3 Implement the functionality of _isOwnerOfProfile
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L375C14-L375C31

    // Issue n. #5 Implement the functionality of _isMemberOfProfile
    // Down below is the function that is to be implemented in the contract but in cairo.
    // https://github.com/allo-protocol/allo-v2/blob/4dd0ea34a504a16ac90e80f49a5570b8be9b30e9/contracts/core/Registry.sol#L384C14-L384C32

    }
}
