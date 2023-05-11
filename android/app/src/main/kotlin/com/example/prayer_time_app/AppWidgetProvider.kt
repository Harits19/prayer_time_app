package com.example.prayer_time_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.LinearLayout
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import org.json.JSONTokener

class AppWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            }

            val prayerTime = widgetData.getString("prayerTime", "")
            if (prayerTime.isNullOrEmpty()) {
                return
            }
            val jsonObject = JSONTokener(prayerTime).nextValue() as JSONObject
            val jadwal = jsonObject.getJSONObject("jadwal")
            val jadwalMap = mapOf(
                "Imsak" to jadwal.getString("imsak"),
                "Subuh" to jadwal.getString("subuh"),
                "Terbit" to jadwal.getString("terbit"),
                "Dhuha" to jadwal.getString("dhuha"),
                "Dzuhur" to jadwal.getString("dzuhur"),
                "Ashar" to jadwal.getString("ashar"),
                "Maghrib" to jadwal.getString("maghrib"),
                "Isya" to jadwal.getString("isya")
            )

            views.removeAllViews(R.id.items_container)
            for (i in jadwalMap) {
                val item = RemoteViews(context.packageName, R.layout.prayer_item)
                item.setTextViewText(R.id.prayer_name, i.key)
                item.setTextViewText(R.id.prayer_time, i.value)
                views.addView(R.id.items_container, item)
            }


            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}