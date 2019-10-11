pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "../bridge_asset.sol";

contract BridgeAssetTest is DSTest {
  BridgeAsset bridgeAsset;

  function setUp() public {
    bridgeAsset = new BridgeAsset(3);
  }

  function testOnlyStoreGasUsage() public logs_gas {
    uint256 assetId = 0x12345;
    bytes32 assetVal = sha256(hex"000100000000000f");
    bridgeAsset.store(assetId, assetVal);
  }

  function testSingleStoreRound() public logs_gas {
    uint256 assetId = 0x12345;
    bytes32 assetVal = sha256(hex"000100000000000f");
    bridgeAsset.store(assetId, assetVal);
    bridgeAsset.store(assetId, assetVal);
    bridgeAsset.store(assetId, assetVal);
    assertEq(bridgeAsset.getAsset(assetId), assetVal);
  }

  function testIncompleteStore() public logs_gas {
    uint256 assetId = 0x12345;
    bytes32 assetVal = sha256(hex"000100000000000f");
    bridgeAsset.store(assetId, assetVal);

    // only one confirmation but 3 needed
    assertEq(bridgeAsset.getAsset(assetId), 0x0);

    // operator storing inconsistent assetVal
    //bridgeAsset.store(assetId, sha256(hex"000100000000000d")); CANNOT TEST FAIL SCENARIOS
    // CANNOT TEST EVENT EMITTED
  }
}