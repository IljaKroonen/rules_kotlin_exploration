package com.github.iljakroonen.main

import com.github.iljakroonen.add.add
import com.github.iljakroonen.subtract.Subtract
import com.github.iljakroonen.logging.info
import com.github.iljakroonen.logging.setLogLevel

fun main(args: Array<String>) {
    setLogLevel(1)
    info { "1 - 3 = ${Subtract.subtract(1, 3)}" }
    info { "1 + 3 = ${add(1, 3)}" }
}
