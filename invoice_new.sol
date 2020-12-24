pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract invoice is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() public ERC721("INVOICE-TOKEN", "IN-TKN") {}

    function tokenizeInvoice(address persons_acc_address, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint( persons_acc_address, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}

/*I am not able to figure out how do I automatically assign a new name and symbol for a fresh token, 
here by default I have assigned it as (name = INVOICE-TOKEN and symbol=IN-TKN) using the constructor */

// to get the the balance, we must use: invoice.balanceOf( address )