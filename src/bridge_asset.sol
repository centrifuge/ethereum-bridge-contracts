pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

contract BridgeAsset {

  event AssetStored(
    uint256 indexed assetId,
    bytes32 indexed assetVal
  );

  struct Asset {
    bytes32 assetVal; // hash(to_address+fieldHash[])
    uint8 operator_count;
  }

  uint8 min_count;

  mapping (uint256 => Asset) public assets;

  constructor(uint8 mc) public {
    min_count = mc;
  }

  function store(uint256 assetId, bytes32 assetVal) public { // Add OnlyOperator modifier
    if (assets[assetId].assetVal != 0x0) {
      require(assets[assetId].assetVal == assetVal, "Asset Value cannot be modified");
    }

    assets[assetId] = Asset(
      assetVal,
      (assets[assetId].operator_count + 1)
    );

    if (assets[assetId].operator_count == min_count) {
      emit AssetStored(assetId, assetVal);
    }
  }

  /**
  * @dev returns asset found in assets map
  * if asset hasn't received enough number of signatures from operators returns 0
  * @param assetId anchorId of the asset
  */
  function getAsset(uint256 assetId) public view returns(bytes32) {
    bytes32 assetVal = assets[assetId].assetVal;
    if (assets[assetId].operator_count < min_count) {
      assetVal = 0x0;
    }
    return assetVal;
  }

}
