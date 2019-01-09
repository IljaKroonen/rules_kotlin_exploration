load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_test")

kt_jvm_test(
    name = "UtilsTest",
    srcs = glob([
        "UtilsTest.kt",
    ]),
    test_class = "com.github.iljakroonen.utils.UtilsTest",
    deps = [
        "//third_party:test_deps",
        "//utils/src/main/kotlin/com/github/iljakroonen/utils",
    ],
)
