# Generate shared library by default.
SET(BUILD_SHARED_LIBS ON)

# Set default install dir
IF(NOT CMAKE_INSTALL_LIBDIR)
	SET(CMAKE_INSTALL_LIBDIR lib)
ENDIF()

MESSAGE(STATUS "Installation path prefix: " ${CMAKE_INSTALL_PREFIX})
MESSAGE(STATUS "Library installation directory: " ${CMAKE_INSTALL_LIBDIR})

# header files.
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/include)
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/include/gen_target)
# Collect all source files.
file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cpp *.c *.cc)

# Generate shared library lib${PROJECT_NAME}.
ADD_LIBRARY (${PROJECT_NAME} SHARED ${SOURCES} ${GLOB_GRPC_SRCS} ${PROTO_SRCS})
add_dependencies(${PROJECT_NAME}  GRPCTarget)

# Set library version
SET_TARGET_PROPERTIES(
		${PROJECT_NAME}
		PROPERTIES
		SOVERSION ${VERSION_MAJOR}
		VERSION ${VERSION}
)

LINK_DIRECTORIES(${PROJECT_SOURCE_DIR}/lib)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} grpc++_unsecure boost_system protobuf grpc)

# Install to /usr/local/lib by default
INSTALL(
		TARGETS ${PROJECT_NAME}
		LIBRARY
		DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Install header files to /usr/local/include/${PROJECT_NAME}
INSTALL(
		DIRECTORY ${PROJECT_SOURCE_DIR}/include/
		DESTINATION include/${PROJECT_NAME}
)

