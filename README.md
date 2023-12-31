## Batch deposit Huff

This repo contains 2 smart contracts that allow to batch deposit validators in the beacon chain deposit contract.

### Requirements

The following will need to be installed in order to use this repo.

-   [Foundry / Foundryup](https://github.com/gakonst/foundry)
-   [Huff Compiler](https://docs.huff.sh/get-started/installing/)

## Quickstart

```
forge install
forge test
```

To run the benchmark script :
```
FORK_URL=$ETH_RPC_URL make benchmark
```

## Usage
Only the arguments encoding matter, the signature is not checked.
If you wish to deploy the contract, on a testnet you have to change the hard-coded deposit contract address in the contract.

### HuffClassic interface :
``` 
anySignature(bytes pubkeys, bytes withdrawal_creds, bytes signatures, bytes32[] deposit_data_roots)
```
- `pubkeys` : concatenation of the public keys of the validators
- `withdrawal_creds` : concatenation of the withdrawal credentials of the validators
- `signatures` : concatenation of the signatures of the validators
- `deposit_data_roots` : concatenation of the deposit data roots of the validators

### HuffCompact interface :
```
any_signature(bytes data) 
```
- `data` : concatenation of the concatenations of the pubkey, withdrawal_cred, signature and deposit_data_root of each validator

## Benchmark
Ran against a fork at block `18255674`

### Summary
```
┌────────┬───────────┬───────────┬───────────┐
│ count  │  compact  │  classic  │ solidity  │
├────────┼───────────┼───────────┼───────────┤
│      1 │    65 605 │    66 730 │    76 074 │
│      2 │    91 302 │    92 441 │   107 877 │
│      3 │   120 344 │   121 521 │   142 933 │
│      4 │   144 104 │   145 307 │   172 835 │
│      5 │   176 922 │   178 163 │   211 715 │
│     10 │   307 011 │   308 406 │   372 342 │
│     20 │   589 729 │   591 372 │   715 792 │
│     30 │   845 282 │   847 197 │ 1 032 305 │
│     40 │ 1 118 022 │ 1 120 173 │ 1 365 669 │
│     50 │ 1 393 065 │ 1 395 488 │ 1 701 816 │
│     75 │ 2 050 698 │ 2 053 783 │ 2 511 743 │
│    100 │ 2 726 240 │ 2 729 963 │ 3 338 663 │
│    200 │ 5 411 233 │ 5 417 544 │ 6 631 612 │
└────────┴───────────┴───────────┴───────────┘
```

### Gas savings compared to solidity implementation :

```
┌──────────────┬─────────┬─────────────┐
│ compact (%)  │  count  │ classic (%) │
├──────────────┼─────────┼─────────────┤
│           14 │       1 │        12.3 │
│         15.4 │       2 │        14.3 │
│         15.8 │       3 │        15.0 │
│         16.6 │       4 │        15.9 │
│         16.4 │       5 │        15.8 │
│         17.5 │      10 │        17.2 │
│         17.6 │      20 │        17.4 │
│         18.1 │      30 │        17.9 │
│         18.1 │      40 │        18.0 │
│         18.1 │      50 │        18.0 │
│         18.4 │      75 │        18.2 │
│         18.3 │     100 │        18.2 │
│         18.4 │     200 │        18.3 │
└──────────────┴─────────┴─────────────┘
``````
### Benchmark results HuffCompact :
```
1    => 65605
2    => 91302
3    => 120344
4    => 144104
5    => 176922
10   => 307011
20   => 589729
30   => 845282
40   => 1118022
50   => 1393065
75   => 2050698
100  => 2726240
200  => 5411233
```

### Benchmark results HuffClassic :
```
1    => 66730
2    => 92441
3    => 121521
4    => 145307
5    => 178163
10   => 308406
20   => 591372
30   => 847197
40   => 1120173
50   => 1395488
75   => 2053783
100  => 2729963
200  => 5417544
```

### Benchmark results [Solidity](https://etherscan.io/address/0x9b8c989FF27e948F55B53Bb19B3cC1947852E394#code) :
```
1    => 76074
2    => 107877
3    => 142933
4    => 172835
5    => 211715
10   => 372342
20   => 715792
30   => 1032305
40   => 1365669
50   => 1701816
75   => 2511743
100  => 3338663
200  => 6631612
```


## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._