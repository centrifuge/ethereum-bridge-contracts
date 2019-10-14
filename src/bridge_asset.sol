pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

contract BridgeAsset {

  event AssetStored(
    uint256 indexed asset_id,
    bytes32 indexed asset_val
  );

  struct Asset {
    bytes32 asset_val; // hash(to_address+fieldHash[])
    uint8 operator_count;
  }

  uint8 min_count;

  mapping (uint256 => Asset) public assets;

  constructor(uint8 mc) public {
    min_count = mc;
  }

  function store(uint256 asset_id, bytes32 asset_val) public { // Add OnlyOperator modifier
    if (assets[asset_id].asset_val != 0x0) {
      require(assets[asset_id].asset_val == asset_val, "Asset Value cannot be modified");
    }

    assets[asset_id] = Asset(
      asset_val,
      (assets[asset_id].operator_count + 1)
    );

    if (assets[asset_id].operator_count == min_count) {
      emit AssetStored(asset_id, asset_val);
    }
  }

  /**
  * @dev returns asset found in assets map
  * if asset hasn't received enough number of signatures from operators returns 0
  * @param asset_id anchorId of the asset
  */
  function getAsset(uint256 asset_id) public view returns(bytes32) {
    bytes32 asset_val = assets[asset_id].asset_val;
    if (assets[asset_id].operator_count < min_count) {
      asset_val = 0x0;
    }
    return asset_val;
  }

}
