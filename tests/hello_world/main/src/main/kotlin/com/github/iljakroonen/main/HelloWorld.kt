package com.github.iljakroonen.main

import com.github.iljakroonen.add.add
import com.github.iljakroonen.logging.info
import com.github.iljakroonen.logging.setLogLevel
import com.github.iljakroonen.subtract.Subtract
import java.nio.file.Files
import java.nio.file.Paths

fun main(args: Array<String>) {
    setLogLevel(1)
    info { "1 - 3 = ${Subtract.subtract(1, 3)}" }
    info { "1 + 3 = ${add(1, 3)}" }

    val config = Files.readAllLines(Paths.get("data/config"))
            .map {
                val spl = it.split("=", limit = 2)
                spl[0] to spl[1]
            }
            .toMap()

    if (config["enable_awesomeness"] == "1") {
        info { "Awesome!" }
    }

    val counter = DaggerMainProvider.create().counter()
    counter.count()

    info {
        "We counted one time! The result is ${counter.count}"
    }
}
