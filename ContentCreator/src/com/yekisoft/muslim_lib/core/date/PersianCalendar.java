package com.yekisoft.muslim_lib.core.date;

/**
 * Created by yektaie on 8/5/16.
 */
public class PersianCalendar {
    public static int[] DaysToMonth = new int[] { 0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336 };

    public static int[] LeapYears33 = new int[] { 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0 };

    public DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) {
        long absoluteDatePersian = GetAbsoluteDatePersian(year, month, day);
        return new DateTime(absoluteDatePersian * 864000000000L + TimeToTicks(hour, minute, second, millisecond));
    }

    public static long TimeToTicks(int hour, int minute, int second, int millisecond) {
        return TimeToTicks(hour, minute, second) + (long) millisecond * 10000L;
    }

    private static long TimeToTicks(int hour, int minute, int second) {
        long num = (long) hour * 3600L + (long) minute * 60L + (long) second;
        return num * 10000000L;
    }

    private long GetAbsoluteDatePersian(int year, int month, int day) {
        return this.DaysUpToPersianYear(year) + (long) PersianCalendar.DaysToMonth[month - 1] + (long) day - 1L;
    }

    private long DaysUpToPersianYear(int PersianYear) {
        int num1 = (PersianYear - 1) / 33;
        int year = (PersianYear - 1) % 33;
        long num2 = (long) num1 * 12053L + 226894L;
        for (; year > 0; --year) {
            num2 += 365L;
            if (this.IsLeapYear(year, 0))
                ++num2;
        }
        return num2;
    }

    public int GetDaysInMonth(int year, int month, int era) {
        if (month == 10 && year == 9378)
            return 10;
        if (month == 12) {
            if (!IsLeapYear(year, 0))
                return 29;
            else
                return 30;
        } else if (month <= 6)
            return 31;
        else
            return 30;
    }

    public boolean IsLeapYear(int year, int era) {
        return PersianCalendar.LeapYears33[year % 33] == 1;
    }

    public int GetYear(DateTime time) {
        return this.GetDatePart(time.getInternalTicks(), 0);
    }

    private int GetDatePart(long ticks, int part) {
        long num1 = ticks / 864000000000L + 1L;
        int num2 = (int) ((num1 - 226894L) * 33L / 12053L) + 1;
        long num3 = this.DaysUpToPersianYear(num2);
        long num4 = (long) this.GetDaysInYear(num2, 0);
        if (num1 < num3) {
            num3 -= num4;
            --num2;
        } else if (num1 == num3) {
            --num2;
            num3 -= (long) this.GetDaysInYear(num2, 0);
        } else if (num1 > num3 + num4) {
            num3 += num4;
            ++num2;
        }
        if (part == 0)
            return num2;
        long num5 = num1 - num3;
        if (part == 1)
            return (int) num5;
        int index = 0;
        while (index < 12 && num5 > (long) PersianCalendar.DaysToMonth[index])
            ++index;
        if (part == 2)
            return index;
        int num6 = (int) (num5 - (long) PersianCalendar.DaysToMonth[index - 1]);
        return num6;
    }

    public int GetDaysInYear(int year, int era) {
        if (year == 9378)
            return PersianCalendar.DaysToMonth[9] + 10;
        if (!this.IsLeapYear(year, 0))
            return 365;
        else
            return 366;
    }

    public int GetMonth(DateTime time)
    {
        return this.GetDatePart(time.getInternalTicks(), 2);
    }

    public int GetDayOfMonth(DateTime time)
    {
        return this.GetDatePart(time.getInternalTicks(), 3);
    }


}