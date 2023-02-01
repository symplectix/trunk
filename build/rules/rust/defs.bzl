load(
    "@rules_rust//rust:defs.bzl",
    _rust_binary = "rust_binary",
    _rust_doc = "rust_doc",
    _rust_doc_test = "rust_doc_test",
    _rust_library = "rust_library",
    _rust_test = "rust_test",
    _rust_test_suite = "rust_test_suite",
)

rust_binary = _rust_binary
rust_doc = _rust_doc
rust_doc_test = _rust_doc_test
rust_library = _rust_library
rust_test = _rust_test
rust_test_suite = _rust_test_suite

def rust_fuzzing(
        name,
        sanitizer = None,
        **bin_kwargs):
    """Helps to fuzzing.
    """

    rustc_flags = [
        "--cfg",
        "fuzzing",
        "-Zsanitizer={}".format(sanitizer),
    ]

    rust_binary(
        name = name,
        rustc_flags = select({
            "@rules_rust//rust/toolchain/channel:nightly": rustc_flags,
            "//conditions:default": [],
        }),
        # target_compatible_with = [
        #     "@rules_rust//rust/platform/channel:nightly",
        # ],
        **bin_kwargs
    )

    return
