cmake_minimum_required(VERSION 3.12)
project(BenchmarkInfrastructure)

# Compiler flags
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -Wall")

# Create output directory
set(OUTPUT_DIR ${CMAKE_BINARY_DIR}/benchmark/out)
file(MAKE_DIRECTORY ${OUTPUT_DIR})

# List of graph names
set(GRAPHS twitter web road kron urand)

# Generate input graphs
foreach(GRAPH ${GRAPHS})
    add_custom_command(
        OUTPUT ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/${GRAPH}.sg
               ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/${GRAPH}.wsg
               ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/${GRAPH}U.sg
        COMMAND mkdir -p ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
        DEPENDS ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
    )
endforeach()

# Real-world graphs
set(TWITTER_URL http://an.kaist.ac.kr/~haewoon/release/twitter_social_graph/twitter_rv.tar.gz)
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/twitter_rv.tar.gz
           ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/twitter_rv.net
           ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/twitter.el
    COMMAND wget -P ${CMAKE_BINARY_DIR}/benchmark/graphs/raw ${TWITTER_URL}
    COMMAND tar -zxvf ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/twitter_rv.tar.gz -C ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
    COMMAND touch ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/twitter_rv.net
    COMMAND ln -s twitter_rv.net ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/twitter.el
    DEPENDS ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
)

set(ROAD_URL http://www.dis.uniroma1.it/challenge9/data/USA-road-d/USA-road-d.USA.gr.gz)
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/USA-road-d.USA.gr.gz
           ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/USA-road-d.USA.gr
    COMMAND wget -P ${CMAKE_BINARY_DIR}/benchmark/graphs/raw ${ROAD_URL}
    COMMAND gunzip -c ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/USA-road-d.USA.gr.gz > ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/USA-road-d.USA.gr
    DEPENDS ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
)

set(WEB_URL https://www.cise.ufl.edu/research/sparse/MM/LAW/sk-2005.tar.gz)
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/sk-2005.tar.gz
           ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/sk-2005/sk-2005.mtx
    COMMAND wget -P ${CMAKE_BINARY_DIR}/benchmark/graphs/raw ${WEB_URL}
    COMMAND tar -zxvf ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/sk-2005.tar.gz -C ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
    COMMAND touch ${CMAKE_BINARY_DIR}/benchmark/graphs/raw/sk-2005/sk-2005.mtx
    DEPENDS ${CMAKE_BINARY_DIR}/benchmark/graphs/raw
)

# Synthetic graphs
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/benchmark/graphs/kron.sg
           ${CMAKE_BINARY_DIR}/benchmark/graphs/kron.wsg
           ${CMAKE_BINARY_DIR}/benchmark/graphs/kronU.sg
    COMMAND ./converter -g27 -k16 -b ${CMAKE_BINARY_DIR}/benchmark/graphs/kron.sg
    COMMAND ./converter -g27 -k16 -wb ${CMAKE_BINARY_DIR}/benchmark/graphs/kron.wsg
    COMMAND ln -s kron.sg ${CMAKE_BINARY_DIR}/benchmark/graphs/kronU.sg
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/benchmark/graphs/urand.sg
           ${CMAKE_BINARY_DIR}/benchmark/graphs/urand.wsg
           ${CMAKE_BINARY_DIR}/benchmark/graphs/urandU.sg
    COMMAND ./converter -u27 -k16 -b ${CMAKE_BINARY_DIR}/benchmark/graphs/urand.sg
    COMMAND ./converter -u27 -k16 -wb ${CMAKE_BINARY_DIR}/benchmark/graphs/urand.wsg
    COMMAND ln -s urand.sg ${CMAKE_BINARY_DIR}/benchmark/graphs/urandU.sg
)

# Benchmark Execution
# Note: This part should be customized based on how the benchmarks are executed.

# Example: Executing a benchmark for bfs-twitter
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/benchmark/out/bfs-twitter.out
    COMMAND ./bfs -f ${CMAKE_BINARY_DIR}/benchmark/graphs/twitter.sg -n64 > ${CMAKE_BINARY_DIR}/benchmark/out/bfs-twitter.out
    DEPENDS bfs ${CMAKE_BINARY_DIR}/benchmark/graphs/twitter.sg
)

# Add more custom commands for other benchmarks similarly

# Define a custom target for running all benchmarks
add_custom_target(run_benchmarks
    DEPENDS ${CMAKE_BINARY_DIR}/benchmark/out/bfs-twitter.out
    # Add more benchmark dependencies here
)
