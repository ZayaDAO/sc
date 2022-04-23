/// @notice This function will multiply `a` by 7

pragma solidity 0.8.7;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/utils/SafeERC20.sol";

contract serenity is ERC20 {
    struct UserInfo{
        uint256 amountToClaim;
        uint256 lastStartTime;
    }

    mapping (address => UserInfo) public userInfos;

    constructor(
        uint256 initialSupply
    ) ERC20('serenity', 'SER') {
    }

    function startSession() external {
        userInfos[msg.sender].lastStartTime = block.timestamp;
    }

    function endSession() external {
        require(userInfos[msg.sender].lastStartTime!=0, "End session called not during active session");
        uint256 sessionTime = block.timestamp - userInfos[msg.sender].lastStartTime;
        userInfos[msg.sender].amountToClaim += sessionTime/60 * 1e18;
        userInfos[msg.sender].lastStartTime = 0;
    }

    function claimReward() external {
        _mint(msg.sender, userInfos[msg.sender].amountToClaim);
        userInfos[msg.sender].amountToClaim = 0;
    }


}


