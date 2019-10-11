pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "../bridge_asset.sol";

contract BridgeAssetTest is DSTest {
  BridgeAsset bridge_asset;

  function setUp() public {
    bridge_asset = new BridgeAsset(3);
  }

  function testOnlyStoreGasUsage() public logs_gas {
    uint256 asset_id = 0x12345;
    bytes32 asset_val = sha256(hex"000100000000000f");
    bridge_asset.store(asset_id, asset_val);
  }

  function testSingleStoreRound() public logs_gas {
    uint256 asset_id = 0x12345;
    bytes32 asset_val = sha256(hex"000100000000000f");
    bridge_asset.store(asset_id, asset_val);
    bridge_asset.store(asset_id, asset_val);
    bridge_asset.store(asset_id, asset_val);
    assertEq(bridge_asset.getAsset(asset_id), asset_val);
    // CANNOT TEST EVENT EMITTED?
  }

  function testIncompleteStore() public logs_gas {
    uint256 asset_id = 0x12345;
    bytes32 asset_val = sha256(hex"000100000000000f");
    bridge_asset.store(asset_id, asset_val);

    // only one confirmation but 3 needed
    assertEq(bridge_asset.getAsset(asset_id), 0x0);
  }

  function testFailOperatorIncoherentValue() public {
    uint256 asset_id = 0x12345;
    bytes32 asset_val = sha256(hex"000100000000000f");
    bridge_asset.store(asset_id, asset_val);

    // operator storing incoherent asset_val fails
    bridge_asset.store(asset_id, sha256(hex"000100000000000d"));
  }
}