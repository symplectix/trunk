load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_RUST_EDITION = "2021"

_RUST_STABLE_VERSION = "1.77.0"

# https://github.com/oxalica/rust-overlay/tree/master/manifests/nightly
_RUST_NIGHTLY_VERSION = "nightly/2024-03-27"

_GO_VERSION = "1.22.1"

versions = struct(
    rust = struct(
        edition = _RUST_EDITION,
        versions = [
            _RUST_STABLE_VERSION,
            _RUST_NIGHTLY_VERSION,
        ],
    ),
    go = struct(
        version = _GO_VERSION,
    ),
)

_http_archives = {
    "rules_foreign_cc": {
        "sha256": "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
        "strip_prefix": "rules_foreign_cc-0.9.0",
        "url": "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.9.0.tar.gz",
    },
    "zlib": {
        "build_file": "//x/zlib:BUILD.zlib.bazel",
        "sha256": "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23",
        "strip_prefix": "zlib-1.3.1",
        "urls": [
            "https://zlib.net/zlib-1.3.1.tar.gz",
            "https://storage.googleapis.com/mirror.tensorflow.org/zlib.net/zlib-1.3.1.tar.gz",
        ],
    },
    "openssl": {
        "build_file": "//x/openssl:BUILD.openssl.bazel",
        "sha256": "83c7329fe52c850677d75e5d0b0ca245309b97e8ecbcfdc1dfdc4ab9fac35b39",
        "strip_prefix": "openssl-3.2.1",
        "urls": [
            "https://www.openssl.org/source/openssl-3.2.1.tar.gz",
        ],
    },
    "rules_rust": {
        "integrity": "sha256-Y4v6kjQQfXxh5tU6FQB6YXux/ODFGUq3IlpgBV4Bwj8=",
        "urls": ["https://github.com/bazelbuild/rules_rust/releases/download/0.41.0/rules_rust-v0.41.0.tar.gz"],
    },
    "io_bazel_rules_go": {
        "sha256": "80a98277ad1311dacd837f9b16db62887702e9f1d1c4c9f796d0121a46c8e184",
        "urls": [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.46.0/rules_go-v0.46.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.46.0/rules_go-v0.46.0.zip",
        ],
    },
    "rules_proto": {
        "sha256": "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
        "strip_prefix": "rules_proto-5.3.0-21.7",
        "urls": [
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
        ],
    },
    "rules_proto_grpc": {
        "sha256": "928e4205f701b7798ce32f3d2171c1918b363e9a600390a25c876f075f1efc0a",
        "strip_prefix": "rules_proto_grpc-4.4.0",
        "urls": ["https://github.com/rules-proto-grpc/rules_proto_grpc/releases/download/4.4.0/rules_proto_grpc-4.4.0.tar.gz"],
    },
    "bazel_gazelle": {
        "sha256": "32938bda16e6700063035479063d9d24c60eda8d79fd4739563f50d331cb3209",
        "urls": [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.35.0/bazel-gazelle-v0.35.0.tar.gz",
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.35.0/bazel-gazelle-v0.35.0.tar.gz",
        ],
    },
    "com_github_bazelbuild_buildtools": {
        "sha256": "061472b3e8b589fb42233f0b48798d00cf9dee203bd39502bd294e6b050bc6c2",
        "strip_prefix": "buildtools-7.1.0",
        "urls": ["https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.0.tar.gz"],
    },
    "rules_pkg": {
        "sha256": "d250924a2ecc5176808fc4c25d5cf5e9e79e6346d79d5ab1c493e289e722d1d0",
        "urls": [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.10.1/rules_pkg-0.10.1.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.10.1/rules_pkg-0.10.1.tar.gz",
        ],
    },
    "rules_oci": {
        "sha256": "56d5499025d67a6b86b2e6ebae5232c72104ae682b5a21287770bd3bf0661abf",
        "strip_prefix": "rules_oci-1.7.5",
        "url": "https://github.com/bazel-contrib/rules_oci/releases/download/v1.7.5/rules_oci-v1.7.5.tar.gz",
    },
    "container_structure_test": {
        "sha256": "978db1ed0f802120fb0308b08b5c1e38ea81377944cc7a2fb727529815e4ed09",
        "strip_prefix": "container-structure-test-1.17.0",
        "urls": ["https://github.com/GoogleContainerTools/container-structure-test/archive/v1.17.0.zip"],
    },
}

_http_files = {
    "target-determinator_linux_x86_64": {
        "executable": True,
        "sha256": "5200dbca0dd4980690d5060cf8e04abac927efaca143567c51fe24cf973364d2",
        "url": "https://github.com/bazel-contrib/target-determinator/releases/download/v0.23.0/target-determinator.linux.amd64",
    },
    "target-determinator_macos_x86_64": {
        "executable": True,
        "sha256": "aba6dce8a978d2174b37dd1355eecba86db93be1ff77742d0753d8efd6a8a316",
        "url": "https://github.com/bazel-contrib/target-determinator/releases/download/v0.23.0/target-determinator.darwin.amd64",
    },
    "target-determinator_macos_arm64": {
        "executable": True,
        "sha256": "6c3c308dcfc651408ed5490245ea3e0180fc49d4cc9b762ab84a4b979bcb07b8",
        "url": "https://github.com/bazel-contrib/target-determinator/releases/download/v0.23.0/target-determinator.darwin.arm64",
    },
    "target-determinator-driver_linux_x86_64": {
        "executable": True,
        "sha256": "28b6570c637a99c78ee53524967bc7e0fd7b16a29fbfb9d081fbc214a56ea0f6",
        "url": "https://github.com/bazel-contrib/target-determinator/releases/download/v0.23.0/driver.linux.amd64",
    },
    "target-determinator-driver_macos_x86_64": {
        "executable": True,
        "sha256": "6c9e30f3207f592de588c8cdaa90b53577ec38d3ff48c9a00c8d8b0217ecc990",
        "url": "https://github.com/bazel-contrib/target-determinator/releases/download/v0.23.0/driver.darwin.amd64",
    },
    "target-determinator-driver_macos_arm64": {
        "executable": True,
        "sha256": "41b957c671c4a3cdef83a9cda66eb1042fa1e7b00cc0e5eec9640579ad841f9f",
        "url": "https://github.com/bazel-contrib/target-determinator/releases/download/v0.23.0/driver.darwin.arm64",
    },
}

_toolchains = [
    "//toolchains:prost_toolchain",
]

def workspace_dependencies():
    for name in _http_archives:
        maybe(http_archive, name, **_http_archives[name])

    for name in _http_files:
        maybe(http_file, name, **_http_files[name])

# buildifier: disable=unnamed-macro
def workspace_toolchains():
    for tc in _toolchains:
        native.register_toolchains(tc)
