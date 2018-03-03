MESSAGE(STATUS "Gen proto file")

find_package(Protobuf REQUIRED)

# GRPC and Protocol Buffers libraries location
list(APPEND CMAKE_PREFIX_PATH "/opt/grpc" "/opt/protobuf")

# Cmake find modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

find_package(Protobuf REQUIRED)
find_package(GRPC REQUIRED)

set(PROTOS_PATH  ${PROJECT_SOURCE_DIR}/protos)
set(PROTOS
    ${PROTOS_PATH}/dbproxy.proto
)

include_directories(${PROTO_SRC_DIR})

file(MAKE_DIRECTORY ${PROJECT_SOURCE_DIR}/include/gen_target)
file(MAKE_DIRECTORY ${PROJECT_SOURCE_DIR}/src/gen_target)
set(PROTO_SRCS "${PROJECT_SOURCE_DIR}/src/gen_target/dbproxy.pb.cc")
set(PROTO_HDRS "${PROJECT_SOURCE_DIR}/include/gen_target/dbproxy.pb.h")
set(GRPC_SRCS "${PROJECT_SOURCE_DIR}/src/gen_target/dbproxy.grpc.pb.cc")
set(GRPC_HDRS "${PROJECT_SOURCE_DIR}/include/gen_target/dbproxy.grpc.pb.h")

add_custom_target(
    GRPCTarget
    COMMAND protoc  --cpp_out "${PROTOS_PATH}" --proto_path "${PROTOS_PATH}" ${PROTOS}
    COMMAND protoc  --grpc_out "${PROTOS_PATH}" --proto_path "${PROTOS_PATH}" --plugin=protoc-gen-grpc="/usr/local/bin/grpc_cpp_plugin" ${PROTOS}
    COMMAND cp ${PROTOS_PATH}/*.cc ${PROJECT_SOURCE_DIR}/src/gen_target
    COMMAND cp ${PROTOS_PATH}/*.h ${PROJECT_SOURCE_DIR}/include/gen_target
    COMMAND rm ${PROTOS_PATH}/*.cc
    COMMAND rm ${PROTOS_PATH}/*.h
)







set(GLOB_PROTO_SRCS "${PROTO_SRCS}" CACHE INTERNAL "glob proto srcs" )
set(GLOB_PROTO_HDRS "${PROTO_HDRS}" CACHE INTERNAL "glob proto hdrs" )
set(GLOB_GRPC_SRCS "${GRPC_SRCS}" CACHE INTERNAL "glob grpc srcs" )
set(GLOB_GRPC_HDRS "${GRPC_HDRS}" CACHE INTERNAL "glob grpc hdrs" )



set(SRC_DIRS "src" )
set(SRC_DIRS ${SRC_DIRS} "protos")

