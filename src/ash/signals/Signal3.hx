package ash.signals;

/**
 * Provides a fast signal for use where three parameters are dispatched with the signal.
 */
class Signal3<T1, T2, T3> extends SignalBase<T1->T2->T3->Void> {}
