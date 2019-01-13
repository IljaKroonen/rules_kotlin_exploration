package com.github.iljakroonen.rules.kotlin;

import com.google.devtools.build.buildjar.jarhelper.JarCreator;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

class CompileKotlin {
    private static String[] splitPathArg(String arg) {
        if (arg.equals("")) {
            return new String[0];
        }

        return arg.split(System.getProperty("path.separator"));
    }

    private static List<String> buildKaptArgs(String kotlinHome, String[] processors, String[] processorPath,
                                              Path sourcePath, Path classesPath, String jdkHome) throws Exception {
        ArrayList<String> args = new ArrayList<>();

        if (processors.length > 0) {
            Path tempDirectory = Files.createTempDirectory("kotlinc_plugins_temp");

            args.add("-Xplugin=" + kotlinHome + "/lib/kotlin-annotation-processing.jar");

            // https://github.com/bazelbuild/rules_kotlin/blob/master/src/main/kotlin/io/bazel/kotlin/builder/utils/KotlinCompilerPluginArgsEncoder.kt
            // processors arg does not work without this
            Map<String, List<String>> pluginArgs = new HashMap<>();

            pluginArgs.put("sources", Collections.singletonList(sourcePath.toString()));
            pluginArgs.put("classes", Collections.singletonList(classesPath.toString()));
            pluginArgs.put("stubs", Collections.singletonList(tempDirectory.toString()));
            pluginArgs.put("incrementalData", Collections.singletonList(tempDirectory.toString()));
            pluginArgs.put("aptMode", Collections.singletonList("stubsAndApt"));
            pluginArgs.put("correctErrorTypes", Collections.singletonList("true"));
            pluginArgs.put("processors", Collections.singletonList(String.join(",", processors)));
            pluginArgs.put("apclasspath", Arrays.asList(processorPath));

            System.out.println(pluginArgs);

            ByteArrayOutputStream os = new ByteArrayOutputStream();
            ObjectOutputStream oos = new ObjectOutputStream(os);

            oos.writeInt(pluginArgs.size());

            for (Map.Entry<String, List<String>> entry : pluginArgs.entrySet()) {
                oos.writeUTF(entry.getKey());

                oos.writeInt(entry.getValue().size());

                for (String value : entry.getValue()) {
                    oos.writeUTF(value);
                }
            }

            oos.flush();

            String base64 = Base64.getEncoder().encodeToString(os.toByteArray());

            args.add("-P");
            args.add("plugin:org.jetbrains.kotlin.kapt3:configuration=" + base64);

            args.add("-Xplugin=" + jdkHome + "/lib/tools.jar");
        }

        for (String arg : args) {
            System.out.println(arg);
        }

        return args;
    }

    public static void main(String[] args) {
        try {
            String jdkHome = args[1];
            String[] kotlinSources = splitPathArg(args[2]);
            String compileClasspath = args[3];
            Path outputJar = Paths.get(args[4]);
            String moduleName = args[5];
            Path outputSourceJar = Paths.get(args[6]);
            String[] resources = splitPathArg(args[7]);
            String kotlinHome = args[8];
            String[] processors = splitPathArg(args[9]);
            String[] processorPath = splitPathArg(args[10]);

            Path tempCompilationDirectory = Files.createTempDirectory("kotlinc_outputs");
            Path generatedSourcesDirectory = Files.createTempDirectory("kotlinc_generated");

            String[] kotlincFlags = new String[]{
                    "-d",
                    tempCompilationDirectory.toString(),
                    "-cp",
                    compileClasspath,
                    "-jdk-home",
                    jdkHome,
                    "-module-name",
                    moduleName,
                    "-jvm-target",
                    "1.8",
                    "-kotlin-home",
                    kotlinHome,
                    "-language-version",
                    "1.2"
            };

            ArrayList<String> kotlincArgs = new ArrayList<>();
            kotlincArgs.add(kotlinHome + "/bin/kotlinc");
            kotlincArgs.addAll(Arrays.asList(kotlincFlags));
            kotlincArgs.addAll(Arrays.asList(kotlinSources));
            kotlincArgs.addAll(buildKaptArgs(kotlinHome, processors, processorPath, generatedSourcesDirectory, tempCompilationDirectory, jdkHome));

            StringBuilder cmd = new StringBuilder();
            for (String e : kotlincArgs) {
                cmd.append(" ").append(e);
            }

            Process process = new ProcessBuilder()
                    .command(kotlincArgs)
                    .redirectError(ProcessBuilder.Redirect.INHERIT).redirectOutput(ProcessBuilder.Redirect.INHERIT)
                    .start();

            int outCode = process.waitFor();

            if (outCode != 0)
                System.exit(outCode);

            System.out.println("Sources generated");
            Files.walk(generatedSourcesDirectory)
                    .filter(Files::isRegularFile)
                    .forEach(System.out::println);

            JarCreator jarCreator = new JarCreator(outputJar);
            jarCreator.addDirectory(tempCompilationDirectory);

            List<String> sortedResources = Arrays.asList(resources);
            Collections.sort(sortedResources);
            for (String resource : sortedResources) {
                Path resourcePath = Paths.get(resource);
                boolean foundSrc = false;
                boolean foundResources = false;
                ArrayList<String> targetLocationPathParts = new ArrayList<>();

                for (Path pathPart : resourcePath) {
                    if (foundResources) {
                        targetLocationPathParts.add(pathPart.toString());
                    }

                    if (pathPart.toString().equals("src")) {
                        foundSrc = true;
                    }

                    if (foundSrc && pathPart.toString().equals("resources")) {
                        foundResources = true;
                    }
                }

                String destinationInJar = String.join("/", targetLocationPathParts);

                jarCreator.addEntry(destinationInJar, resourcePath);
            }

            jarCreator.setCompression(true);
            jarCreator.setNormalize(true);
            jarCreator.execute();

            JarCreator sourceJarCreator = new JarCreator(outputSourceJar);
            sourceJarCreator.setCompression(true);
            sourceJarCreator.setNormalize(true);
            List<String> kotlinSourcesSorted = Arrays.asList(kotlinSources);
            Collections.sort(kotlinSourcesSorted);

            for (String source : kotlinSourcesSorted) {
                Path sourcePath = Paths.get(source);
                String sourceContents = new String(Files.readAllBytes(sourcePath), StandardCharsets.UTF_8);
                String packageName = null;

                for (String line : sourceContents.split("\n")) {
                    if (line.startsWith("package ")) {
                        String withPossibleTrailingSemicolon = line.substring("package ".length()).trim();
                        if (withPossibleTrailingSemicolon.endsWith(";"))
                            packageName = withPossibleTrailingSemicolon.substring(0, withPossibleTrailingSemicolon.length() - 1).trim();
                        else
                            packageName = withPossibleTrailingSemicolon;

                        break;
                    }
                }

                if (packageName == null) {
                    System.err.println("Could not find package declaration in source file " + source);
                    System.exit(1);
                }

                sourceJarCreator.addEntry(packageName.replace('.', '/') + "/" + sourcePath.getFileName().toString(), sourcePath);
            }

            sourceJarCreator.addDirectory(generatedSourcesDirectory);

            sourceJarCreator.execute();
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
        System.exit(0);
    }
}
