// SPDX-License-Identifier: MIT

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

pragma solidity ^0.8.18;

/*
 *@title OracleLib
 *@author Yusuph musa
 *@notice This library is used to check the chainlink oracle for stale data.
 * if a price is stale, the function will revert and render the DSCEngine unusable - this is by design
 * we want the DSCEngine to freeze if prices become stale.
 * so ifthe chainlink network explodes and you have alpot of money in the protocol... too bad
 */

library OracleLib {
    error OracleLib_staleprice();

    uint256 public constant TIMEOUT = 3 hours; // 3 * 60 * 60 = 10800 seconds

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) {
            revert OracleLib_staleprice();
        }
        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }
}
