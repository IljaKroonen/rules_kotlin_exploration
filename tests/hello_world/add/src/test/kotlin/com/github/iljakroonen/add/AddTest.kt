package com.github.iljakroonen.add

import io.kotlintest.shouldBe
import io.kotlintest.specs.StringSpec

class AddTest: StringSpec({
    "add(1,3) should be 4" {
        add(1, 3) shouldBe 4
    }
})
