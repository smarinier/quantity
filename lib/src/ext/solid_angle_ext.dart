import 'dart:math';
import '../si/types/angle.dart';
import '../si/types/solid_angle.dart';
import 'angle_ext.dart';

// Useful metric units.

/// The standard SI unit.
final SolidAngleUnits steradians = SolidAngle.steradians;

/// Millisteradians as a unit.
final SolidAngleUnits millisteradians = SolidAngle.steradians.milli() as SolidAngleUnits;

// Non-SI units.

/// Spats as a unit.
final SolidAngleUnits spats = new SolidAngleUnits('spats', 'sp', null, null, 12.566371, false);

/// Spheres as a unit.
final SolidAngleUnits spheres = new SolidAngleUnits('spheres', null, null, null, 4.0 * pi, false);

/// Hemispheres as a unit.
final SolidAngleUnits hemispheres = new SolidAngleUnits('hemispheres', null, null, null, 2.0 * pi, false);

/// One eighth (1/8) of a sphere (a spherical right triangle).
final SolidAngleUnits octants = new SolidAngleUnits('octants', null, null, null, pi / 2.0, false);

/// Same as [octants].
final SolidAngleUnits sphericalRightTriangles = octants;

/// Square degrees as a unit.
final SolidAngleUnits squareDegrees = new SolidAngleUnits.angleUnits(Angle.degrees);

/// Square arc minutes as a unit.
final SolidAngleUnits squareArcMinutes = new SolidAngleUnits.angleUnits(minutesArc);

/// Square arc seconds as a unit.
final SolidAngleUnits squareArcSeconds = new SolidAngleUnits.angleUnits(secondsArc);
