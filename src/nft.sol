pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

import "./openzeppelin-contracts/contracts/token/ERC721/ERC721Metadata.sol";

contract NFT is ERC721Metadata {
    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) public {}

    function _validateBundledHash(address to, bytes32 assetHash, bytes[] memory properties, bytes[] memory values, bytes32[] memory salts) internal {
        require(to != address(0), "not a valid address");

        // construct assetHash from the props, values, salts
        // append to address
        bytes memory hash = abi.encodePacked(to);

        // append hashes
        for (uint i=0; i< properties.length; i++) {
            hash = abi.encodePacked(hash, keccak256(abi.encodePacked(properties[i], values[i], salts[i])));
        }

        require(keccak256(hash) == assetHash, "asset hash mismatch");
    }

    function mint(address to, uint256 tokenId, bytes32 assetHash, bytes[] memory properties, bytes[] memory values, bytes32[] memory salts) public {
        _validateBundledHash(to, assetHash, properties, values, salts);
        _mint(to, tokenId);
    }
}
