import 'package:flutter/material.dart';

abstract class IObservable<Subscriber, Data> {
  Data subscribe(Subscriber subscriber);

  void unsubscribe(Subscriber subscriber);

  @protected void notifySubscribers(Data data);
}