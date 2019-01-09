load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_test")

kt_jvm_test(
    name = "AddTest",
    srcs = ["AddTest.kt"],
    test_class = "com.github.iljakroonen.add.AddTest",
    deps = [
        "//add/src/main/kotlin/com/github/iljakroonen/add",
        "//third_party:test_deps",
    ],
)
