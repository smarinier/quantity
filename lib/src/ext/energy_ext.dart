import '../number/double.dart';
import '../si/types/energy.dart';
import '../si/types/power.dart';
import '../si/types/time.dart';

/// The standard SI unit.
final EnergyUnits joules = Energy.joules;

/// Accepted for use with the SI.
final EnergyUnits electronVolts = Energy.electronVolts;

/// International Table BTUs as a unit.
final EnergyUnits btuInternationalTable = new EnergyUnits('Btu (IT)', null, null, null, 1.055056e3, false);

/// Thermochemical BTUs as a unit.
final EnergyUnits btuThermo = new EnergyUnits('Btu (thermochemical)', null, null, null, 1.054350e3, false);

/// Mean BTUs as a unit.
final EnergyUnits btuMean = new EnergyUnits('Btu (mean)', null, null, null, 1.05587e3, false);

/// 39 degree Fahrenheit BTUs as a unit.
final EnergyUnits btu39 = new EnergyUnits('Btu (39 deg F)', null, null, null, 1.05967e3, false);

/// 60 degree Fahrenheit BTUs as a unit.
final EnergyUnits btu60 = new EnergyUnits('Btu (60 deg F)', null, null, null, 1.05468e3, false);

/// International Table calories as a unit.
final EnergyUnits caloriesInternationalTable =
    new EnergyUnits('calories (IT)', null, null, 'calorie (IT)', 4.1868, false);

/// Mean calories as a unit.
final EnergyUnits caloriesMean = new EnergyUnits('calories (mean)', null, null, 'calorie (mean)', 4.19002, false);

/// Thermochemical calories as a unit.
final EnergyUnits caloriesThermo =
    new EnergyUnits('calories (thermochemical)', null, null, 'calorie (thermochemical)', 4.184, false);

/// 15 degree Celsius calories as a unit.
final EnergyUnits calories15 = new EnergyUnits('calories (15 deg C)', null, null, 'calorie (15 deg C)', 4.18580, false);

/// 20 degree Celsius calories as a unit.
final EnergyUnits calories20 = new EnergyUnits('calories (20 deg C)', null, null, 'calorie (20 deg C)', 4.18190, false);

/// International Table kilogram calories as a unit.
final EnergyUnits caloriesKgInternationalTable =
    new EnergyUnits('calories (kg, IT)', null, null, 'calorie (kg, IT)', 4.1868e3, false);

/// Mean kilogram calories as a unit.
final EnergyUnits caloriesKgMean =
    new EnergyUnits('calories (kg, mean)', null, null, 'calorie (kg, mean)', 4.19002e3, false);

/// Thermochemical kilogram calories as a unit.
final EnergyUnits caloriesKgThermo =
    new EnergyUnits('calories (kg, thermochemical)', null, null, 'calorie (kg, thermochemical)', 4.184e3, false);

/// Ergs as a unit.
final EnergyUnits ergs = new EnergyUnits('ergs', null, null, null, 1.0e-7, true);

/// Foot pounds force as a unit.
final EnergyUnits footPoundsForce =
    new EnergyUnits('foot pounds force', null, 'ft lbf', 'foot pound force', 1.3558179, false);

/// Foot-poundals as a unit.
final EnergyUnits footPoundals = new EnergyUnits('foot-poundals', null, null, null, 4.2140110e-2, false);

/// Kilowatt-hours as a unit.
final EnergyUnits kilowattHours = new EnergyUnits.powerTime(Power.kilowatts, Time.hours);

/// Therms as a unit.
final EnergyUnits therms = new EnergyUnits('therms', null, null, null, 1.0551e8, false);

/// Tons of TNT equivalent as a unit.
final EnergyUnits tons = new EnergyUnits('tons (equivalent TNT)', null, null, 'ton (equivalent TNT)', 4.184e9, false);

/// Watt-hour as a unit.
final EnergyUnits wattHour = new EnergyUnits.powerTime(Power.watts, Time.hours);

/// Watt-second as a unit.
final EnergyUnits wattSecond = new EnergyUnits.powerTime(Power.watts, Time.seconds);

// Convenience units.

/// Kilojoules as a unit.
final EnergyUnits kilojoules = joules.kilo() as EnergyUnits;

/// A synonym for thermochemical kilogram calories.
final EnergyUnits kilocaloriesThermo = caloriesKgThermo;

// Constants.

/// The Hartree atomic unit of energy is the energy for the separation of a molecule to nuclei and electrons.
const Energy hartreeEnergy = const Energy.constant(const Double.constant(4.3597447222071e-18), uncert: 1.949655436636876e-12);
