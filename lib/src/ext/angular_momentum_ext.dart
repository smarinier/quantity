import '../number/double.dart';
import '../si/types/angular_momentum.dart';

/// The standard SI unit.
final AngularMomentumUnits jouleSecond = AngularMomentum.jouleSecond;

/// The Planck constant as units.
final AngularMomentumUnits planckUnits = new AngularMomentumUnits('h', '\u210E', null, 'h', 6.62607015e-34, false);

/// The Planck constant divided by 2 PI (a.k.a., 'h-bar') as units.
final AngularMomentumUnits hBarUnits =
    new AngularMomentumUnits('h-bar', '\u210F', null, 'h-bar', 1.054571817e-34, false);

// Constants.

/// The Planck constant.
const AngularMomentum planckConstant =
    const AngularMomentum.constant(const Double.constant(6.62607015e-34));

/// The Planck constant divided by 2 PI (a.k.a., 'h-bar' or 'reduced Planck constant').
const AngularMomentum hBar =
    const AngularMomentum.constant(const Double.constant(1.0545718177777777e-34));
