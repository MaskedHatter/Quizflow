import 'package:flutter/material.dart';
import 'package:time/time.dart';

class SettingsModel extends ChangeNotifier {
  // New Card
  static List<Duration> stepsLearning = [1.minutes, 10.minutes];
  static int newCardsAday = 20;
  static Duration graduatingInterval = 1.days;
  static Duration easyInterval = 4.days;
  static int startingEase = 250;

  // Lapse
  static List<Duration> stepsLapse = [20.minutes, 1440.minutes];
  static int newIntervalPercent = 10;
  static Duration minInterval = 3.days;
  static int leechThreshold = 8;

  // Review
  static int maxReviewsPerDay = 100;
  static double intervalModifier = 100;
  static int easyBonus = 140;
  static int maxInterval = 365;
  static int hardInterval = 120;
}
