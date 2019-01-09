# Do not edit. bazel-deps autogenerates this file from third_party/dependencies.yaml.
def _jar_artifact_impl(ctx):
    jar_name = "%s.jar" % ctx.name
    ctx.download(
        output=ctx.path("jar/%s" % jar_name),
        url=ctx.attr.urls,
        sha256=ctx.attr.sha256,
        executable=False
    )
    src_name="%s-sources.jar" % ctx.name
    srcjar_attr=""
    has_sources = len(ctx.attr.src_urls) != 0
    if has_sources:
        ctx.download(
            output=ctx.path("jar/%s" % src_name),
            url=ctx.attr.src_urls,
            sha256=ctx.attr.src_sha256,
            executable=False
        )
        srcjar_attr ='\n    srcjar = ":%s",' % src_name

    build_file_contents = """
package(default_visibility = ['//visibility:public'])
java_import(
    name = 'jar',
    tags = ['maven_coordinates={artifact}'],
    jars = ['{jar_name}'],{srcjar_attr}
)
filegroup(
    name = 'file',
    srcs = [
        '{jar_name}',
        '{src_name}'
    ],
    visibility = ['//visibility:public']
)\n""".format(artifact = ctx.attr.artifact, jar_name = jar_name, src_name = src_name, srcjar_attr = srcjar_attr)
    ctx.file(ctx.path("jar/BUILD"), build_file_contents, False)
    return None

jar_artifact = repository_rule(
    attrs = {
        "artifact": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "urls": attr.string_list(mandatory = True),
        "src_sha256": attr.string(mandatory = False, default=""),
        "src_urls": attr.string_list(mandatory = False, default=[]),
    },
    implementation = _jar_artifact_impl
)

def jar_artifact_callback(hash):
    src_urls = []
    src_sha256 = ""
    source=hash.get("source", None)
    if source != None:
        src_urls = [source["url"]]
        src_sha256 = source["sha256"]
    jar_artifact(
        artifact = hash["artifact"],
        name = hash["name"],
        urls = [hash["url"]],
        sha256 = hash["sha256"],
        src_urls = src_urls,
        src_sha256 = src_sha256
    )
    native.bind(name = hash["bind"], actual = hash["actual"])


def list_dependencies():
    return [
    {"artifact": "com.google.guava:guava:20.0", "lang": "java", "sha1": "89507701249388e1ed5ddcf8c41f4ce1be7831ef", "sha256": "36a666e3b71ae7f0f0dca23654b67e086e6c93d192f60ba5dfd5519db6c288c8", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/guava/20.0/guava-20.0.jar", "source": {"sha1": "9c8493c7991464839b612d7547d6c263adf08f75", "sha256": "994be5933199a98e98bd09584da2bb69ed722275f6bed61d83459af88ace5cbd", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/guava/20.0/guava-20.0-sources.jar"} , "name": "com_google_guava_guava", "actual": "@com_google_guava_guava//jar", "bind": "jar/com/google/guava/guava"},
    {"artifact": "com.univocity:univocity-parsers:2.6.1", "lang": "java", "sha1": "f6f41322f4d2b4677d0c3b59ab33e745896637de", "sha256": "1ee99d24f0b29c80b84345fe9dad90d6faa7913cd85ad493e7fe79648e70c5b4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/univocity/univocity-parsers/2.6.1/univocity-parsers-2.6.1.jar", "source": {"sha1": "529316542d7fa9d92ef0e73522b4975f84cb24bd", "sha256": "769c3e96923f3f59f4469d4bfe4e26d8517d2f485bfc15dd5ee6dca7ff85f537", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/univocity/univocity-parsers/2.6.1/univocity-parsers-2.6.1-sources.jar"} , "name": "com_univocity_univocity_parsers", "actual": "@com_univocity_univocity_parsers//jar", "bind": "jar/com/univocity/univocity_parsers"},
    {"artifact": "io.arrow-kt:arrow-annotations:0.7.1", "lang": "java", "sha1": "391929cd47d022b989b0a80e6d4395e0807191f0", "sha256": "c8ed1cd7dc1a2c1817bb950f98f34621131b5948023a04f0020054a66cc14589", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/arrow-kt/arrow-annotations/0.7.1/arrow-annotations-0.7.1.jar", "source": {"sha1": "4c0a5a4ada86b86809d08c914dd57844ba71b10a", "sha256": "ea95843435f6607f9b0d95f420e51154af1aabaaea4dd88230e5d91f5b16537a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/arrow-kt/arrow-annotations/0.7.1/arrow-annotations-0.7.1-sources.jar"} , "name": "io_arrow_kt_arrow_annotations", "actual": "@io_arrow_kt_arrow_annotations//jar", "bind": "jar/io/arrow_kt/arrow_annotations"},
    {"artifact": "io.arrow-kt:arrow-core:0.7.1", "lang": "java", "sha1": "6258e5f2afd375ef6fd12161a590d6fcc3549361", "sha256": "160c0e84ba051f4026a491686606eba2c4461cfd5b3bf07c99afd41ce68eb4bb", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/arrow-kt/arrow-core/0.7.1/arrow-core-0.7.1.jar", "source": {"sha1": "4085809f9a16449fa64cd3f741623bae7c67e227", "sha256": "ba33539a260a03112316e894afa045d43ecb12704f4cdccd758d2fca017d72f8", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/arrow-kt/arrow-core/0.7.1/arrow-core-0.7.1-sources.jar"} , "name": "io_arrow_kt_arrow_core", "actual": "@io_arrow_kt_arrow_core//jar", "bind": "jar/io/arrow_kt/arrow_core"},
    {"artifact": "io.kindedj:kindedj:1.1.0", "lang": "java", "sha1": "462731347602a3f24e3f21feec50928f9a657741", "sha256": "c8786c94de34869f087d28b52777374cbb349d827673044c56c63678b448f3f8", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kindedj/kindedj/1.1.0/kindedj-1.1.0.jar", "source": {"sha1": "3d0b22938dc6ddc667f628533a8d625935817bc0", "sha256": "d2c5784e857f9c4538cc37c1ca8ed55c9411eec50d5bb7eb7613f96fba38085f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kindedj/kindedj/1.1.0/kindedj-1.1.0-sources.jar"} , "name": "io_kindedj_kindedj", "actual": "@io_kindedj_kindedj//jar", "bind": "jar/io/kindedj/kindedj"},
    {"artifact": "io.kotlintest:kotlintest-assertions:3.1.9", "lang": "kotlin", "sha1": "1947e5bfe82213bb560191ead8069f5fdc111497", "sha256": "b8f5a6cd698e2075d17123060d23d80f53a38dd595434d87c878e7562c86b443", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-assertions/3.1.9/kotlintest-assertions-3.1.9.jar", "source": {"sha1": "e1df5449c8478507eea19dc13c6dc37948f2d291", "sha256": "3f0ce088b3374c4d520772507cb8b49c0386107c665e2062166719cf20ee1166", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-assertions/3.1.9/kotlintest-assertions-3.1.9-sources.jar"} , "name": "io_kotlintest_kotlintest_assertions", "actual": "@io_kotlintest_kotlintest_assertions//jar:file", "bind": "jar/io/kotlintest/kotlintest_assertions"},
    {"artifact": "io.kotlintest:kotlintest-core:3.1.9", "lang": "kotlin", "sha1": "eded031ef7d64655e3e2f6b0b2619b500801cfa7", "sha256": "296632be8540c8e8a7643f97777cff6f4d059a021bef74fedc44ef932b28bc71", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-core/3.1.9/kotlintest-core-3.1.9.jar", "source": {"sha1": "711f7df30597a5bc7a94225fddcf15442fdc5abf", "sha256": "3ba3434dc76ac2d7ff59a7fac63b420fb6307cec201bd65c110ecc19be27514c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-core/3.1.9/kotlintest-core-3.1.9-sources.jar"} , "name": "io_kotlintest_kotlintest_core", "actual": "@io_kotlintest_kotlintest_core//jar:file", "bind": "jar/io/kotlintest/kotlintest_core"},
    {"artifact": "io.kotlintest:kotlintest-runner-junit4:3.1.9", "lang": "kotlin", "sha1": "99c8bdc1c36642cb630ea96e4743def5d6abd484", "sha256": "4d4cd0954e397ab5a44a4be07ee706d5e461a12eac86ad99815336e26714e613", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-runner-junit4/3.1.9/kotlintest-runner-junit4-3.1.9.jar", "source": {"sha1": "15a3a8783fe9a7eb97589f52bc432ae309997443", "sha256": "9259d397b2a531e74181a66b42f14200750e3d7ae69e39c822b02c1cdb40faa7", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-runner-junit4/3.1.9/kotlintest-runner-junit4-3.1.9-sources.jar"} , "name": "io_kotlintest_kotlintest_runner_junit4", "actual": "@io_kotlintest_kotlintest_runner_junit4//jar:file", "bind": "jar/io/kotlintest/kotlintest_runner_junit4"},
    {"artifact": "io.kotlintest:kotlintest-runner-jvm:3.1.9", "lang": "java", "sha1": "347f2ea4331c4977dc8fd29fb6f69a7256c61692", "sha256": "c22e113d0a27a28dc0976120434704a31b1b5a17adfa73ffd53b07b201e087eb", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-runner-jvm/3.1.9/kotlintest-runner-jvm-3.1.9.jar", "source": {"sha1": "cc85cbdaa4fcf141530808d005486ba0a259e7f1", "sha256": "9e5584d1ecc4c59520e33af6dac8dec9221f6e991cc7e8b7f746213931c7f71b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/kotlintest/kotlintest-runner-jvm/3.1.9/kotlintest-runner-jvm-3.1.9-sources.jar"} , "name": "io_kotlintest_kotlintest_runner_jvm", "actual": "@io_kotlintest_kotlintest_runner_jvm//jar", "bind": "jar/io/kotlintest/kotlintest_runner_jvm"},
    {"artifact": "junit:junit:4.12", "lang": "java", "sha1": "2973d150c0dc1fefe998f834810d68f278ea58ec", "sha256": "59721f0805e223d84b90677887d9ff567dc534d7c502ca903c0c2b17f05c116a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/junit/junit/4.12/junit-4.12.jar", "source": {"sha1": "a6c32b40bf3d76eca54e3c601e5d1470c86fcdfa", "sha256": "9f43fea92033ad82bcad2ae44cec5c82abc9d6ee4b095cab921d11ead98bf2ff", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/junit/junit/4.12/junit-4.12-sources.jar"} , "name": "junit_junit", "actual": "@junit_junit//jar", "bind": "jar/junit/junit"},
    {"artifact": "org.hamcrest:hamcrest-core:1.3", "lang": "java", "sha1": "42a25dc3219429f0e5d060061f71acb49bf010a0", "sha256": "66fdef91e9739348df7a096aa384a5685f4e875584cce89386a7a47251c4d8e9", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar", "source": {"sha1": "1dc37250fbc78e23a65a67fbbaf71d2e9cbc3c0b", "sha256": "e223d2d8fbafd66057a8848cc94222d63c3cedd652cc48eddc0ab5c39c0f84df", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3-sources.jar"} , "name": "org_hamcrest_hamcrest_core", "actual": "@org_hamcrest_hamcrest_core//jar", "bind": "jar/org/hamcrest/hamcrest_core"},
    {"artifact": "org.javassist:javassist:3.21.0-GA", "lang": "java", "sha1": "598244f595db5c5fb713731eddbb1c91a58d959b", "sha256": "7aa59e031f941984af07dacc6ca85e6dc9bd3a485e9aa2494cbc034efa1225d0", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA.jar", "source": {"sha1": "81fefbd46ba6a18fc7af83b9c60b28c0862cd492", "sha256": "c25ab71d2a8b8c7cb081e0094761747269232b52ae96d6d0e4bb4775de71b371", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA-sources.jar"} , "name": "org_javassist_javassist", "actual": "@org_javassist_javassist//jar", "bind": "jar/org/javassist/javassist"},
    {"artifact": "org.jetbrains.kotlin:kotlin-stdlib-common:1.2.50", "lang": "java", "sha1": "6b19a2fcc29d34878b3aab33fd5fcf70458a73df", "sha256": "77129af18d7fc2d3f19e4f2cb140fa47dd602e493c33bd02e79134a62a1bb000", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.2.50/kotlin-stdlib-common-1.2.50.jar", "source": {"sha1": "d3189b4b8c72c7f3a327e3c21dca8dbcba267359", "sha256": "a50698d3f5550b2b0a5792fdd0c377b36ea089885b47ff8b569099fd2009d224", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.2.50/kotlin-stdlib-common-1.2.50-sources.jar"} , "name": "org_jetbrains_kotlin_kotlin_stdlib_common", "actual": "@org_jetbrains_kotlin_kotlin_stdlib_common//jar", "bind": "jar/org/jetbrains/kotlin/kotlin_stdlib_common"},
    {"artifact": "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.2.31", "lang": "java", "sha1": "095d6a67e8787280a82a2059e54e4db7ac6cfe74", "sha256": "c65ebc7dce9157d7e44b0028c66907e5994db5b435c2506a96eec155a491ad7b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-jdk7/1.2.31/kotlin-stdlib-jdk7-1.2.31.jar", "source": {"sha1": "e20207522f93e04fbbf006b141e924d211335564", "sha256": "4588e39e02f92b58efb4d38cd0284b46f169727b5ad779b64012869063eedc74", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-jdk7/1.2.31/kotlin-stdlib-jdk7-1.2.31-sources.jar"} , "name": "org_jetbrains_kotlin_kotlin_stdlib_jdk7", "actual": "@org_jetbrains_kotlin_kotlin_stdlib_jdk7//jar", "bind": "jar/org/jetbrains/kotlin/kotlin_stdlib_jdk7"},
    {"artifact": "org.jetbrains:annotations:13.0", "lang": "java", "sha1": "919f0dfe192fb4e063e7dacadee7f8bb9a2672a9", "sha256": "ace2a10dc8e2d5fd34925ecac03e4988b2c0f851650c94b8cef49ba1bd111478", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/annotations/13.0/annotations-13.0.jar", "source": {"sha1": "5991ca87ef1fb5544943d9abc5a9a37583fabe03", "sha256": "42a5e144b8e81d50d6913d1007b695e62e614705268d8cf9f13dbdc478c2c68e", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/annotations/13.0/annotations-13.0-sources.jar"} , "name": "org_jetbrains_annotations", "actual": "@org_jetbrains_annotations//jar", "bind": "jar/org/jetbrains/annotations"},
    {"artifact": "org.reflections:reflections:0.9.11", "lang": "java", "sha1": "4c686033d918ec1727e329b7222fcb020152e32b", "sha256": "cca88428f8a8919df885105833d45ff07bd26f985f96ee55690551216b58b4a1", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/reflections/reflections/0.9.11/reflections-0.9.11.jar", "source": {"sha1": "2398090ad4dcba954285f97acef10e92e0260044", "sha256": "f9ed0772ffa1423a332076a20fb5f181b2c77d6cc06d11463794a866db0276e8", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/reflections/reflections/0.9.11/reflections-0.9.11-sources.jar"} , "name": "org_reflections_reflections", "actual": "@org_reflections_reflections//jar", "bind": "jar/org/reflections/reflections"},
    {"artifact": "org.slf4j:slf4j-api:1.7.25", "lang": "java", "sha1": "da76ca59f6a57ee3102f8f9bd9cee742973efa8a", "sha256": "18c4a0095d5c1da6b817592e767bb23d29dd2f560ad74df75ff3961dbde25b79", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar", "source": {"sha1": "962153db4a9ea71b79d047dfd1b2a0d80d8f4739", "sha256": "c4bc93180a4f0aceec3b057a2514abe04a79f06c174bbed910a2afb227b79366", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25-sources.jar"} , "name": "org_slf4j_slf4j_api", "actual": "@org_slf4j_slf4j_api//jar", "bind": "jar/org/slf4j/slf4j_api"},
    ]

def maven_dependencies(callback = jar_artifact_callback):
    for hash in list_dependencies():
        callback(hash)
