package com.oneday.oneday

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class OnedayWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val quoteText = widgetData.getString("quote_text", "오늘 하루도 충분히 잘 해내고 있습니다.")
        val quoteAuthor = widgetData.getString("quote_author", "ONE DAY")

        val views = RemoteViews(context.packageName, R.layout.oneday_widget).apply {
            setTextViewText(R.id.widget_quote_text, quoteText)
            setTextViewText(R.id.widget_quote_author, "— $quoteAuthor")
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
