#!/usr/bin/env bash

# Exit on failure
set -e
set -x

export CENT_ENV=${CENT_ENV:-"fulvous"}
export ETH_GAS=${ETH_GAS:-4712388}
export ETH_KEYSTORE=${ETH_KEYSTORE:-./keystore}
export ETH_RPC_URL=${ETH_RPC_URL:-"http://localhost:8545"}
export ETH_PASSWORD=${ETH_PASSWORD:-"/dev/null"}
export ETH_FROM=$ETH_FROM
export RELY=$RELY

# deploy asset contracts
dapp update
dapp build --extract

assetAddr=$(seth send --create out/BridgeAsset.bin 'BridgeAsset(uint8,address)' "10" "$RELY")
jq --arg addr $assetAddr --arg env $CENT_ENV '.[$env].address = $addr' addresses.json > addresses_aux.json
mv addresses_aux.json addresses.json

# remove deployer as ward
seth send $assetAddr 'deny(address)' $ETH_FROM
