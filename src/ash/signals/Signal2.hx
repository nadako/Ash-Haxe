package ash.signals;

/**
 * Provides a fast signal for use where two parameters are dispatched with the signal.
 */
class Signal2<T1, T2> extends SignalBase<T1->T2->Void> {}
