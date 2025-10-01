package com.xla.school

import java.text.SimpleDateFormat
import java.util.*

/**
 * Created by felix on 14.05.2017.
 */
object DateString {

    fun getNow(): Calendar {
        return Calendar.getInstance()
    }

    fun getToday(): Calendar {
        val c = Calendar.getInstance()
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.HOUR_OF_DAY, 0)
        c.set(Calendar.MILLISECOND, 0)
        return c
    }

    fun buildDatestring(calendar: Calendar): String {
        return SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).format(calendar.time)
    }

    private fun buildSimpleString(calendar: Calendar): String {
        return SimpleDateFormat("yyyy_MM_dd", Locale.ENGLISH).format(calendar.time)
    }

    fun buildCalendar(datestring: String): Calendar {
        val parts = datestring.split("-")
        if (parts.size != 3) return Calendar.getInstance()
        val year = parts[0].toInt()
        val month = parts[1].toInt() - 1
        val day = parts[2].toInt()
        val calendar = Calendar.getInstance()
        calendar.set(year, month, day)
        return calendar
    }

    fun getWeekNumber(): Int {
        return Calendar.getInstance().get(Calendar.WEEK_OF_YEAR)
    }

    fun getWeekNumber(datestring: String): Int {
        return buildCalendar(datestring).get(Calendar.WEEK_OF_YEAR)
    }

    fun areSameDay(c1: Calendar, c2: Calendar): Boolean {
        return buildSimpleString(c1) == buildSimpleString(c2)
    }

    fun areSameDay(c1: Calendar, s1: String): Boolean {
        return buildSimpleString(c1) == buildSimpleString(buildCalendar(s1))
    }

    fun areSameDay(s1: String, s2: String): Boolean {
        return buildSimpleString(buildCalendar(s1)) == buildSimpleString(buildCalendar(s2))
    }

    fun isinRange(dateString: String?, start: String?, end: String?): Boolean {
        if (dateString == null) return false
        if (start == null || end == null) return true
        val date = buildCalendar(dateString)
        if (date.before(buildCalendar(start))) return false
        if (date.after(buildCalendar(end))) return false
        return true
    }

    fun getDayofWeek(calendar: Calendar): Int {
        val dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK)
        return if (dayOfWeek == 1) 7 else dayOfWeek - 1
    }
}
