# BuyWidget Smart Contract

## Overview

The **BuyWidget** smart contract is designed to facilitate secure payments in Ethereum or ERC20 tokens between users. It supports the prevention of reentrancy attacks and emits events for transaction tracking. This contract can be integrated with frontend applications for e-commerce, service payments, or other decentralized use cases.

---

## Features

- **ETH Payments:** Send ETH to a specified recipient securely.
- **ERC20 Token Payments:** Transfer ERC20 tokens to a specified recipient.
- **Reentrancy Protection:** Prevents reentrancy attacks using the `nonReentrant` modifier.
- **Event Logging:** Emits a `Buy` event on every successful transaction for easy tracking.

---

## Contract Details

### Functions

1. **sendPayment**
   - Transfers ETH to the recipient.
   - Emits a `Buy` event after a successful transfer.
   - Requires:
     - `_to` cannot be the zero address.
     - `msg.value` must be greater than 0.
   - **Usage Example:**
     ```solidity
     buyWidget.sendPayment{value: 1 ether}(recipientAddress);
     ```

2. **sendPaymentWithToken**
   - Transfers ERC20 tokens to the recipient.
   - Requires prior approval of token allowance for this contract.
   - Emits a `Buy` event after a successful transfer.
   - Requires:
     - `_tokenAddress` must be a valid ERC20 token contract.
     - `_to` cannot be the zero address.
     - `_amount` must be greater than 0.
   - **Usage Example:**
     ```solidity
     buyWidget.sendPaymentWithToken(tokenAddress, recipientAddress, 100 * 10**18);
     ```

### Events

- **Buy**: Logs details of each transaction.
  - `from`: Address of the sender.
  - `to`: Address of the recipient.
  - `amount`: Amount transferred (ETH or tokens).
  - `isToken`: Boolean indicating whether the payment was in tokens (`true`) or ETH (`false`).

### Modifiers

- **nonReentrant**
  - Prevents reentrant calls to critical functions, ensuring security against attack vectors.

---

## How to Use

### 1. Deploy the Contract
Deploy the contract on the desired Ethereum network (e.g., Mainnet, Goerli, Polygon, etc.) using tools like Remix, Hardhat, or Truffle.

### 2. Integrate with Your Application
Connect the contract with your frontend application using libraries like [ethers.js](https://docs.ethers.org/) or [web3.js](https://web3js.readthedocs.io/).

### 3. Handle Transactions
Use the `sendPayment` function for ETH payments or `sendPaymentWithToken` for token payments. Ensure users have sufficient balance and approvals in the case of token payments.

---

## Security Considerations

1. **Reentrancy Protection**: 
   - The contract uses a `nonReentrant` modifier to prevent reentrancy attacks.

2. **Validation of Recipient (`_to`)**:
   - Ensure the recipient address is correct when making payments.

3. **Approval for Token Transfers**:
   - For ERC20 payments, the sender must approve the contract to spend the specified token amount before calling `sendPaymentWithToken`.

4. **Gas Limit**:
   - Be cautious of gas limits when sending ETH payments. Certain contracts may reject `call` operations with insufficient gas.

---

## Development

### Prerequisites
- Solidity `^0.8.0`
- Node.js and npm for testing/deployment tools (e.g., Hardhat or Truffle)

### Testing
Run tests to ensure the contract behaves as expected:
```bash
npx hardhat test
