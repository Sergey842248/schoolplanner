package com.xla.school

import java.util.concurrent.atomic.AtomicInteger

object NotificationID {
    private val c = AtomicInteger(0)

    fun getID(): Int {
        return c.incrementAndGet()
    }
}
