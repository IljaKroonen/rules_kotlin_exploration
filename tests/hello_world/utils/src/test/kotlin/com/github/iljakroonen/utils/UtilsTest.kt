package com.github.iljakroonen.utils

import com.github.iljakroonen.add.add
import com.github.iljakroonen.subtract.Subtract
import io.kotlintest.shouldBe
import io.kotlintest.specs.StringSpec

class UtilsTest : StringSpec({
    "We should be able to call function from exported kt_jvm_library" {
        add(1, 3) shouldBe  4
    }

    "We should be able to call function from exported java_library" {
        Subtract.subtract(7, 1) shouldBe 6
    }

    "We should be able to call function from direct dependency" {
        doSomethingUseful()
    }
})
