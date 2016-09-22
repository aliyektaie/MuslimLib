package com.yekisoft.muslim_lib.core.date;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created by yektaie on 8/5/16.
 */
public class DateTime {
    public long dateData = 0;

    private static int[] DaysToMonth365 = new int[] { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 };
    private static int[] DaysToMonth366 = new int[] { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 };

    public static DateTime MinValue = new DateTime(0L);
    public static DateTime MaxValue = new DateTime(3155378975999999999L);
    private static SimpleDateFormat sdf = new SimpleDateFormat("dd MM yyyy HH mm ss");

    public static DateTime now() {
        Calendar cal = Calendar.getInstance();
        String strDate = sdf.format(cal.getTime());
        String[] parts = strDate.split("\\s");
        int year = Integer.valueOf(parts[2]);
        int month = Integer.valueOf(parts[1]);
        int day = Integer.valueOf(parts[0]);
        int hour = Integer.valueOf(parts[3]);
        int minute = Integer.valueOf(parts[4]);
        int second = Integer.valueOf(parts[5]);

        return new DateTime(year, month, day, hour, minute, second);
    }

    public DateTime(int year, int month, int day) {
        this(year, month, day, 0, 0);
    }

    public DateTime(long ticks) {
        this.dateData = ticks;
    }

    public DateTime(int year, int month, int day, int hour, int minute) {
        this(year, month, day, hour, minute, 0);
    }

    public DateTime(int year, int month, int day, int hour, int minute, int second) {
        this.dateData = (DateTime.convertDateToTicks(year, month, day) + DateTime.convertTimeToTicks(hour, minute, second));
    }

    public boolean after(DateTime d1) {
        return getInternalTicks() > d1.getInternalTicks();
    }

    public boolean before(DateTime d1) {
        return !after(d1);
    }

    private int getDatePart(int part) {
        int num1 = (int) (getInternalTicks() / 864000000000L);
        int num2 = num1 / 146097;
        int num3 = num1 - num2 * 146097;
        int num4 = num3 / 36524;
        if (num4 == 4)
            num4 = 3;
        int num5 = num3 - num4 * 36524;
        int num6 = num5 / 1461;
        int num7 = num5 - num6 * 1461;
        int num8 = num7 / 365;
        if (num8 == 4)
            num8 = 3;
        if (part == 0)
            return num2 * 400 + num4 * 100 + num6 * 4 + num8 + 1;
        int num9 = num7 - num8 * 365;
        if (part == 1)
            return num9 + 1;
        int[] numArray = num8 == 3 && (num6 != 24 || num4 == 3) ? DateTime.DaysToMonth366 : DateTime.DaysToMonth365;
        int index = num9 >> 6;
        while (num9 >= numArray[index])
            ++index;
        if (part == 2)
            return index;
        else
            return num9 - numArray[index - 1] + 1;
    }

    public long getInternalTicks() {
        return (long) this.dateData & 4611686018427387903L;
    }

    public static boolean isLeapYear(int year) {
        if (year % 4 != 0)
            return false;
        if (year % 100 == 0)
            return year % 400 == 0;
        else
            return true;
    }

    private static long convertDateToTicks(int year, int month, int day) {
        if (year >= 1 && year <= 9999 && (month >= 1 && month <= 12)) {
            int[] numArray = DateTime.isLeapYear(year) ? DateTime.DaysToMonth366 : DateTime.DaysToMonth365;
            if (day >= 1 && day <= numArray[month] - numArray[month - 1]) {
                int num = year - 1;
                return (long) (num * 365 + num / 4 - num / 100 + num / 400 + numArray[month - 1] + day - 1) * 864000000000L;
            }
        }

        return 0;
    }

    public static long convertTimeToTicks(int hour, int minute, int second, int millisecond) {
        return convertTimeToTicks(hour, minute, second) + (long) millisecond * 10000L;
    }

    private static long convertTimeToTicks(int hour, int minute, int second) {
        long num = (long) hour * 3600L + (long) minute * 60L + (long) second;
        return num * 10000000L;
    }

    private DateTime add(double value, int scale) {
        long num = (long) (value * (double) scale + (value >= 0.0 ? 0.5 : -0.5));
        return this.addTicks(num * 10000L);
    }

    public DateTime addTicks(long value) {
        long internalTicks = this.getInternalTicks();
        return new DateTime((internalTicks + value));
    }

    public DateTime addMinutes(double value) {
        return this.add(value, 60000);
    }

    public DateTime addMonths(int months) {
        int datePart1 = this.getDatePart(0);
        int datePart2 = this.getDatePart(2);
        int day = this.getDatePart(3);
        int num1 = datePart2 - 1 + months;
        int month;
        int year;
        if (num1 >= 0) {
            month = num1 % 12 + 1;
            year = datePart1 + num1 / 12;
        } else {
            month = 12 + (num1 + 1) % 12;
            year = datePart1 + (num1 - 11) / 12;
        }
        int num2 = DateTime.getDaysInMonth(year, month);
        if (day > num2)
            day = num2;
        return new DateTime((DateTime.convertDateToTicks(year, month, day) + this.getInternalTicks() % 864000000000L));
    }

    public static int getDaysInMonth(int year, int month) {
        int[] numArray = DateTime.isLeapYear(year) ? DateTime.DaysToMonth366 : DateTime.DaysToMonth365;
        return numArray[month] - numArray[month - 1];
    }

    public DateTime addSeconds(double value) {
        return this.add(value, 1000);
    }

    public DateTime addYears(int value) {
        return this.addMonths(value * 12);
    }

    public DateTime addHours(double value) {
        return this.add(value, 3600000);
    }

    public DateTime addDays(double value) {
        return this.add(value, 86400000);
    }

    public int getDayOfWeek() {
        return (int) ((this.getInternalTicks() / 864000000000L + 1L) % 7L);
    }

    public long Subtract(DateTime ts) {
        return this.getInternalTicks() - ts.getInternalTicks();
    }

    @Override
    public boolean equals(Object o) {
        boolean result = o instanceof DateTime;

        if (result) {
            result = getInternalTicks() == ((DateTime) o).getInternalTicks();
        }

        return result;
    }

    private long cachedTicks = -1;
    private int c_year = 0;
    private int c_month = 0;
    private int c_day = 0;
    private int c_minute = 0;
    private int c_hour = 0;

    public int getYear() {
        if (cachedTicks != dateData) {
            updateCache();
        }

        return c_year;
    }

    public int getMonth() {
        if (cachedTicks != dateData) {
            updateCache();
        }

        return c_month;
    }

    public int getDay() {
        if (cachedTicks != dateData) {
            updateCache();
        }

        return c_day;
    }

    public int getHour() {
        if (cachedTicks != dateData) {
            updateCache();
        }

        return c_hour;
    }

    public int getMinute() {
        if (cachedTicks != dateData) {
            updateCache();
        }

        return c_minute;
    }

    private void updateCache() {
        cachedTicks = dateData;

        c_year = this.getDatePart(0);
        c_month = this.getDatePart(2);
        c_day = this.getDatePart(3);
        c_hour = (int) (this.getInternalTicks() / 36000000000L % 24L);
        c_minute = (int) (this.getInternalTicks() / 600000000L % 60L);
    }

    public DateTime getDate() {
        return new DateTime(getYear(), getMonth(), getDay());
    }

    private static PersianCalendar calendar = new PersianCalendar();

    public String toString() {
        String result = "";

        try {
            int year = calendar.GetYear(this);
            int month = calendar.GetMonth(this);
            int day = calendar.GetDayOfMonth(this);

            result = String.format("%d/%d/%d", year, month, day);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
