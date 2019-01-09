licenses(["notice"])
load("@com_github_iljakroonen_rules_kotlin//:kotlin.bzl", "kt_jvm_import")
kt_jvm_import(
    name = "kotlintest_assertions",
    jars = [
        "//external:jar/io/kotlintest/kotlintest_assertions"
    ],
    runtime_deps = [
        "//third_party/jvm/com/univocity:univocity_parsers",
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_reflect",
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_stdlib"
    ],
    visibility = [
        "//visibility:public"
    ]
)



kt_jvm_import(
    name = "kotlintest_core",
    jars = [
        "//external:jar/io/kotlintest/kotlintest_core"
    ],
    runtime_deps = [
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_reflect",
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_stdlib"
    ],
    visibility = [
        "//visibility:public"
    ]
)



kt_jvm_import(
    name = "kotlintest_runner_junit4",
    jars = [
        "//external:jar/io/kotlintest/kotlintest_runner_junit4"
    ],
    runtime_deps = [
        "//third_party/jvm/junit:junit",
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_stdlib",
        ":kotlintest_assertions",
        ":kotlintest_core",
        ":kotlintest_runner_jvm"
    ],
    visibility = [
        "//visibility:public"
    ]
)



java_library(
    name = "kotlintest_runner_jvm",
    exports = [
        "//external:jar/io/kotlintest/kotlintest_runner_jvm"
    ],
    runtime_deps = [
        "//third_party/jvm/io/arrow_kt:arrow_core",
        "//third_party/jvm/org/jetbrains/kotlin:kotlin_stdlib",
        "//third_party/jvm/org/reflections:reflections",
        "//third_party/jvm/org/slf4j:slf4j_api",
        ":kotlintest_core"
    ],
    visibility = [
        "//third_party/jvm:__subpackages__"
    ]
)


