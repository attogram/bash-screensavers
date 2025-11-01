#!/bin/bash


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TEST_LIBS_DIR="${SCRIPT_DIR}/test_libs"

# Create a directory for the test dependencies
mkdir -p ${TEST_LIBS_DIR}

# Download and extract bats-core
BATS_CORE_VERSION="v1.12.0"
BATS_CORE_DIR="${TEST_LIBS_DIR}/bats-core-${BATS_CORE_VERSION#v}"
if [ ! -d "${BATS_CORE_DIR}" ]; then
    echo "Downloading bats-core..."
    wget -O "${TEST_LIBS_DIR}/bats-core.tar.gz" "https://github.com/bats-core/bats-core/archive/refs/tags/${BATS_CORE_VERSION}.tar.gz"
    tar -xzf "${TEST_LIBS_DIR}/bats-core.tar.gz" -C "${TEST_LIBS_DIR}"
    rm "${TEST_LIBS_DIR}/bats-core.tar.gz"
fi

# Download and extract bats-support
BATS_SUPPORT_VERSION="v0.3.0"
BATS_SUPPORT_DIR="${TEST_LIBS_DIR}/bats-support-${BATS_SUPPORT_VERSION#v}"
if [ ! -d "${BATS_SUPPORT_DIR}" ]; then
    echo "Downloading bats-support..."
    wget -O "${TEST_LIBS_DIR}/bats-support.tar.gz" "https://github.com/bats-core/bats-support/archive/refs/tags/${BATS_SUPPORT_VERSION}.tar.gz"
    tar -xzf "${TEST_LIBS_DIR}/bats-support.tar.gz" -C "${TEST_LIBS_DIR}"
    rm "${TEST_LIBS_DIR}/bats-support.tar.gz"
fi

# Download and extract bats-assert
BATS_ASSERT_VERSION="v2.2.0"
BATS_ASSERT_DIR="${TEST_LIBS_DIR}/bats-assert-${BATS_ASSERT_VERSION#v}"
if [ ! -d "${BATS_ASSERT_DIR}" ]; then
    echo "Downloading bats-assert..."
    wget -O "${TEST_LIBS_DIR}/bats-assert.tar.gz" "https://github.com/bats-core/bats-assert/archive/refs/tags/${BATS_ASSERT_VERSION}.tar.gz"
    tar -xzf "${TEST_LIBS_DIR}/bats-assert.tar.gz" -C "${TEST_LIBS_DIR}"
    rm "${TEST_LIBS_DIR}/bats-assert.tar.gz"
fi


echo "Bats and its dependencies have been installed in ${TEST_LIBS_DIR}"
echo "You can now run the tests using: ./${TEST_LIBS_DIR}/bats-core-${BATS_CORE_VERSION#v}/bin/bats jury"
