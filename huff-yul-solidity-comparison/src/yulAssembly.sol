// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @title  YulAssembly Toolkit
/// @author Ali Razzaq
/// @notice Demonstrates a variety of inline Yul patterns for your Solidity portfolio
/// @dev    All functions are `pure` or `view` except where noted
contract YulAssembly {
    /// -----------------------------------------------------------------------
    ///                           VARIABLE DECLARATION
    /// -----------------------------------------------------------------------

    /// @notice Adds two compile-time constants in Yul
    /// @return z The sum of 10 + 20
    function yulDeclareVariables() external pure returns (uint256 z) {
        assembly {
            let x := 10
            let y := 20
            z := add(x, y)
        }
    }

    /// -----------------------------------------------------------------------
    ///                      CONDITIONAL BRANCHING (IF / SWITCH)
    /// -----------------------------------------------------------------------

    /// @notice Returns the max of `a` and `b`, or their average if equal
    /// @param a First operand
    /// @param b Second operand
    /// @return z The result as described
    function yulIfMax(uint256 a, uint256 b) external pure returns (uint256 z) {
        assembly {
            if gt(a, b) {
                z := a
            }
            if lt(a, b) {
                z := b
            }
            if eq(a, b) {
                z := div(add(a, b), 2)
            }
        }
    }

    /// @notice Returns the minimum of `a` and `b` via a `switch` on `lt(a,b)`
    /// @param a First operand
    /// @param b Second operand
    /// @return z The smaller of `a` or `b`
    function yulSwitchMin(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 z) {
        assembly {
            switch lt(a, b)
            case 1 {
                z := a
            }
            case 0 {
                z := b
            }
        }
    }

    /// @notice Reverts if `a >= 10`, else returns `a`
    /// @param a Input value
    /// @return x The input if it's < 10
    function yulRevertUnlessLessThan10(
        uint256 a
    ) external pure returns (uint256 x) {
        assembly {
            if iszero(lt(a, 10)) {
                revert(0, 0)
            }
            x := a
        }
    }

    /// -----------------------------------------------------------------------
    ///                         LOOPS (FOR / WHILE)
    /// -----------------------------------------------------------------------

    /// @notice Counts from 0 to 9 using a `for`-loop
    /// @return z Always returns 10
    function yulForLoop() external pure returns (uint256 z) {
        assembly {
            for {
                let i := 0
            } lt(i, 10) {
                i := add(i, 1)
            } {
                z := add(z, 1)
            }
        }
    }

    /// @notice Counts from 0 to 9 using a `for` as a `while`-loop
    /// @return z Always returns 10
    function yulWhileLoop() external pure returns (uint256 z) {
        assembly {
            let i := 0
            for {

            } lt(i, 10) {

            } {
                i := add(i, 1)
                z := add(z, 1)
            }
        }
    }

    /// -----------------------------------------------------------------------
    ///                    FIXED-POINT EXPONENTIATION (rpow)
    /// -----------------------------------------------------------------------

    /// @notice Compute `x^n / b^(n-1)` in fixed-point with safe rounding
    /// @dev    Based on MakerDAO’s DS-Math `rpow` algorithm
    /// @param x Base, in fixed-point with scaling factor `b`
    /// @param n Exponent
    /// @param b Scaling factor (e.g. 1e18)
    /// @return z Result as `x^n / b^(n-1)` with proper overflow checks
    function rpow(
        uint256 x,
        uint256 n,
        uint256 b
    ) public pure returns (uint256 z) {
        assembly {
            switch x
            case 0 {
                switch n
                case 0 {
                    z := b
                } // 0**0 = 1 (fixed-point)
                default {
                    z := 0
                } // 0**n = 0
            }
            default {
                z := b // result = 1 in fixed-point
                let half := div(b, 2)
                for {
                    let i := n
                } gt(i, 0) {
                    i := shr(1, i)
                } {
                    // square
                    let xx := mul(x, x)
                    let xxRounded := div(add(xx, half), b)
                    if iszero(eq(div(xx, b), xxRounded)) {
                        revert(0, 0)
                    }

                    // if low bit of i == 1, multiply into z
                    if eq(and(i, 1), 1) {
                        let zx := mul(z, x)
                        let zxRounded := div(add(zx, half), b)
                        if iszero(eq(div(zx, b), zxRounded)) {
                            revert(0, 0)
                        }
                        z := zxRounded
                    }
                    // else (low bit == 0), assign z = xxRounded
                    if iszero(eq(and(i, 1), 1)) {
                        z := xxRounded
                    }
                }
            }
        }
    }

    /// @notice Wrapper to test `rpow`
    /// @return fixedPoint One example call: 2.0^5.0 in 18-decimals ≈ 32e18
    function testRpow() external pure returns (uint256 fixedPoint) {
        fixedPoint = rpow(2e18, 5, 1e18);
    }

    /// -----------------------------------------------------------------------
    ///               STORAGE & MEMORY MANIPULATION EXAMPLES
    /// -----------------------------------------------------------------------

    uint256 private storedValue;

    /// @notice Store a value in contract storage via Yul
    /// @param val The value to store
    function yulStore(uint256 val) external {
        assembly {
            sstore(storedValue.slot, val)
        }
    }

    /// @notice Read the stored value via Yul
    /// @return val The value previously written
    function yulLoad() external view returns (uint256 val) {
        assembly {
            val := sload(storedValue.slot)
        }
    }

    /// @notice Build a dynamic `bytes` array of length `len`, where each byte = its index
    /// @param len Length of the returned array
    /// @return buf A `bytes` buffer [0,1,2,…,len-1]
    function yulBuildBytes(
        uint256 len
    ) external pure returns (bytes memory buf) {
        buf = new bytes(len);
        assembly {
            let ptr := add(buf, 32)
            for {
                let i := 0
            } lt(i, len) {
                i := add(i, 1)
            } {
                mstore8(add(ptr, i), i)
            }
        }
    }

    /// -----------------------------------------------------------------------
    ///               EXTERNAL CONTRACT CODE INSPECTION
    /// -----------------------------------------------------------------------

    /// @notice Returns the size of the code at address `addr`
    /// @param addr Target contract address
    /// @return size Code size in bytes
    function yulExtCodeSize(address addr) external view returns (uint256 size) {
        assembly {
            size := extcodesize(addr)
        }
    }

    /// @notice Copies and returns the bytecode of contract at `addr`
    /// @param addr Target contract
    /// @return code Raw bytecode
    function yulExtCodeCopy(
        address addr
    ) external view returns (bytes memory code) {
        uint256 sz;
        assembly {
            sz := extcodesize(addr)
        }
        code = new bytes(sz);
        assembly {
            extcodecopy(addr, add(code, 32), 0, sz)
        }
    }
}
