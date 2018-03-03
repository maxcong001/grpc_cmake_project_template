PROJECT(grpcwrapper)
# Minimum CMake required
cmake_minimum_required(VERSION 3.3)

ENABLE_TESTING()

SET(VERSION_MAJOR 0)
SET(VERSION_MINOR 0)
SET(VERSION_PATCH 1)
SET(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# Options controlling whether build internal testing binaries or not.
# Default is OFF so that libary users can build it directly without patch file
OPTION(ENABLE_TEST "Build test files" OFF)

SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(TESTS_BINARY tests)
SET(EXAMPLE_BINARY example)

# set compiler flags
IF(ENABLE_TEST)
    # disable optimization for testing version
    set(CCXX_FLAGS "-Wall -O0 -g -DNDEBUG -fno-omit-frame-pointer")
ELSE()
    set(CCXX_FLAGS "-Wall -O2 -g -DNDEBUG -fno-omit-frame-pointer")
ENDIF()

set(CXX_FLAGS "-std=c++11 -fPIC")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CCXX_FLAGS} -march=native")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CCXX_FLAGS} ${CXX_FLAGS}")

MESSAGE(STATUS "Project : " ${PROJECT_NAME})
MESSAGE(STATUS "Project Directory: " ${PROJECT_SOURCE_DIR})
MESSAGE(STATUS "Library output directory: " ${LIBRARY_OUTPUT_PATH})
MESSAGE(STATUS "CMAKE_C_FLAGS: " ${CMAKE_C_FLAGS})
MESSAGE(STATUS "CMAKE_CXX_FLAGS: " ${CMAKE_CXX_FLAGS})

find_package(Boost REQUIRED)
#find_package(Protobuf REQUIRED)
message(STATUS "Using protobuf ${protobuf_VERSION}")
#find_package(gRPC CONFIG REQUIRED)

# proto file
ADD_SUBDIRECTORY(protos)

ADD_SUBDIRECTORY(src)
IF(ENABLE_TEST)
    ADD_SUBDIRECTORY(tests)
ENDIF()
    ADD_SUBDIRECTORY(examples)

SEPARATE_ARGUMENTS(CMD_ARGS)
ADD_CUSTOM_TARGET(example
	COMMAND ./${EXAMPLE_BINARY} ${CMD_ARGS}
	WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
	COMMENT "Run examples"
)
ADD_CUSTOM_TARGET(tests
        COMMAND ./${TEST_BINARY} ${CMD_ARGS}
        WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
        COMMENT "Run test"
)
ADD_CUSTOM_TARGET(memcheck
	COMMAND command -v valgrind >/dev/null 2>&1 && valgrind -v --leak-check=full --show-reachable=yes
	--undef-value-errors=yes --track-origins=yes --num-callers=50 --suppressions=${PROJECT_SOURCE_DIR}/tests/valgrind.supp ./${EXAMPLE_BINARY} ${CMD_ARGS}
	WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
	COMMENT "Check memory usage with valgrind"
)