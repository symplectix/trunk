workspace(name = "trunk")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Skylib

_SKYLIB_VERSION = "1.2.1"

_SKYLIB_SHA256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728"

http_archive(
    name = "bazel_skylib",
    sha256 = _SKYLIB_SHA256,
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/{ver}/bazel-skylib-{ver}.tar.gz".format(ver = _SKYLIB_VERSION),
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/{ver}/bazel-skylib-{ver}.tar.gz".format(ver = _SKYLIB_VERSION),
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

# CC

_RULES_FOREIGN_CC_VERSION = "0.7.1"

_RULES_FOREIGN_CC_SHA256 = "bcd0c5f46a49b85b384906daae41d277b3dc0ff27c7c752cc51e43048a58ec83"

http_archive(
    name = "rules_foreign_cc",
    sha256 = _RULES_FOREIGN_CC_SHA256,
    strip_prefix = "rules_foreign_cc-{}".format(_RULES_FOREIGN_CC_VERSION),
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/{}.tar.gz".format(_RULES_FOREIGN_CC_VERSION),
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies()

# Rust

# `Digest::compute` in cargo-bazel seems to return a different result for linux and macos.
# _RUST_VERSION = "1.60.0"

_RUST_VERSION = "1.59.0"

_RUST_EDITION = "2018"

_RULES_RUST_VERSION = "0.2.1"

_RULES_RUST_SHA256 = "b58c63a6d8221f408f8852b4f74f81bc8c7aac9273f3899a74e32e6168a2c624"

http_archive(
    name = "rules_rust",
    sha256 = _RULES_RUST_SHA256,
    urls = [
        "https://github.com/bazelbuild/rules_rust/releases/download/{ver}/rules_rust-v{ver}.tar.gz".format(ver = _RULES_RUST_VERSION),
        "https://mirror.bazel.build/github.com/bazelbuild/rules_rust/releases/download/{ver}/rules_rust-v{ver}.tar.gz".format(ver = _RULES_RUST_VERSION),
    ],
)

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")

rules_rust_dependencies()

rust_register_toolchains(
    edition = _RUST_EDITION,
    include_rustc_srcs = True,
    version = _RUST_VERSION,
)

load("@rules_rust//bindgen:repositories.bzl", "rust_bindgen_repositories")

rust_bindgen_repositories()

# load("@rules_rust//wasm_bindgen:repositories.bzl", "rust_wasm_bindgen_repositories")

# rust_wasm_bindgen_repositories()

load("@rules_rust//crate_universe:repositories.bzl", "crate_universe_dependencies")

crate_universe_dependencies(
    # If true, a cargo_bootstrap_repository target will be generated.
    # bootstrap = True,
    rust_version = _RUST_VERSION,
)

load("@rules_rust//crate_universe:defs.bzl", "crates_repository", "splicing_config")
load("//build/rust:packages.bzl", "packages")

crates_repository(
    name = "crates",
    lockfile = "//build/rust:crates.lock",
    packages = packages,
    rust_version = _RUST_VERSION,
    splicing_config = splicing_config(
        resolver_version = "2",
    ),
)

load("@crates//:defs.bzl", "crate_repositories")

crate_repositories()

load("@rules_rust//tools/rust_analyzer:deps.bzl", "rust_analyzer_deps")

rust_analyzer_deps()

# NodeJS

_RULES_NODEJS_VERSION = "5.4.0"

_RULES_NODEJS_SHA256 = "2b2004784358655f334925e7eadc7ba80f701144363df949b3293e1ae7a2fb7b"

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = _RULES_NODEJS_SHA256,
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/{ver}/rules_nodejs-{ver}.tar.gz".format(ver = _RULES_NODEJS_VERSION)],
)

load("@build_bazel_rules_nodejs//:repositories.bzl", "build_bazel_rules_nodejs_dependencies")

build_bazel_rules_nodejs_dependencies()

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories", "yarn_install")

node_repositories(
    node_version = "16.14.2",
    yarn_version = "1.22.18",
)

yarn_install(
    # Name this npm so that Bazel Label references look like @npm//package
    name = "npm",
    package_json = "//build/nodejs:package.json",
    yarn_lock = "//build/nodejs:yarn.lock",
)

# Go

_GO_VERSION = "1.18.1"

_RULES_GO_VERSION = "0.31.0"

_RULES_GO_SHA256 = "f2dcd210c7095febe54b804bb1cd3a58fe8435a909db2ec04e31542631cf715c"

_GAZELLE_VERSION = "0.24.0"

_GAZELLE_SHA256 = "de69a09dc70417580aabf20a28619bb3ef60d038470c7cf8442fafcf627c21cb"

http_archive(
    name = "io_bazel_rules_go",
    sha256 = _RULES_GO_SHA256,
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v{ver}/rules_go-v{ver}.zip".format(ver = _RULES_GO_VERSION),
        "https://github.com/bazelbuild/rules_go/releases/download/v{ver}/rules_go-v{ver}.zip".format(ver = _RULES_GO_VERSION),
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = _GAZELLE_SHA256,
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v{ver}/bazel-gazelle-v{ver}.tar.gz".format(ver = _GAZELLE_VERSION),
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v{ver}/bazel-gazelle-v{ver}.tar.gz".format(ver = _GAZELLE_VERSION),
    ],
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = _GO_VERSION)

gazelle_dependencies()

# Protocol Buffers

_PROTOBUF_VERSION = "3.20.0"

_RULES_PROTO_VERSION = "4.0.0"

_RULES_PROTO_SHA256 = "e017528fd1c91c5a33f15493e3a398181a9e821a804eb7ff5acdd1d2d6c2b18d"

http_archive(
    name = "rules_proto",
    sha256 = _RULES_PROTO_SHA256,
    strip_prefix = "rules_proto-{}-{}".format(_RULES_PROTO_VERSION, _PROTOBUF_VERSION),
    urls = [
        "https://github.com/bazelbuild/rules_proto/archive/{}-{}.tar.gz".format(_RULES_PROTO_VERSION, _PROTOBUF_VERSION),
    ],
)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

# Docker

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "85ffff62a4c22a74dbd98d05da6cf40f497344b3dbf1e1ab0a37ab2a1a6ca014",
    strip_prefix = "rules_docker-0.23.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.23.0/rules_docker-v0.23.0.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

container_repositories()

load("@io_bazel_rules_docker//rust:image.bzl", _rust_image_repos = "repositories")

_rust_image_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

# Bazel Buildtools

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3",
    strip_prefix = "buildtools-4.2.2",
    urls = [
        "https://github.com/bazelbuild/buildtools/archive/refs/tags/4.2.2.tar.gz",
    ],
)

# BuildBuddy

http_archive(
    name = "io_buildbuddy_buildbuddy_toolchain",
    sha256 = "a2a5cccec251211e2221b1587af2ce43c36d32a42f5d881737db3b546a536510",
    strip_prefix = "buildbuddy-toolchain-829c8a574f706de5c96c54ca310f139f4acda7dd",
    urls = ["https://github.com/buildbuddy-io/buildbuddy-toolchain/archive/829c8a574f706de5c96c54ca310f139f4acda7dd.tar.gz"],
)

load("@io_buildbuddy_buildbuddy_toolchain//:deps.bzl", "buildbuddy_deps")

buildbuddy_deps()

load("@io_buildbuddy_buildbuddy_toolchain//:rules.bzl", "buildbuddy")

buildbuddy(name = "buildbuddy_toolchain")