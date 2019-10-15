pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "../bridge_asset.sol";

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

    // operator storing attempts to override an already committed asset
    bridge_asset.store(asset);
  }
}