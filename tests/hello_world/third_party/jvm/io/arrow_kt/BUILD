licenses(["notice"])
load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_import")
java_library(
    name = "arrow_annotations",
    exports = [
        "//external:jar/io/arrow_kt/arrow_annotations"
    ],
    runtime_deps = [
        "//third_party/jvm/io/kindedj:kindedj",
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_stdlib"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)



java_library(
    name = "arrow_core",
    exports = [
        "//external:jar/io/arrow_kt/arrow_core"
    ],
    runtime_deps = [
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_stdlib_jdk7",
        ":arrow_annotations"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)


