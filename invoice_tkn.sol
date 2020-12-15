pragma solidity >=0.4.22 <0.8.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol";
import "../node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


abstract contract invoice_tkn is  IERC721, ERC165{

    struct invoice{
    string invoice_name;
    string symbol;
    }

    invoice[] public invoices;

    // Mapping from owner to id of invoices
    mapping (uint => address) public invoiceToOwner;

     // Mapping from owner to number of owned token
    mapping (address => uint) public ownerInvoiceCount;

    
     // Create an id from name and symbol
    function _createInvoiceToken(string memory _name,string memory _symbol)
        internal
        isUnique(_name, _symbol)
    {
        // Add invoice to array and get id
        uint id =  SafeMath.sub(invoices.push(invoice(_name, _symbol)), 1);
        // Map owner to id of invoice
        assert(invoiceToOwner[id] == address(0));
        invoiceToOwner[id] = msg.sender;
        ownerInvoiceCount[msg.sender] = SafeMath.add(ownerInvoiceCount[msg.sender], 1);
    }


    // Returns array of invoices found by owner
    function getInvoicesByOwner(address _owner)
        public
        view
        returns(uint[] memory)
    {
        uint[] memory result = new uint[](ownerInvoiceCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < invoices.length; i++) {
            if (invoiceToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
        function burn(uint256 _tokenId)
        external
    {
        require(msg.sender != address(0));
        require(_exists(_tokenId));
        
        ownerInvoiceCount[msg.sender] = SafeMath.sub(ownerInvoiceCount[msg.sender], 1);
        invoiceToOwner[_tokenId] = address(0);
    }

    // Returns count of tokens by address
    function balanceOf(address _owner)
        public
        view
        override
        returns(uint256 _balance)
    {
        return ownerInvoiceCount[_owner];
    }

 // Check if invoice exists
    function _exists(uint256 invoiceId)
        internal
        view
        returns(bool)
    {
        address owner = invoiceToOwner[invoiceId];
        return owner != address(0);
    }

 // Check if Invoice doesn't exist yet
    modifier isUnique(string memory _name, string memory _symbol) {
        bool result = true;
        for(uint i = 0; i < invoices.length; i++) {
            if(keccak256(abi.encodePacked(invoices[i].name)) == keccak256(abi.encodePacked(_name)) && invoices[i].symbol == _symbol) {
                result = false;
            }
        }
        require(result, "Invoice already exists.");
        _;
    }


}
