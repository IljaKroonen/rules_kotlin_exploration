def _kt_jvm_library_impl(ctx):
    src_files = []
    src_file_paths = []

    for src in ctx.attr.srcs:
        for file in src.files:
            src_files.append(file)
            src_file_paths.append(file.path)

    dep_jars = []
    runtime_deps = [
        JavaInfo(
            output_jar = ctx.attr._kotlin_stdlib.files.to_list()[0],
            compile_jar = ctx.attr._kotlin_stdlib.files.to_list()[0],
        ),
    ]
    for dep in ctx.attr.deps:
        java_info = dep[JavaInfo]
        runtime_deps.append(java_info)
        dep_jars += java_info.compile_jars.to_list()
    for dep in ctx.attr.runtime_deps:
        java_info = dep[JavaInfo]
        runtime_deps.append(java_info)

    compile_cp = []
    for dep_jar in dep_jars:
        compile_cp.append(dep_jar.path)

    # Dirty hack for finding JDK home
    # There is probably a proper way to do it
    jdk_file = ctx.attr._java_runtime.files.to_list()[0]
    if jdk_file.dirname.endswith("/jre/bin"):
        jdk_home = jdk_file.dirname[:-len("/jre/bin")]
    elif jdk_file.dirname.endswith("/jre/lib"):
        jdk_home = jdk_file.dirname[:-len("/jre/bin")]
    else:
        jdk_home = jdk_file.dirname[:-4]

    compile_kotlin_deploy_jar = ctx.attr._compile_kotlin.files.to_list()[0]

    module_name = ctx.label.package.replace("/", "_") + "-" + ctx.label.name
    ctx.actions.run(
        executable = "%s/jre/bin/java" % jdk_home,
        inputs = src_files + dep_jars + ctx.attr._java_runtime.files.to_list() + ctx.attr._compile_kotlin.files.to_list(),
        tools = ctx.attr._compiler.data_runfiles.files.to_list(),
        progress_message = """Compiling %s kotlin source files""" % len(ctx.attr.srcs),
        arguments = [
            "-jar",
            compile_kotlin_deploy_jar.path,
            "external/org_jetbrains_kotlin/bin/kotlinc",
            jdk_home,
            ctx.host_configuration.host_path_separator.join(src_file_paths),
            ctx.host_configuration.host_path_separator.join(compile_cp),
            ctx.outputs.jar.path,
            module_name,
            ctx.outputs.srcjar.path,
        ],
        outputs = [
            ctx.outputs.jar,
            ctx.outputs.srcjar,
        ],
        mnemonic = "KotlinCompile",
        use_default_shell_env = False,
    )

    exports = []
    for export in ctx.attr.exports:
        exports.append(export[JavaInfo])

    return [
        JavaInfo(
            output_jar = ctx.outputs.jar,
            compile_jar = ctx.outputs.jar,
            runtime_deps = runtime_deps,
            exports = exports,
        ),
    ]

kt_jvm_library = rule(
    doc = """This rule compiles and links kotlin sources into a .jar file.""",
    implementation = _kt_jvm_library_impl,
    attrs = {
        "_compiler": attr.label(
            default = Label("@org_jetbrains_kotlin//:kotlinc_files"),
        ),
        "_kotlin_stdlib": attr.label(
            default = Label("@org_jetbrains_kotlin//:kotlin-stdlib"),
        ),
        "_java_runtime": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
        ),
        "_compile_kotlin": attr.label(
            default = Label("@com_github_iljakroonen_rules_kotlin//src/main/java/com/github/iljakroonen/rules/kotlin:CompileKotlin_deploy.jar"),
            allow_single_file = True,
        ),
        "deps": attr.label_list(
            doc = """The list of libraries to link into this library.""",
            providers = [
                [JavaInfo],
            ],
            allow_files = False,
        ),
        "runtime_deps": attr.label_list(
            doc = """Libraries to make available to the final binary or test at runtime only. Like ordinary deps, these will appear on the runtime classpath, but unlike them, not on the compile-time classpath. Dependencies needed only at runtime should be listed here.""",
            providers = [
                [JavaInfo],
            ],
            allow_files = False,
        ),
        "srcs": attr.label_list(
            doc = """The list of source files that are processed to create the target.""",
            allow_files = [".kt"],
            default = [],
        ),
        "exports": attr.label_list(
            doc = """Exported libraries.""",
            providers = [
                [JavaInfo],
            ],
            allow_files = False,
        ),
    },
    provides = [JavaInfo],
    outputs = {
        "jar": "%{name}.jar",
        "srcjar": "%{name}-sources.jar",
    },
)

def _kt_jvm_import_impl(ctx):
    first_jar = None
    deps = []

    for jar in ctx.attr.jars:
        for file in jar.files:
            if not file.basename.endswith("-sources.jar"):
                if first_jar == None:
                    first_jar = file
                else:
                    deps.append(JavaInfo(
                        output_jar = file,
                        compile_jar = file,
                    ))

    runtime_deps = []
    for runtime_dep in ctx.attr.runtime_deps:
        java_info = runtime_dep[JavaInfo]
        runtime_deps.append(java_info)

    return java_common.merge([JavaInfo(
        output_jar = first_jar,
        compile_jar = first_jar,
        runtime_deps = runtime_deps + deps,
    )] + deps)

kt_jvm_import = rule(
    doc = """This rule allows the use of precompiled .jar files as libraries for kt_jvm_import rules.""",
    attrs = {
        "jars": attr.label_list(
            allow_files = True,
            mandatory = True,
            cfg = "target",
        ),
        "srcjar": attr.label(
            allow_single_file = True,
            cfg = "target",
        ),
        "runtime_deps": attr.label_list(
            default = [],
            providers = [JavaInfo],
        ),
    },
    implementation = _kt_jvm_import_impl,
    provides = [JavaInfo],
)

def kt_jvm_test(
        name,
        srcs,
        test_class,
        deps = [],
        data = [],
        resources = [],
        jvm_flags = None,
        local = None,
        visibility = None,
        size = "medium",
        tags = []):
    kt_jvm_library(
        name = "%s_lib" % name,
        deps = deps,
        srcs = srcs,
        visibility = ["//visibility:private"],
    )

    native.java_test(
        name = name,
        runtime_deps = [":%s_lib" % name],
        data = data,
        resources = resources,
        test_class = test_class,
        visibility = visibility,
        local = local,
        jvm_flags = jvm_flags,
        size = size,
        tags = tags,
    )
