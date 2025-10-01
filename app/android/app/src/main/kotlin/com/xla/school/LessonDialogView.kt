package com.xla.school

import android.content.Intent
import android.content.res.TypedArray
import android.graphics.Color
import android.os.Bundle
import androidx.annotation.AttrRes
import androidx.annotation.NonNull
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.xla.school.logic.DataParser
import com.xla.school.models.Course
import com.xla.school.models.Lesson
import com.xla.school.models.Period
import com.xla.school.models.Settings
import androidx.core.content.ContextCompat
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import android.view.MenuItem
import android.view.View
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView

class LessonDialogView : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setStatusBarDim(true)

        setContentView(R.layout.lessondialog_view)
        findViewById<View>(R.id.touch_outside).setOnClickListener {
            finishAndRemoveTask()
        }

        BottomSheetBehavior.from(findViewById<View>(R.id.bottom_sheet))
            .setBottomSheetCallback(object : BottomSheetBehavior.BottomSheetCallback() {
                override fun onStateChanged(@NonNull bottomSheet: View, newState: Int) {
                    when (newState) {
                        BottomSheetBehavior.STATE_HIDDEN -> {
                            finishAndRemoveTask()
                        }
                        BottomSheetBehavior.STATE_EXPANDED -> {
                            setStatusBarDim(true)
                        }
                        else -> {
                            setStatusBarDim(true)
                        }
                    }
                }

                override fun onSlide(@NonNull bottomSheet: View, slideOffset: Float) {
                    // no op
                }
            })

        val mActionBarToolbar = findViewById<Toolbar>(R.id.my_toolbar)
        setSupportActionBar(mActionBarToolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setHomeAsUpIndicator(R.drawable.baseline_close_black_24)

        val i = intent
        val lessonid = i.getStringExtra("data_lesson_id")
        if (lessonid != null) {
            val lesson = DataParser.getLesson(this, lessonid)
            if (lesson != null) {
                val course = DataParser.getCourse(this, lesson.courseid)
                val period = DataParser.getIndividualPeriod(this, lesson.start, lesson.end)

                supportActionBar?.title = (
                    MainActivityOldKt.getDaysOfWeek(this)[lesson.day] +
                        ", " + if (lesson.isMultiLesson()) {
                        "${lesson.start}. - ${lesson.end}. "
                    } else {
                        "${lesson.start}. "
                    }
                )

                if (course != null) {
                    findViewById<TextView>(R.id.text_info_course).text = course.name
                    findViewById<ImageView>(R.id.icon_info_course).setColorFilter(course.getDesignVal())
                }

                if (lesson.teacher != null) {
                    findViewById<TextView>(R.id.text_info_teacher).text = lesson.teacher.name
                } else {
                    findViewById<TextView>(R.id.text_info_teacher).setText("-")
                }

                if (lesson.location != null) {
                    findViewById<TextView>(R.id.text_info_place).text = lesson.location.name
                } else {
                    findViewById<TextView>(R.id.text_info_place).setText("-")
                }

                val settings = DataParser.getSettings(this)

                if (settings.multiple_weektypes) {
                    findViewById<RelativeLayout>(R.id.layout_weektype).visibility = View.VISIBLE
                    findViewById<TextView>(R.id.text_info_weektype).text = MainActivityOldKt.getWeekTypeNames(this)[lesson.weektype]
                }

                findViewById<TextView>(R.id.text_info_period).text = if (lesson.isMultiLesson()) {
                    "${lesson.start}. - ${lesson.end}. ${getString(R.string.period)}" +
                        if (settings.schedule_showlessontime) {
                            " ${period.start}-${period.end}"
                        } else {
                            ""
                        }
                } else {
                    "${lesson.start}. ${getString(R.string.period)}" +
                        if (settings.schedule_showlessontime) {
                            " ${period.start}-${period.end}"
                        } else {
                            ""
                        }
                }
            }
        }
    }

    private fun setStatusBarDim(dim: Boolean) {
        window.statusBarColor = if (dim) Color.TRANSPARENT else ContextCompat.getColor(this, getThemedResId(android.R.attr.colorPrimaryDark))
    }

    private fun getThemedResId(@AttrRes attr: Int): Int {
        val a = theme.obtainStyledAttributes(intArrayOf(attr))
        val resId = a.getResourceId(0, 0)
        a.recycle()
        return resId
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                finishAndRemoveTask()
                true
            }
            else -> {
                super.onOptionsItemSelected(item)
            }
        }
    }
}
