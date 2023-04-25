import 'package:flutter/material.dart';

/// Interface for creating an observable object that can be subscribed to by observers of type [Subscriber].
abstract class IObservable<Subscriber, Data> {
  /// Allows a [Subscriber] to subscribe to the observable object.
  ///
  /// Parameters:
  /// - [subscriber] : A subscriber of type [Subscriber] to be added to the list of subscribers.
  ///
  /// Return the [Data] object being observed.
  Data subscribe(Subscriber subscriber);

  /// Removes a [Subscriber] from the observable object.
  ///
  /// Parameters:
  /// - [subscriber] : A subscriber of type [Subscriber] to be removed from the list of subscribers.
  void unsubscribe(Subscriber subscriber);

  /// Notifies all subscribers that a change has occurred.
  ///
  /// Parameters:
  /// - [data] : The [Data] object being observed.
  @protected void notifySubscribers(Data data);
}
