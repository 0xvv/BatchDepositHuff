#!/bin/bash

# Set FORK_URL environment variable before running this script.

# Run the sequence of commands:
# 1. Start Anvil server
# 2. Wait for Anvil server to start
# 3. Run forge benchmark script
# 4. Echo results
# 5. End Anvil server
run_benchmark() {
    # BatchDepositCompact
    # Run anvil
    anvil -m 'test test test test test test test test test test test junk' --balance 100000 --fork-url ${FORK_URL} --fork-block-number 18255674 > anvil.log 2>&1 &
    ANVIL_PID=$!

    # Wait for anvil to start
    echo "Waiting for Anvil server to start"
    while ! nc -z localhost 8545; do 
        sleep 1
        echo -n .
    done
    echo

    # Run benchmark
    forge script BenchmarkCompact --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast --skip-simulation --slow 
    
    printf "Last block-number: "
    cast block-number --rpc-url http://localhost:8545   

    # Echo results 
    echo ""
    echo "Benchmark results Compact :"
    echo "=================="
    echo ""

    printf "1    => "
    cast bl 18255676 --field gasUsed --rpc-url http://localhost:8545 

    printf "2    => "
    cast bl 18255677 --field gasUsed --rpc-url http://localhost:8545

    printf "3    => "
    cast bl 18255678 --field gasUsed --rpc-url http://localhost:8545

    printf "4    => "
    cast bl 18255679 --field gasUsed --rpc-url http://localhost:8545

    printf "5    => "
    cast bl 18255680 --field gasUsed --rpc-url http://localhost:8545

    printf "10   => "
    cast bl 18255681 --field gasUsed --rpc-url http://localhost:8545

    printf "20   => "
    cast bl 18255682 --field gasUsed --rpc-url http://localhost:8545

    printf "30   => "
    cast bl 18255683 --field gasUsed --rpc-url http://localhost:8545

    printf "40   => "
    cast bl 18255684 --field gasUsed --rpc-url http://localhost:8545

    printf "50   => "
    cast bl 18255685 --field gasUsed --rpc-url http://localhost:8545

    printf "75   => "
    cast bl 18255686 --field gasUsed --rpc-url http://localhost:8545

    printf "100  => "
    cast bl 18255687 --field gasUsed --rpc-url http://localhost:8545

    printf "200  => "
    cast bl 18255688 --field gasUsed --rpc-url http://localhost:8545

    # End benchmark
    if [ "${PRINT_LOGS}" = "true" ]; then
        echo "Anvil output:"
        cat anvil.log
    fi
    echo "Shutting down Anvil server..."
    kill $ANVIL_PID
    rm -f anvil.log
    sleep 3

    #####################
    # BatchDepositClassic
    # Run anvil
    anvil -m 'test test test test test test test test test test test junk' --balance 100000 --fork-url ${FORK_URL} --fork-block-number 18255674 > anvil.log 2>&1 &
    ANVIL_PID=$!

    # Wait for anvil to start
    echo "Waiting for Anvil server to start"
    while ! nc -z localhost 8545; do 
        sleep 1
        echo -n .
    done
    echo

    # Run benchmark
    forge script BenchmarkClassic --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast --skip-simulation --slow 
    
    printf "Last block-number: "
    cast block-number --rpc-url http://localhost:8545   

    # Echo results 
    echo ""
    echo "Benchmark results Classic :"
    echo "=================="
    echo ""

    printf "1    => "
    cast bl 18255676 --field gasUsed --rpc-url http://localhost:8545 

    printf "2    => "
    cast bl 18255677 --field gasUsed --rpc-url http://localhost:8545

    printf "3    => "
    cast bl 18255678 --field gasUsed --rpc-url http://localhost:8545

    printf "4    => "
    cast bl 18255679 --field gasUsed --rpc-url http://localhost:8545

    printf "5    => "
    cast bl 18255680 --field gasUsed --rpc-url http://localhost:8545

    printf "10   => "
    cast bl 18255681 --field gasUsed --rpc-url http://localhost:8545

    printf "20   => "
    cast bl 18255682 --field gasUsed --rpc-url http://localhost:8545

    printf "30   => "
    cast bl 18255683 --field gasUsed --rpc-url http://localhost:8545

    printf "40   => "
    cast bl 18255684 --field gasUsed --rpc-url http://localhost:8545

    printf "50   => "
    cast bl 18255685 --field gasUsed --rpc-url http://localhost:8545

    printf "75   => "
    cast bl 18255686 --field gasUsed --rpc-url http://localhost:8545

    printf "100  => "
    cast bl 18255687 --field gasUsed --rpc-url http://localhost:8545

    printf "200  => "
    cast bl 18255688 --field gasUsed --rpc-url http://localhost:8545

    # End benchmark
    if [ "${PRINT_LOGS}" = "true" ]; then
        echo "Anvil output:"
        cat anvil.log
    fi
    echo "Shutting down Anvil server..."
    kill $ANVIL_PID
    rm -f anvil.log
    sleep 3


    #####################
    # Solidity
    # Run anvil
    anvil -m 'test test test test test test test test test test test junk' --balance 100000 --fork-url ${FORK_URL} --fork-block-number 18255674 > anvil.log 2>&1 &
    ANVIL_PID=$!

    # Wait for anvil to start
    echo "Waiting for Anvil server to start"
    while ! nc -z localhost 8545; do 
        sleep 1
        echo -n .
    done
    echo

    # Run benchmark
    forge script BenchmarkSolidity --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast --skip-simulation --slow 
    
    printf "Last block-number: "
    cast block-number --rpc-url http://localhost:8545   

    # Echo results 
    echo ""
    echo "Benchmark results solidity :"
    echo "=================="
    echo ""

    printf "1    => "
    cast bl 18255676 --field gasUsed --rpc-url http://localhost:8545 

    printf "2    => "
    cast bl 18255677 --field gasUsed --rpc-url http://localhost:8545

    printf "3    => "
    cast bl 18255678 --field gasUsed --rpc-url http://localhost:8545

    printf "4    => "
    cast bl 18255679 --field gasUsed --rpc-url http://localhost:8545

    printf "5    => "
    cast bl 18255680 --field gasUsed --rpc-url http://localhost:8545

    printf "10   => "
    cast bl 18255681 --field gasUsed --rpc-url http://localhost:8545

    printf "20   => "
    cast bl 18255682 --field gasUsed --rpc-url http://localhost:8545

    printf "30   => "
    cast bl 18255683 --field gasUsed --rpc-url http://localhost:8545

    printf "40   => "
    cast bl 18255684 --field gasUsed --rpc-url http://localhost:8545

    printf "50   => "
    cast bl 18255685 --field gasUsed --rpc-url http://localhost:8545

    printf "75   => "
    cast bl 18255686 --field gasUsed --rpc-url http://localhost:8545

    printf "100  => "
    cast bl 18255687 --field gasUsed --rpc-url http://localhost:8545

    printf "200  => "
    cast bl 18255688 --field gasUsed --rpc-url http://localhost:8545

    # End benchmark
    if [ "${PRINT_LOGS}" = "true" ]; then
        echo "Anvil output:"
        cat anvil.log
    fi
    echo "Shutting down Anvil server..."
    kill $ANVIL_PID
    rm -f anvil.log
    sleep 3

}

run_benchmark