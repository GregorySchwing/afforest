cmake_minimum_required(VERSION 3.12)
project(afforest)
cmake_minimum_required(VERSION 3.23.1 FATAL_ERROR)
set(CMAKE_VERBOSE_MAKEFILE ON)

project(afforest VERSION 0.1 LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -Wall")

# Compiler-specific flags
if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -openmp")
elseif (CMAKE_CXX_COMPILER_ID MATCHES "SunPro")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -xO3 -m64 -xtarget=native")
endif()

# Add OpenMP flag if not in serial mode
if (NOT SERIAL)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
endif()

# Find CUDA (if needed)
find_package(CUDA)
if (CUDA_FOUND)
    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -arch=sm_60")
    set(CUDA_PROPAGATE_HOST_FLAGS OFF)
    include_directories(${CUDA_INCLUDE_DIRS})
endif()

# List of kernels and suite
set(KERNELS bc bfs cc cc_afforest pr sssp tc)

set(KERNELS_CUDA cc)
set(SUITE ${KERNELS} converter)

# Add executable targets
foreach(KERNEL ${SUITE})
    add_executable(${KERNEL} src/${KERNEL}.cc)
    target_include_directories(${KERNEL} PUBLIC src deps/cub)
endforeach()

foreach(KERNEL ${KERNELS_CUDA})
    add_executable(${KERNEL}_cuda device/${KERNEL}.cu)
    target_include_directories(${KERNEL}_cuda PUBLIC src deps/cub)
endforeach()

# Testing
#include(test/test.mk)

# Benchmark Automation
#include(benchmark/bench.mk)
# Include the CMakeLists.txt file in the "benchmark" directory
add_subdirectory(benchmark)
# Clean target
add_custom_target(clean-all
    COMMAND ${CMAKE_BUILD_TOOL} clean
    COMMAND rm -f ${SUITE}
    COMMAND rm -rf test/out
    COMMAND rm -rf CMakeFiles CMakeCache.txt cmake_install.cmake
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
