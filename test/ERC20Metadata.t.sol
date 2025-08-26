// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {getSymbol, getName, getDecimals, getMetadata} from "../src/utils/ERC20Metadata.sol";

// Mock ERC20 token for testing
contract MockERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;

    constructor(string memory _name, string memory _symbol, uint256 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}

// Mock ERC20 with non-standard returns
contract MockNonStandardERC20 {
    string internal _name;
    string internal _symbol;
    uint256 internal _decimals;

    constructor(string memory name_, string memory symbol_, uint256 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    // Returns bytes32 instead of string (some old tokens do this)
    function symbol() external view returns (bytes32) {
        return bytes32(abi.encodePacked(_symbol));
    }

    function name() external view returns (bytes32) {
        return bytes32(abi.encodePacked(_name));
    }
}

// Mock token that reverts on calls
contract MockRevertingToken {
    function name() external pure {
        revert("Name not available");
    }

    function symbol() external pure {
        revert("Symbol not available");
    }

    function decimals() external pure {
        revert("Decimals not available");
    }
}

// Mock token with no metadata functions
contract MockNoMetadata {
    uint256 public someValue = 42;
}

// Mock token with invalid return data
contract MockInvalidToken {
    function name() external pure returns (uint256) {
        return 12345; // Wrong return type
    }

    function symbol() external pure returns (bool) {
        return true; // Wrong return type
    }

    function decimals() external pure returns (string memory) {
        return "invalid"; // Wrong return type
    }
}

contract ERC20MetadataTest is Test {
    MockERC20 standardToken;
    MockNonStandardERC20 nonStandardToken;
    MockRevertingToken revertingToken;
    MockNoMetadata noMetadataToken;
    MockInvalidToken invalidToken;

    function setUp() public {
        standardToken = new MockERC20("Test Token", "TEST", 18);
        nonStandardToken = new MockNonStandardERC20("Old Token", "OLD", 6);
        revertingToken = new MockRevertingToken();
        noMetadataToken = new MockNoMetadata();
        invalidToken = new MockInvalidToken();
    }

    // Tests for getName()
    function test_getName_standardToken() public {
        string memory name = getName(address(standardToken));
        assertEq(name, "Test Token");
    }

    function test_getName_emptyName() public {
        MockERC20 emptyNameToken = new MockERC20("", "EMPTY", 18);
        string memory name = getName(address(emptyNameToken));
        assertEq(name, "");
    }

    function test_getName_longName() public {
        string memory longName = "This is a very long token name that exceeds typical lengths";
        MockERC20 longNameToken = new MockERC20(longName, "LONG", 18);
        string memory retrievedName = getName(address(longNameToken));
        assertEq(retrievedName, longName);
    }

    function test_getName_nonExistentContract() public {
        address nonExistent = address(0x1234567890123456789012345678901234567890);
        string memory name = getName(nonExistent);
        assertEq(name, "");
    }

    function test_getName_revertingToken() public {
        string memory name = getName(address(revertingToken));
        assertEq(name, "");
    }

    function test_getName_noMetadataToken() public {
        string memory name = getName(address(noMetadataToken));
        assertEq(name, "");
    }

    function test_getName_invalidToken() public {
        string memory name = getName(address(invalidToken));
        assertEq(name, "");
    }

    // Tests for getSymbol()
    function test_getSymbol_standardToken() public {
        string memory symbol = getSymbol(address(standardToken));
        assertEq(symbol, "TEST");
    }

    function test_getSymbol_emptySymbol() public {
        MockERC20 emptySymbolToken = new MockERC20("Empty Symbol", "", 18);
        string memory symbol = getSymbol(address(emptySymbolToken));
        assertEq(symbol, "");
    }

    function test_getSymbol_longSymbol() public {
        string memory longSymbol = "VERYLONGSYMBOL";
        MockERC20 longSymbolToken = new MockERC20("Long Symbol Token", longSymbol, 18);
        string memory retrievedSymbol = getSymbol(address(longSymbolToken));
        assertEq(retrievedSymbol, longSymbol);
    }

    function test_getSymbol_nonExistentContract() public {
        address nonExistent = address(0x1234567890123456789012345678901234567890);
        string memory symbol = getSymbol(nonExistent);
        assertEq(symbol, "");
    }

    function test_getSymbol_revertingToken() public {
        string memory symbol = getSymbol(address(revertingToken));
        assertEq(symbol, "");
    }

    function test_getSymbol_noMetadataToken() public {
        string memory symbol = getSymbol(address(noMetadataToken));
        assertEq(symbol, "");
    }

    function test_getSymbol_invalidToken() public {
        string memory symbol = getSymbol(address(invalidToken));
        assertEq(symbol, "");
    }

    // Tests for getDecimals()
    function test_getDecimals_standardToken() public {
        uint256 decimals = getDecimals(address(standardToken));
        assertEq(decimals, 18);
    }

    function test_getDecimals_customDecimals() public {
        MockERC20 customDecimalsToken = new MockERC20("Custom", "CUSTOM", 6);
        uint256 decimals = getDecimals(address(customDecimalsToken));
        assertEq(decimals, 6);
    }

    function test_getDecimals_zeroDecimals() public {
        MockERC20 zeroDecimalsToken = new MockERC20("Zero", "ZERO", 0);
        uint256 decimals = getDecimals(address(zeroDecimalsToken));
        assertEq(decimals, 0);
    }

    function test_getDecimals_nonExistentContract() public {
        address nonExistent = address(0x1234567890123456789012345678901234567890);
        uint256 decimals = getDecimals(nonExistent);
        assertEq(decimals, 18); // Should default to 18
    }

    function test_getDecimals_revertingToken() public {
        uint256 decimals = getDecimals(address(revertingToken));
        assertEq(decimals, 18); // Should default to 18
    }

    function test_getDecimals_noMetadataToken() public {
        uint256 decimals = getDecimals(address(noMetadataToken));
        assertEq(decimals, 18); // Should default to 18
    }

    function test_getDecimals_invalidToken() public {
        uint256 decimals = getDecimals(address(invalidToken));
        assertEq(decimals, 18); // Should default to 18
    }

    // Tests for getMetadata()
    function test_getMetadata_standardToken() public {
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(standardToken));
        assertEq(name, "Test Token");
        assertEq(symbol, "TEST");
        assertEq(decimals, 18);
    }

    function test_getMetadata_customToken() public {
        MockERC20 customToken = new MockERC20("Custom Token", "CUSTOM", 6);
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(customToken));
        assertEq(name, "Custom Token");
        assertEq(symbol, "CUSTOM");
        assertEq(decimals, 6);
    }

    function test_getMetadata_emptyStrings() public {
        MockERC20 emptyToken = new MockERC20("", "", 0);
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(emptyToken));
        assertEq(name, "");
        assertEq(symbol, "");
        assertEq(decimals, 0);
    }

    function test_getMetadata_nonExistentContract() public {
        address nonExistent = address(0x1234567890123456789012345678901234567890);
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(nonExistent);
        assertEq(name, "");
        assertEq(symbol, "");
        assertEq(decimals, 18);
    }

    function test_getMetadata_revertingToken() public {
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(revertingToken));
        assertEq(name, "");
        assertEq(symbol, "");
        assertEq(decimals, 18);
    }

    function test_getMetadata_noMetadataToken() public {
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(noMetadataToken));
        assertEq(name, "");
        assertEq(symbol, "");
        assertEq(decimals, 18);
    }

    function test_getMetadata_invalidToken() public {
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(invalidToken));
        assertEq(name, "");
        assertEq(symbol, "");
        assertEq(decimals, 18);
    }

    // Test edge cases
    function test_extremeValues() public {
        MockERC20 extremeToken = new MockERC20("Token", "TKN", type(uint256).max);
        uint256 decimals = getDecimals(address(extremeToken));
        assertEq(decimals, type(uint256).max);
    }

    function test_veryLongStrings() public {
        string memory veryLongName =
            "This is an extremely long token name that goes on and on and on and should still be handled correctly by the metadata functions even though it is much longer than typical token names";
        string memory veryLongSymbol = "VERYLONGSYMBOLTHATEXCEEDSTYPICALLENGTHS";

        MockERC20 longToken = new MockERC20(veryLongName, veryLongSymbol, 18);
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(address(longToken));
        assertEq(name, veryLongName);
        assertEq(symbol, veryLongSymbol);
        assertEq(decimals, 18);
    }

    // Gas optimization tests
    function test_gas_getName() public {
        uint256 gasBefore = gasleft();
        getName(address(standardToken));
        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;

        // Should be reasonably efficient
        assertLt(gasUsed, 50000, "getName should be gas efficient");
    }

    function test_gas_getMetadata() public {
        uint256 gasBefore = gasleft();
        getMetadata(address(standardToken));
        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;

        // Should be reasonably efficient even with 3 calls
        assertLt(gasUsed, 100000, "getMetadata should be gas efficient");
    }

    // Integration test with real-world scenarios
    function test_realWorldScenario() public {
        // Create tokens that simulate real ERC20 tokens
        MockERC20 usdc = new MockERC20("USD Coin", "USDC", 6);
        MockERC20 weth = new MockERC20("Wrapped Ether", "WETH", 18);
        MockERC20 dai = new MockERC20("Dai Stablecoin", "DAI", 18);

        // Test USDC
        (string memory usdcName, string memory usdcSymbol, uint256 usdcDecimals) = getMetadata(address(usdc));
        assertEq(usdcName, "USD Coin");
        assertEq(usdcSymbol, "USDC");
        assertEq(usdcDecimals, 6);

        // Test WETH
        (string memory wethName, string memory wethSymbol, uint256 wethDecimals) = getMetadata(address(weth));
        assertEq(wethName, "Wrapped Ether");
        assertEq(wethSymbol, "WETH");
        assertEq(wethDecimals, 18);

        // Test DAI
        (string memory daiName, string memory daiSymbol, uint256 daiDecimals) = getMetadata(address(dai));
        assertEq(daiName, "Dai Stablecoin");
        assertEq(daiSymbol, "DAI");
        assertEq(daiDecimals, 18);
    }

    // Test consistency across multiple calls
    function test_consistency() public {
        // Multiple calls should return the same results
        string memory name1 = getName(address(standardToken));
        string memory name2 = getName(address(standardToken));
        assertEq(name1, name2);

        string memory symbol1 = getSymbol(address(standardToken));
        string memory symbol2 = getSymbol(address(standardToken));
        assertEq(symbol1, symbol2);

        uint256 decimals1 = getDecimals(address(standardToken));
        uint256 decimals2 = getDecimals(address(standardToken));
        assertEq(decimals1, decimals2);
    }

    // Fuzz test
    function test_fuzz_getMetadata(address addr) public {
        // Should not revert for any address
        (string memory name, string memory symbol, uint256 decimals) = getMetadata(addr);

        // Decimals should be at least 18 if not a valid ERC20
        // (our default value when calls fail)
        if (bytes(name).length == 0 && bytes(symbol).length == 0) {
            assertEq(decimals, 18);
        }
    }
}
