/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    /* State variables
     */

    mapping (address => uint) private balances;
    
    mapping (address => bool) public enrolled;

    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */
    
    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amount);

    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /* Functions
     */

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
      enrolled[msg.sender] = true;

      emit LogEnrolled(msg.sender);

      return true;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {    
      // Sender should be enrolled before they can make deposits
      require(enrolled[msg.sender] == true, "Sender is not enrolled in Bank.");

      // Add the amount to the user's balance.
      balances[msg.sender] += msg.value;

      emit LogDepositMade(msg.sender, msg.value);

      return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param _withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint _withdrawAmount) public returns (uint) {
      // Confirm sender has enough funds
      require(balances[msg.sender] >= _withdrawAmount, "Sender has not enough funds.");

      // Transfer Eth to the sender and decrement the withdrawal amount from sender's balance
      balances[msg.sender] -= _withdrawAmount;

      emit LogWithdrawal(msg.sender, _withdrawAmount, balances[msg.sender]);

      return balances[msg.sender];
    }
}
