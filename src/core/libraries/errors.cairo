use starknet::{ContractAddress, contract_address_const};

pub mod Errors {
    /// Throws as an general error when input / data is invalid.
    const INVALID: felt252 = 'Data is invalid';
    /// Thrown when mismatch in decoding data.
    const MISMATCH: felt252 = 'Mismatch in decoding data';
    /// Thrown when not enough funds are available
    const NOT_ENOUGH_FUNDS: felt252 = 'Not enough funds available';
    /// Thrown when user is not authorized
    pub const UNAUTHORIZED: felt252 = 'Not authorized';
    // // /// Thrown when address is the zero address
    // const ZERO_ADDRESS : ContractAddress = contract_address_const::<'0'>();
    /// Thrown when the function is not implemented
    const NOT_IMPLEMENTED: felt252 = 'Not implemented';
    /// Thrown when the value is non-zero
    const NON_ZERO_VALUE: felt252 = 'Non Zero Value';

    /// ======================
    /// ====== Registry ======
    /// ======================

    /// Thrown when the nonce passed has been used or not available
    const NONCE_NOT_AVAILABLE: felt252 = 'Nonce not available';
    /// Thrown when the 'msg.sender' is not the pending owner on ownership transfer
    const NOT_PENDING_OWNER: felt252 = 'Not pending owner';
    /// Thrown if the anchor creation fails
    const ANCHOR_ERROR: felt252 = 'Anchor error';


    /// ======================
    /// ======== Allo ========
    /// ======================

    /// Thrown when the strategy is not approved
    const NOT_APPROVED_STRATEGY: felt252 = 'Not approved strategy';
    /// Thrown when the strategy is approved and should be cloned
    const IS_APPROVED_STRATEGY: felt252 = 'Is approved strategy';
    /// Thrown when the fee is below 1e18 which is the fee percentage denominator
    const INVALID_FEE: felt252 = 'Invalid fee';

    /// ======================
    /// ===== IStrategy ======
    /// ======================

    /// Thrown when data is already intialized
    const ALREADY_INITIALIZED: felt252 = 'Already initialized';
    /// Thrown when data is yet to be initialized
    const NOT_INITIALIZED: felt252 = 'Not initialized';
    /// Thrown when an invalid address is used
    const INVALID_ADDRESS: felt252 = 'Invalid address';
    /// Thrown when a pool is inactive
    const POOL_INACTIVE: felt252 = 'Pool inactive';
    /// Thrown when a pool is already active
    const POOL_ACTIVE: felt252 = 'Pool active';
    /// Thrown when two arrays length are not equal
    const ARRAY_MISMATCH: felt252 = 'Array mismatch';
    /// Thrown when the registration is invalid.
    const INVALID_REGISTRATION: felt252 = 'Invalid registration';
    /// Thrown when the metadata is invalid.
    const INVALID_METADATA: felt252 = 'Invalid metadata';
    /// Thrown when the recipient is not accepted.
    const RECIPIENT_NOT_ACCEPTED: felt252 = 'Recipient not accepted';
    /// Thrown when recipient is already accepted.
    const RECIPIENT_ALREADY_ACCEPTED: felt252 = 'Recipient already accepted';
    /// Thrown when registration is not active.
    const REGISTRATION_NOT_ACTIVE: felt252 = 'Registration not active';
    /// Thrown when registration is active.
    const REGISTRATION_ACTIVE: felt252 = 'Registration active';
    /// Thrown when there is an error in recipient.
    const RECIPIENT_ERROR: felt252 = 'Recipient error';
    /// Thrown when the allocation is not active.
    const ALLOCATION_NOT_ACTIVE: felt252 = 'Allocation not active';
    /// Thrown when the allocation is not ended.
    const ALLOCATION_NOT_ENDED: felt252 = 'Allocation not ended';
    /// Thrown when the allocation is active.
    const ALLOCATION_ACTIVE: felt252 = 'Allocation active';
}
