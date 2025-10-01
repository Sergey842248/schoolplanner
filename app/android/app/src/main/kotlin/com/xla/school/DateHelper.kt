package com.xla.school

import android.content.Context
import com.xla.school.R
import java.text.SimpleDateFormat
import java.util.*

object DateHelper {

    fun getYesterday(): String {
        val c = DateString.getToday()
        c.add(Calendar.DAY_OF_YEAR, -1)
        return DateString.buildDatestring(c)
    }

    fun getTomorrow(): String {
        val c = DateString.getToday()
        c.add(Calendar.DAY_OF_YEAR, 1)
        return DateString.buildDatestring(c)
    }

    fun getThreeDays(): String {
        val c = DateString.getToday()
        c.add(Calendar.DAY_OF_YEAR, 3)
        return DateString.buildDatestring(c)
    }

    fun getToday(): String {
        return DateString.buildDatestring(DateString.getToday())
    }

    fun insideDateRange(range: String, datestring: String): Boolean {
        val start = range.split(":")[0]
        val end = range.split(":")[0]
        val startc = DateString.buildCalendar(start)
        val endc = DateString.buildCalendar(end)
        while (!DateString.areSameDay(startc, endc)) {
            if (DateString.areSameDay(startc, datestring)) return true
            startc.add(Calendar.DAY_OF_YEAR, 1)
        }
        return false
    }

    fun getStringtoDayDate(context: Context, datestring: String): String {
        return when {
            DateString.areSameDay(getToday(), datestring) -> {
                context.getString(R.string.today) + " (" + stringashumandate(datestring) + ") "
            }
            DateString.areSameDay(getTomorrow(), datestring) -> {
                context.getString(R.string.tomorrow) + " (" + stringashumandate(datestring) + ") "
            }
            DateString.areSameDay(getYesterday(), datestring) -> {
                context.getString(R.string.yesterday) + " (" + stringashumandate(datestring) + ") "
            }
            else -> {
                stringashumandate(datestring)
            }
        }
    }

    fun stringashumandate(s: String): String {
        return try {
            val fmt = if (DateString.buildCalendar(s).get(Calendar.YEAR) == DateString.getToday().get(Calendar.YEAR)) {
                SimpleDateFormat("EEEE, dd.MMMM", Locale.getDefault())
            } else {
                SimpleDateFormat("EEEE, dd.MMMM YYYY", Locale.getDefault())
            }
            fmt.format(DateString.buildCalendar(s).time)
        } catch (e: Exception) {
            s
        }
    }

    fun getWeekDayName(day: Int, context: Context): String {
        return when (day) {
            1 -> context.getString(R.string.monday)
            2 -> context.getString(R.string.tuesday)
            3 -> context.getString(R.string.wednesday)
            4 -> context.getString(R.string.thursday)
            5 -> context.getString(R.string.friday)
            6 -> context.getString(R.string.saturday)
            7 -> context.getString(R.string.sunday)
            else -> ""
        }
    }
}
