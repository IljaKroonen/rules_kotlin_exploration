genrule(
    name = "rename_java_file_jarhelper",
    srcs = [
        "@io_bazel_jarhelper_java//file",
    ],
    outs = [
        "JarHelper.java",
    ],
    cmd = "cp $(location @io_bazel_jarhelper_java//file) $@",
)

genrule(
    name = "rename_java_file_jarcreator",
    srcs = [
        "@io_bazel_jarcreator_java//file",
    ],
    outs = [
        "JarCreator.java",
    ],
    cmd = "cp $(location @io_bazel_jarcreator_java//file) $@",
)

java_library(
    name = "jarhelper",
    srcs = [
        ":rename_java_file_jarcreator",
        ":rename_java_file_jarhelper",
    ],
)

java_binary(
    name = "CompileKotlin",
    srcs = glob([
        "*.java",
    ]),
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "jarhelper",
    ],
)
