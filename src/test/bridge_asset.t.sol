pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

import "../bridge_asset.sol";
import "../../lib/ds-test/src/test.sol";

contract BridgeAssetTest is DSTest {
  BridgeAsset bridge_asset;

  function setUp() public {
    bridge_asset = new BridgeAsset(30); // 3 confirmations * 10
  }

  function testOnlyStoreGasUsage() public logs_gas {
    bytes32 asset = sha256(hex"000100000000000f");
    bridge_asset.store(asset);
  }

  function testSingleStoreRound() public logs_gas {
    bytes32 asset = sha256(hex"000100000000000f");
    bridge_asset.store(asset);
    bridge_asset.store(asset);
    bridge_asset.store(asset);
    assertEq(uint(bridge_asset.assets(asset)), 1);
    assertTrue(bridge_asset.isAssetValid(asset));
    // CANNOT TEST EVENT EMITTED?
  }

  function testIncompleteStore() public logs_gas {
    bytes32 asset = sha256(hex"000100000000000f");
    bridge_asset.store(asset);

    // only one confirmation but 3 needed
    assertEq(uint(bridge_asset.assets(asset)), 10);
  }

  function testFailOperatorIncoherentOverride() public {
    bytes32 asset = sha256(hex"000100000000000f");
    bridge_asset.store(asset);
    bridge_asset.store(asset);
    bridge_asset.store(asset);
    assertEq(uint(bridge_asset.assets(asset)), 1);
    assertTrue(bridge_asset.isAssetValid(asset));

    // operator storing attempts to override an already committed asset
    bridge_asset.store(asset);
  }
}
