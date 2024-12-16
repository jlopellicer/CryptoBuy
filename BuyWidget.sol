// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Backend buy process for apps
/// @author Jorge López Pellicer
/// @dev https://www.linkedin.com/in/jorge-lopez-pellicer/

interface IERC20 {
    /**
     * @dev Interface for ERC20 `transferFrom` function, which allows transferring tokens
     * from one account (`sender`) to another (`recipient`) on behalf of the caller.
     * The function must return `true` if the transfer is successful.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BuyWidget {
   
    // Boolean variable to implement the non-reentrancy mechanism.
    bool locked;

    /**
     * @dev Event emitted when a payment is successfully processed.
     * @param from Address of the sender.
     * @param to Address of the recipient.
     * @param amount Amount of ETH or tokens transferred.
     * @param isToken Boolean indicating whether the payment was made with a token (true) or ETH (false).
     */
    event Buy(address indexed from, address indexed to, uint256 amount, bool isToken);

    /**
     * @dev Modifier to prevent reentrancy attacks.
     * Ensures that a function cannot be called again until the first execution is complete.
     */
    modifier nonReentrant() {
        require(!locked, "No reentrancy"); // Prevents reentrancy if the function is already locked.
        locked = true; // Locks the function to prevent nested calls.
        _; // Executes the rest of the function.
        locked = false; // Unlocks the function after execution is complete.
    }

    /**
     * @dev Sends ETH to a specified recipient address.
     * Emits the `Buy` event upon successful transfer.
     * 
     * @param _to Address of the recipient (must be a payable address).
     */
    function sendPayment(
        address payable _to
    ) external payable nonReentrant {
        require(_to != address(0), "Receiver cannot be null"); // Ensures the recipient address is valid.

        // Executes the transfer of ETH using a low-level `call` to prevent reentrancy risks.
        (bool success, ) = _to.call{value: msg.value}("");
        require(success, "ETH transfer failed"); // Reverts if the transfer fails.

        // Emits the Buy event with transfer details.
        emit Buy(msg.sender, _to, msg.value, false);
    }

    /**
     * @dev Sends tokens from the caller to a specified recipient address.
     * Requires prior approval of the token allowance for this contract.
     * Emits the `Buy` event upon successful transfer.
     * 
     * @param _tokenAddress Address of the ERC20 token contract.
     * @param _to Address of the recipient.
     * @param _amount Amount of tokens to transfer (must be greater than 0).
     */
    function sendPaymentWithToken(
        address _tokenAddress,
        address _to,
        uint256 _amount
    ) external nonReentrant {
        require(_tokenAddress != address(0), "Invalid token address"); // Ensures the token contract address is valid.
        require(_to != address(0), "Receiver cannot be null"); // Ensures the recipient address is valid.
        require(_amount > 0, "Amount must be greater than 0"); // Validates that the amount is greater than 0.

        // Creates an instance of the ERC20 token contract.
        IERC20 token = IERC20(_tokenAddress);

        // Transfers the specified amount of tokens from the sender to the recipient.
        require(token.transferFrom(msg.sender, _to, _amount), "Token transfer failed");

        // Emits the Buy event with transfer details.
        emit Buy(msg.sender, _to, _amount, true);
    }
}