<h1 align="center">🧠 Web3 Solidity Portfolio (Foundry Capstones)</h1>
<p align="center">
  A collection of advanced, production-grade smart contract projects built with <strong>Solidity + Foundry</strong>.
  <br>
  Every project includes deploy scripts, tests, and best-practice security patterns.
</p>

---

## 📚 Overview

This repo is a curated portfolio of **hands-on Web3 projects** completed during and after my training with the **Cyfrin Updraft Smart Contract Engineering Track**.  
It focuses on real-world dApp modules built using **Foundry**, **OpenZeppelin**, and **Chainlink** tooling.

Each folder contains a complete, self-contained project with:

- ✅ Smart contract logic (Solidity 0.8.x)
- 🧪 Unit + fuzz tests (`forge test`)
- 🚀 Deploy scripts (`broadcast/`)
- 🔗 External integrations (Chainlink VRF, Automation, Price Feeds)
- 🔒 Security patterns (custom errors, modifiers, checks-effects-interactions)
- 📁 Gas optimization where applicable

---

## 📂 Project Index

| Project                | Topics Covered                                               |
| ---------------------- | ------------------------------------------------------------ |
| `ERC20/`               | Custom ERC‑20 token with transfer fees & gas optimizations   |
| `ERC721/`              | Basic NFT, enumerable extension, metadata handling           |
| `DAO/`                 | On-chain DAO with proposal lifecycle, token voting           |
| `MerkleAirdrop/`       | Gas-efficient airdrop using Merkle proofs                    |
| `AccountAbstraction/`  | EIP‑4337-style wallet logic (experimental)                   |
| `UpgradableContracts/` | Transparent + UUPS proxy pattern (OpenZeppelin)              |
| `VRF-Raffle/`          | Chainlink VRF lottery with automation-based winner selection |
| `AccessControl/`       | Role-based access using OZ’s `AccessControl`                 |

More folders to be added soon as I explore ZK-rollups and modular staking.

---

## 🛠 Tech Stack

- **Solidity 0.8.x**
- **Foundry** (Forge, Anvil, Chisel)
- **OpenZeppelin** contracts (ERC standards, proxies, access control)
- **Chainlink** (VRF, Automation, Price Feeds)
- **Gas reporting** with `forge snapshot`
- **Fuzz testing** + invariant checks

---

## 🚀 Getting Started

```bash
# Clone the mono-repo
git clone https://github.com/alirazzaq-dev/web3-solidity-portfolio.git
cd web3-solidity-portfolio

# Enter any sub-project
cd ERC20

# Install dependencies
forge install

# Run tests
forge test -vvvv

# Deploy (dry-run)
forge script script/Deploy.s.sol --fork-url $RPC_URL --broadcast --dry-run