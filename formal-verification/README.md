# Formal Verification Playground 🛡️

> Learning-by-doing notes and example specs from my deep dive into **formal verification for Ethereum smart contracts** with **Certora** and **Halmos**.  
> All exercises follow *Cyfrin Updraft: Assembly & Formal Verification* by [Patrick Collins](https://twitter.com/patrickalphac).

---

## 🤯 Why this repo is fun

1. **Iterate in pure Solidity first** – write the whole code-base in the friendliest way, covered by Foundry/Hardhat tests.  
2. **Rewrite hot paths in Yul/assembly** – squeeze every last gas unit out.  
3. **Prove nothing broke** – use Certora & Halmos to formally assert that the assembly version behaves *exactly* like the original Solidity logic.

Crazy that we can now refactor to low-level assembly **without losing sleep**—the prover flags any behavioural drift long before main-net deployment.

---

## 📚 What you’ll find

| Folder          | What’s inside                                                                                 | Tools / Concepts    |
| --------------- | --------------------------------------------------------------------------------------------- | ------------------- |
| `src/`          | Baseline Solidity contracts & gas-optimized assembly rewrites                                 | Solidity 0.8.x, Yul |
| `Certora/Spec/` | CVL spec files that capture invariants, storage ↔ event relations, and cross-impl equivalence | Certora CLI         |
| `Certora/Conf/` | Ready-to-run `.conf` job files                                                                | Certora CLI         |
| `halmos/`       | Halmos projects & YAML configs                                                                | Halmos              |
| `test/`         | Foundry/Hardhat unit tests that back-stop the proofs                                          | Foundry, Hardhat    |

---

## 🛠 Setup

### Prerequisites

| Requirement       | Min Version                | Install Hint              |
| ----------------- | -------------------------- | ------------------------- |
| Python            | 3.8.16+                    | `brew install python`     |
| Java (JDK)        | 11+                        | `brew install openjdk`    |
| Solidity (`solc`) | 0.8.20 (via `solc-select`) | `pip install solc-select` |
| Certora CLI       | latest                     | `pip install certora-cli` |
| Halmos            | latest                     | `pip install halmos`      |

> **PATH tip:** prepend `~/.solc-select/bin` so the right compiler is found.

### Clone & install

```bash
git clone https://github.com/<you>/web3-solidity-portfolio.git
cd formal-verification
python3 -m venv venv              # optional but recommended
source venv/bin/activate
pip install -r requirements.txt   # certora-cli, halmos, etc.