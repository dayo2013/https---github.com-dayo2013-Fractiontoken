// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "contracts/interfaces/IERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract Fractiontokenfacet is IERC721 {
    // string public name;

    // string public symbol;

    // uint8 public decimals;
// mapping(address => uint256) public balances;
//  mapping(address => mapping(address => uint256)) public allowed;
  uint256 public platformFeePercentage = 1;

 constructor(
    //string memory _name, string memory _symbol
    ) ERC721 ( "dayo","dy"){
        // name = _name;
        // symbol = _symbol;
        // decimals = 18;
    }
    function mint(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than zero");
        require(totalSupply().add(amount) <= MAX_SUPPLY, "Exceeds maximum supply");
        _mint(account, amount);
    }
    // function transferFraction(address to, uint256 amount) external {
    //     require(to != address(0), "Invalid recipient address");
    //     require(amount > 0, "Amount must be greater than zero");
    //     require(amount <= balanceOf(msg.sender), "Insufficient balance");

    //     _transfer(msg.sender, to, amount);

   // }
    function purchaseFractionalTokens(uint256 tokenId, uint256 amount) external {
        address fractionalTokenAddress = fractionalTokens[tokenId];
        require(fractionalTokenAddress != address(0), "Token not fractionalized");
        require(amount > 0, "Purchase amount must be greater than zero");
        require(msg.sender != address(0), "Invalid buyer address");
        require(amount <= MAX_PURCHASE_AMOUNT, "Exceeds maximum purchase amount");
        require(platformToken.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
    }
    function transferFractionalTokens(uint256 tokenId, address to, uint256 amount) external {
        address fractionalTokenAddress = fractionalTokens[tokenId];
        require(fractionalTokenAddress != address(0), "Token not fractionalized");
        require(to != address(0), "Invalid recipient address");
        require(amount > 0, "Transfer amount must be greater than zero");
        FractionalToken fractionalToken = FractionalToken(fractionalTokenAddress);
        require(amount <= fractionalToken.balanceOf(msg.sender), "Insufficient balance");
        require(amount <= MAX_TRANSFER_AMOUNT, "Exceeds maximum transfer amount");
    }
    function setPlatformFeePercentage(uint256 _feePercentage) external onlyOwner {
        
        require(_feePercentage <= 100, "Fee percentage cannot exceed 100%");
        require(_feePercentage != platformFeePercentage, "Fee percentage is unchanged");
        require(_feePercentage >= MIN_FEE_PERCENTAGE, "Fee percentage is too low");
        platformFeePercentage = _feePercentage;
    }



}