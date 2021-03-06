pragma solidity >=0.5.15 <0.6.0;
pragma experimental ABIEncoderV2;

import "tinlake-auth/auth.sol";

contract BridgeAsset is Auth {

  event AssetStored(
    bytes32 indexed asset
  );

  uint8 min_count; // n confirmations * 10

  // unconfirmed - (value > 0)
  // confirmed - (value = 1)
  mapping (bytes32 => uint8) public assets;

  constructor(uint8 mc, address rely) public {
    min_count = mc;
    wards[msg.sender] = 1;
    wards[rely] = 1;
  }

  function store(bytes32 asset) public auth { // Add OnlyOperator modifier
    require(assets[asset] != 1, "Asset cannot be changed once confirmed");

    assets[asset] += 10;

    if (assets[asset] == min_count) {
      assets[asset] = 1;
      emit AssetStored(asset);
    }
  }

  function getHash(bytes32 asset) public view returns (bool) {
    if (assets[asset] == 1) {
      return true;
    }

    return false;
  }

}
