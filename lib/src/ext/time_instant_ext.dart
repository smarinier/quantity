part of quantity_ext;

/// International Atomic Time Scale
TimeInstantUnits TAI = TimeInstant.TAI;

/// Coordinated Universal Time (differs from TAI by a number of leap seconds)
TimeInstantUnits UTC = TimeInstant.UTC;

/// Number of milliseconds since 1 Jan 1970 0h 0m 0s, which is the System
/// time defined by the Java VM */
TimeInstantUnits system = TimeInstant.system;

/// Terrestrial Dynamical Time (TDT):  TDT = TAI + 32.184 s
TimeInstantUnits TDT = new TimeInstantUnits("Terrestrial Dynamical Time", "TT", "TDT", null, 1.0, false, -32.184);

/// Terrestrial Time (TT) is the same as TDT:  TDT = TT = TAI + 32.184 s
TimeInstantUnits TT = TDT;

/// Ephemeris Time (ET) is the same as TDT:  ET = TDT = TT = TAI + 32.184 s.
/// Ephemeris Time was renamed Terrestrial Dynamical Time in 1984 (when
/// Barycentric Dynamical Time was also introduced)
TimeInstantUnits ET = TDT;

/// GPS Satellite Time (GPST):  GPST = TAI - 19 s
TimeInstantUnits GPST = new TimeInstantUnits("GPS Satellite Time", null, "GPST", null, 1.0, false, 19.0);

//__________________________________________________________________________________________________________

/// Geocentric Coordinate Time (TCG): TCG = TDT + (6.969291e-10)(JD - 2443144.5)(86400)
TimeInstantUnits TCG = new TimeInstantUnits("Geocentric Coordinate Time", null, "TCG", null, 1.0, false, 0.0, (val) {
  // TCG = TAI + 32.184 + (6.969291e-10)(JD - 2443144.5)(86400)... where the Julian Date is in the TAI scale
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  return new Double(d + 32.184 + (6.969291e-10 * (d - 599616000.0)));
}, (val) {
  // TAI = TCG - 32.184 - (6.969291e-10)(JD - 2443144.5)(86400)... where the Julian Date is in the TAI scale
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  double taiApprox = d - 32.184 - (6.969291e-10 * (d - 599616000.0)); // get closer to the actual JD TAI (s)
  return new Double(d - 32.184 - (6.969291e-10 * (taiApprox - 599616000.0)));
});

//__________________________________________________________________________________________________________

/// Barycentric Dynamical Time (TDB):  TDB varies from TDT by periodic variations
TimeInstantUnits TDB =
    new TimeInstantUnits("Barycentric Dynamical Time", null, "TDB", null, 1.0, false, -32.184, (val) {
  // TDB = TAI + 32.184 + 0.001658sin(g) + 0.000014sin(2g)...
  // where g = 357.53 deg + 0.9856003(JD - 2451545.0) deg... (Julian dates are in the TAI time scale)
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  double gRad = (357.53 + 0.9856003 * ((d / 86400.0) - 15341.0)) * (PI / 180.0);
  return new Double(d + 32.184 + 0.001658 * sin(gRad) + 0.000014 * sin(2.0 * gRad));
}, (val) {
  // TAI = TDB - 32.184 - 0.001658sin(g) - 0.000014sin(2g)...
  // where g = 357.53 deg + 0.9856003(JD - 2451545.0) deg... (Julian dates are in the TAI time scale)

  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Too convoluted to solve analytically (because g is a function of
  // the Julian Date in the TAI scale... instead, get close and then search
  double taiTest = d;
  double step = 10.0;
  double epsilon = 1.0e-8;
  int maxCount = 10000;
  int count = 0;
  double tdbTest = TDB.fromMks(d).toDouble();
  double delta = tdbTest - taiTest;
  double prevDelta = double.MAX_FINITE;
  while ((delta.abs() > epsilon) && (count < maxCount)) {
    // See if we got farther away (if so reverse and take smaller steps)
    if (delta.abs() > prevDelta.abs()) step *= -0.5;

    // Step
    taiTest += step;

    prevDelta = delta;
    count++;

    // New value & delta
    tdbTest = TDB.fromMks(taiTest).toDouble();
    delta = tdbTest - d;
  }

  // taiTest now returns a tcb value within epsilon (or loop count ran out)
  return new Double(taiTest);
});

//__________________________________________________________________________________________________________

/// Barycentric Time (TB); same as TDB:  TT = TDB
TimeInstantUnits TB = TDB;

//__________________________________________________________________________________________________________

/// Barycentric Coordinate Time (TCB): TCB = TDB + (1.550505e-8)(JD - 2443144.5)(86400)
TimeInstantUnits TCB = new TimeInstantUnits(
    "Barycentric Coordinate Time", null, "TCB", null, (1.0 - 1.550505e-8), false, 599616000.0 - 32.184, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  Number tdb = TDB.fromMks(val); // TDB seconds
  tdb += 1.550505e-8 * (d - 5.99616e8);
  return tdb;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Too convoluted to solve analytically... instead, get close and then search
  double taiTest = d;
  double step = 10.0;
  double epsilon = 1.0e-8;
  int maxCount = 10000;
  int count = 0;
  double tcbTest = TCB.fromMks(d).toDouble();
  double delta = tcbTest - taiTest;
  double prevDelta = double.MAX_FINITE;
  while ((delta.abs() > epsilon) && (count < maxCount)) {
    // See if we got farther away (if so reverse and take smaller steps)
    if (delta.abs() > prevDelta.abs()) step *= -0.5;

    // Step
    taiTest += step;

    prevDelta = delta;
    count++;

    // New value & delta
    tcbTest = TCB.fromMks(taiTest).toDouble();
    delta = tcbTest - d;
  }

  // taiTest now returns a tcb value within epsilon (or loop count ran out)
  return new Double(taiTest);
});

//__________________________________________________________________________________________________________

/// Universal Time (UT1): UT1 = TDT - Delta T
TimeInstantUnits UT1 = new TimeInstantUnits("Universal Time (UT1)", null, "UT1", null, 1.0, false, 0.0, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  return (TDT.fromMks(d) - getDeltaT(new TimeInstant(TAI: d)));
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Converge on a Delta T & TAI that work together
  int count = 0;
  double tai = d;
  double epsilon = 0.001;
  double deltaT = 0.0;
  double lastDeltaT = double.MAX_FINITE;
  while (((deltaT - lastDeltaT).abs() > epsilon) && count < 100) {
    lastDeltaT = deltaT;
    tai = d - 32.184 + deltaT;
    deltaT = getDeltaT(new TimeInstant(TAI: tai));
    count++;
  }

  // Return seconds in TAI time scale...
  return new Double(tai);
});

//__________________________________________________________________________________________________________

/// Universal Time (UT2):
///  UT2 = UT1 + 0.022 sin(2PI*t) - 0.012 cos(2PI*t) - 0.006 sin(4PI*t) + 0.007 cos(4PI*t),
///  where t = the date in Besellian years
TimeInstantUnits UT2 = new TimeInstantUnits("Universal Time (UT2)", null, "UT2", null, 1.0, false, 0.0, (val) {
  //double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  Number d = UT1.fromMks(val); // UT1
  double twoPI = 2.0 * PI;
  double fourPI = 2.0 * twoPI;
  double t = B.fromMks(UT1.toMks(d)).toDouble();
  return (d + (0.022 * sin(twoPI * t) - 0.012 * cos(twoPI * t) - 0.006 * sin(fourPI * t) + 0.007 * cos(fourPI * t)));
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  double twoPI = 2.0 * PI;
  double fourPI = 2.0 * twoPI;
  double t = B.fromMks(UT1.toMks(d)).toDouble(); // besselian -- use UT2 value as UT1... close enough
  d -= (0.022 * sin(twoPI * t) - 0.012 * cos(twoPI * t) - 0.006 * sin(fourPI * t) + 0.007 * cos(fourPI * t)); // UT1

  return UT1.toMks(d);
});

//__________________________________________________________________________________________________________

/// Julian Date in the TAI scale
TimeInstantUnits JD_TAI = new TimeInstantUnits("Julian Date (TAI)", null, "JD(TAI)", null, 86400.0, false, -2436204.5);

//__________________________________________________________________________________________________________

/// Modified Julian Date in the TAI scale
TimeInstantUnits MJD_TAI =
    new TimeInstantUnits("Modified Julian Date (TAI)", null, "MJD(TAI)", null, 86400.0, false, -36204.0);

//__________________________________________________________________________________________________________

/// Julian Date in the UTC scale
TimeInstantUnits JD_UTC =
    new TimeInstantUnits("Julian Date (UTC)", null, "JD(UTC)", null, 86400.0, false, -2436204.5, (val) {
  double d = UTC.fromMks(val).toDouble(); // UTC seconds
  int jd0 = d ~/ 86400.0; // integer UTC days

  // Fractional UTC days taking into account any leap seconds
  // for the particular UTC day in question
  double frac = (d - (jd0 * 86400.0)) / secondsInUtcDay(d);

  return 2436204.5 + jd0 + frac;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Adjust origin to TAI/UTC origin
  d -= 2436204.5;

  // Convert to seconds UTC
  int jd0 = d.toInt();
  d = (jd0 * 86400.0) + ((d - jd0) * secondsInUtcDay(d * 86400.0));

  return UTC.toMks(d);
});

//__________________________________________________________________________________________________________

/// Modified Julian Date in the UTC scale
TimeInstantUnits MJD_UTC =
    new TimeInstantUnits("Modified Julian Date (UTC)", null, "MJD(UTC)", null, 86400.0, false, -36204.0, (val) {
  Number jd = JD_UTC.fromMks(val);
  return jd - 2400000.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d += 2400000.5; // convert MJD(UTC) to JD(UTC)
  return JD_UTC.toMks(d);
});

//__________________________________________________________________________________________________________

/// Julian Date in the UT1 scale
TimeInstantUnits JD_UT1 =
    new TimeInstantUnits("Julian Date (UT1)", null, "JD(UT1)", null, 86400.0, false, -2436204.5, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Find average seconds in day for the year in question
  double deltaT0 = getDeltaT(new TimeInstant(TAI: d - 1.57788e7));
  double deltaT1 = getDeltaT(new TimeInstant(TAI: d + 1.57788e7));
  double deltaDelta = deltaT1 - deltaT0;
  double secsInDay = 86400.0 + deltaDelta / 365.0;

  // Leap year?
  if ((new TimeInstant(TAI: d)).isLeapYear) secsInDay = 86400.0 + deltaDelta / 366.0;

  d = UT1.fromMks(d).toDouble(); // UTC seconds
  int jd0 = d ~/ 86400; // integer UTC days

  // Fractional UT1 days
  // for the particular UTC day in question
  double frac = (d - (jd0 * 86400.0)) / secsInDay;

  return 2436204.5 + jd0 + frac;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Adjust origin to TAI/UT1 origin
  d -= 2436204.5;

  // Get approximate UT1 (not adjusted for length of day/JD fraction)
  double approxUT1 = d * 86400.0;

  // Find average seconds in day for the year in question
  double deltaT0 = getDeltaT(new TimeInstant.inUnits(approxUT1 - 1.57788e7, UT1));
  double deltaT1 = getDeltaT(new TimeInstant.inUnits(approxUT1 + 1.57788e7, UT1));
  double deltaDelta = deltaT1 - deltaT0;
  double secsInDay = 86400.0 + deltaDelta / 365.0;

  // Leap year?
  if ((new TimeInstant(TAI: d)).isLeapYear) secsInDay = 86400.0 + deltaDelta / 366.0;

  // Convert to seconds UT1
  int jd0 = d.toInt();
  d = (jd0 * 86400.0) + ((d - jd0) * secsInDay);
  return UT1.toMks(d);
});

//__________________________________________________________________________________________________________

/// Modified Julian Date in the UT1 scale
TimeInstantUnits MJD_UT1 =
    new TimeInstantUnits("Modified Julian Date (UT1)", null, "MJD(UT1)", null, 86400.0, false, -36204.0, (val) {
  Number jd = JD_UT1.fromMks(val);
  return jd - 2400000.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d += 2400000.5; // convert MJD(UTC) to JD(UTC)
  return JD_UT1.toMks(d);
});

//__________________________________________________________________________________________________________

/// Julian Date in the TDT (TT) scale
TimeInstantUnits JD_TDT =
    new TimeInstantUnits("Julian Date (TDT)", null, "JD(TDT)", null, 86400.0, false, -2436204.5, (val) {
  return (TDT.fromMks(val) / 86400.0) + 2436204.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;

  // Adjust origin to TAI/UT1 origin
  d -= 2436204.5;

  return TDT.toMks(d * 86400.0);
});

//__________________________________________________________________________________________________________

/// Modified Julian Date in the TDT scale
TimeInstantUnits MJD_TDT =
    new TimeInstantUnits("Modified Julian Date (TDT)", null, "MJD(TDT)", null, 86400.0, false, -36204.0, (val) {
  //double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  Number jd = JD_TDT.fromMks(val);
  return jd - 2400000.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d += 2400000.5; // convert MJD(TDT) to JD(TDT)
  return JD_TDT.toMks(d);
});

//__________________________________________________________________________________________________________

/// Julian Date in the TDB (TB) scale
TimeInstantUnits JD_TDB =
    new TimeInstantUnits("Julian Date (TDB)", null, "JD(TDB)", null, 86400.0, false, -2436204.5, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  return (TDB.fromMks(d) / 86400.0) + 2436204.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d -= 2436204.5;
  return TDB.toMks(d * 86400.0);
});

//__________________________________________________________________________________________________________

/// Modified Julian Date in the TDB scale
TimeInstantUnits MJD_TDB =
    new TimeInstantUnits("Modified Julian Date (TDT)", null, "MJD(TDT)", null, 86400.0, false, -36204.0, (val) {
  //double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  Number jd = JD_TDB.fromMks(val);
  return jd - 2400000.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d += 2400000.5; // convert MJD(TDB) to JD(TDB)
  return JD_TDB.toMks(d);
});

//__________________________________________________________________________________________________________

/// Julian Date in the TCG scale
TimeInstantUnits JD_TCG =
    new TimeInstantUnits("Julian Date (TCG)", null, "JD(TCG)", null, 86400.0, false, -2436204.5, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  return ((TCG.fromMks(d) / 86400.0) + 2436204.5);
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d -= 2436204.5;
  return TCG.toMks(d * 86400.0);
});

//__________________________________________________________________________________________________________

/// Modified Julian Date in the TCG scale
TimeInstantUnits MJD_TCG =
    new TimeInstantUnits("Modified Julian Date (TCG)", null, "MJD(TCG)", null, 86400.0, false, -36204.0, (val) {
  //double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  Number jd = JD_TCG.fromMks(val);
  return jd - 2400000.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d += 2400000.5; // convert MJD(TCG) to JD(TCG)
  return JD_TCG.toMks(d);
});

//__________________________________________________________________________________________________________

/// Julian Date in the TCB scale
TimeInstantUnits JD_TCB =
    new TimeInstantUnits("Julian Date (TCB)", null, "JD(TCB)", null, 86400.0, false, -2436204.5, (val) {
  return (TCB.fromMks(val) / 86400.0) + 2436204.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d -= 2436204.5;
  return TCB.toMks(d * 86400.0);
});

//__________________________________________________________________________________________________________

/// Modified Julian Date in the TCB scale
TimeInstantUnits MJD_TCB =
    new TimeInstantUnits("Modified Julian Date (TCB)", null, "MJD(TCB)", null, 86400.0, false, -36204.0, (val) {
  Number jd = JD_TCB.fromMks(val);
  return jd - 2400000.5;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d += 2400000.5; // convert MJD(TCB) to JD(TCB)
  return JD_TCB.toMks(d);
});

//__________________________________________________________________________________________________________

/// Besselian - Replaced by Julian system, but still of occasional use
TimeInstantUnits B = new TimeInstantUnits("Bessellian", null, "B", null, 1.0, false, 0.0, (val) {
  double jd = JD_TAI.fromMks(val).toDouble();
  return new Double(1900.0 + ((jd - 2415020.31352) / 365.242198781));
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  double jd = ((d - 1900.0) * 365.242198781) + 2415020.31352;
  return JD_TAI.toMks(jd);
});

//__________________________________________________________________________________________________________

/// Network Time Protocol (NTP) - NTP is offset from the UTC time scale, with its epoch at 1 Jan 1900 0h
TimeInstantUnits NTP =
    new TimeInstantUnits("Network Time Protocol", null, "NTP", null, 1.0, false, -1.8302976e9, (val) {
  Number d = UTC.fromMks(val);
  d += 1.8302976e9;
  return d;
}, (val) {
  double d = val is num ? val.toDouble() : val is Number ? val.toDouble() : 0.0;
  d -= 1.8302976e9;
  return UTC.toMks(d);
});

//__________________________________________________________________________________________________________

//===========================================================================
//============================== CONSTANTS ==================================
//===========================================================================

/// J2000.0 as defined by the IAU: Julian date: 2000 Jan 1d 12h UT in the TDT time scale
final TimeInstant J2000 = new TimeInstant.constant(const Double.constant(2451545.0), units: JD_TDT);
