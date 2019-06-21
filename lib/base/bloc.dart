import 'dart:async';

import 'package:pts_lib/base/disposable.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc {
  final disposables = <Disposable>[];
  final subscriptions = <StreamSubscription>[];

  dispose() {
    for (var dis in disposables) {
      dis.dispose();
    }

    for (var sub in subscriptions) {
      sub.cancel();
    }
  }
}

class BlocData<T> implements BehaviorSubject<T>, Disposable {
  final _inner = BehaviorSubject<T>();

  BlocData(Bloc bloc, {T initialValue}) {
    bloc.disposables.add(this);
    if (initialValue != null) {
      _inner.add(initialValue);
    }
  }

  BlocData.observeAnyChange(Iterable<Observable> streams, T handler()) {
    Observable.merge(streams).map((_) => handler()).pipe(this);
  }

  @override
  dispose() {
    _inner.close();
  }

  set value(T val) {
    _inner.add(val);
  }

  @override
  ControllerCancelCallback get onCancel => _inner.onCancel;

  @override
  set onCancel(void onCancelHandler()) {
    _inner.onCancel = onCancelHandler;
  }

  @override
  ControllerCallback get onListen => _inner.onListen;

  @override
  set onListen(void onListenHandler()) {
    _inner.onListen = onListenHandler;
  }

  @override
  ControllerCallback get onPause => _inner.onPause;

  @override
  set onPause(void onPauseHandler()) {
    _inner.onPause = onPauseHandler;
  }

  @override
  ControllerCallback get onResume => _inner.onResume;

  @override
  set onResume(void onResumeHandler()) {
    _inner.onResume = onResumeHandler;
  }

  @override
  void add(T event) {
    _inner.add(event);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    _inner.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<T> source, {bool cancelOnError = true}) {
    return _inner.addStream(source, cancelOnError: cancelOnError);
  }

  @override
  AsObservableFuture<bool> any(bool Function(T element) test) {
    return _inner.any(test);
  }

  @override
  Observable<T> asBroadcastStream({void Function(StreamSubscription<T> subscription) onListen, void Function(StreamSubscription<T> subscription) onCancel}) {
    return asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Observable<S> asyncExpand<S>(Stream<S> Function(T value) mapper) {
    return _inner.asyncExpand(mapper);
  }

  @override
  Observable<S> asyncMap<S>(FutureOr<S> Function(T value) convert) {
    return _inner.asyncMap(convert);
  }

  @override
  Observable<List<T>> bufferCount(int count, [int startBufferEvery = 0]) {
    return _inner.bufferCount(count, startBufferEvery);
  }

  @override
  Observable<List<T>> bufferTest(bool Function(T event) onTestHandler) {
    return _inner.bufferTest(onTestHandler);
  }

  @override
  Observable<List<T>> bufferTime(Duration duration) {
    return _inner.bufferTime(duration);
  }

  @override
  Observable<R> cast<R>() {
    return _inner.cast();
  }

  @override
  Future close() {
    return _inner.close();
  }

  @override
  Observable<S> concatMap<S>(Stream<S> Function(T value) mapper) {
    return _inner.concatMap(mapper);
  }

  @override
  Observable<T> concatWith(Iterable<Stream<T>> other) {
    return _inner.concatWith(other);
  }

  @override
  AsObservableFuture<bool> contains(Object needle) {
    return _inner.contains(needle);
  }

  @override
  StreamController<T> get controller => _inner.controller;

  @override
  Observable<T> defaultIfEmpty(T defaultValue) {
    return _inner.defaultIfEmpty(defaultValue);
  }

  @override
  Observable<T> delay(Duration duration) {
    return _inner.delay(duration);
  }

  @override
  Observable<S> dematerialize<S>() {
    return _inner.dematerialize();
  }

  @override
  Observable<T> distinct([bool Function(T previous, T next) equals]) {
    return _inner.distinct(equals);
  }

  @override
  Observable<T> distinctUnique({bool Function(T e1, T e2) equals, int Function(T e) hashCode}) {
    return _inner.distinctUnique(equals: equals, hashCode: hashCode);
  }

  @override
  Observable<T> doOnCancel(void Function() onCancel) {
    return _inner.doOnCancel(onCancel);
  }

  @override
  Observable<T> doOnData(void Function(T event) onData) {
    return _inner.doOnData(onData);
  }

  @override
  Observable<T> doOnDone(void Function() onDone) {
    return _inner.doOnDone(onDone);
  }

  @override
  Observable<T> doOnEach(void Function(Notification<T> notification) onEach) {
    return _inner.doOnEach(onEach);
  }

  @override
  Observable<T> doOnError(Function onError) {
    return _inner.doOnError(onError);
  }

  @override
  Observable<T> doOnListen(void Function() onListen) {
    return _inner.doOnListen(onListen);
  }

  @override
  Observable<T> doOnPause(void Function(Future resumeSignal) onPause) {
    return _inner.doOnPause(onPause);
  }

  @override
  Observable<T> doOnResume(void Function() onResume) {
    return _inner.doOnResume(onResume);
  }

  @override
  Future get done => _inner.done;

  @override
  AsObservableFuture<S> drain<S>([S futureValue]) {
    return _inner.drain(futureValue);
  }

  @override
  AsObservableFuture<T> elementAt(int index) {
    return _inner.elementAt(index);
  }

  @override
  AsObservableFuture<bool> every(bool Function(T element) test) {
    return _inner.every(test);
  }

  @override
  Observable<S> exhaustMap<S>(Stream<S> Function(T value) mapper) {
    return _inner.exhaustMap(mapper);
  }

  @override
  Observable<S> expand<S>(Iterable<S> Function(T value) convert) {
    return _inner.expand(convert);
  }

  @override
  AsObservableFuture<T> get first => _inner.first;

  @override
  AsObservableFuture<T> firstWhere(bool Function(T element) test, {Function() defaultValue, T Function() orElse}) {
    return _inner.firstWhere(test, defaultValue: defaultValue, orElse: orElse);
  }

  @override
  Observable<S> flatMap<S>(Stream<S> Function(T value) mapper) {
    return _inner.flatMap(mapper);
  }

  @override
  Observable<S> flatMapIterable<S>(Stream<Iterable<S>> Function(T value) mapper) {
    return _inner.flatMapIterable(mapper);
  }

  @override
  AsObservableFuture<S> fold<S>(S initialValue, S Function(S previous, T element) combine) {
    return _inner.fold(initialValue, combine);
  }

  @override
  AsObservableFuture forEach(void Function(T element) action) {
    return _inner.forEach(action);
  }

  @override
  Observable<T> handleError(Function onError, {bool Function(dynamic error) test}) {
    return _inner.handleError(onError, test: test);
  }

  @override
  bool get hasListener => _inner.hasListener;

  @override
  Observable<T> ignoreElements() {
    return _inner.ignoreElements();
  }

  @override
  Observable<T> interval(Duration duration) {
    return _inner.interval(duration);
  }

  @override
  bool get isBroadcast => _inner.isBroadcast;

  @override
  bool get isClosed => _inner.isClosed;

  @override
  AsObservableFuture<bool> get isEmpty => _inner.isEmpty;

  @override
  bool get isPaused => _inner.isPaused;

  @override
  AsObservableFuture<String> join([String separator = ""]) {
    return _inner.join(separator);
  }

  @override
  AsObservableFuture<T> get last => _inner.last;

  @override
  AsObservableFuture<T> lastWhere(bool Function(T element) test, {Object Function() defaultValue, T Function() orElse}) {
    return _inner.lastWhere(test, defaultValue: defaultValue, orElse: orElse);
  }

  @override
  AsObservableFuture<int> get length => _inner.length;

  @override
  StreamSubscription<T> listen(void Function(T event) onData, {Function onError, void Function() onDone, bool cancelOnError}) {
    return _inner.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Observable<S> map<S>(S Function(T event) convert) {
    return _inner.map(convert);
  }

  @override
  Observable<Notification<T>> materialize() {
    return _inner.materialize();
  }

  @override
  AsObservableFuture<T> max([Comparator<T> comparator]) {
    return _inner.max(comparator);
  }

  @override
  Observable<T> mergeWith(Iterable<Stream<T>> streams) {
    return _inner.mergeWith(streams);
  }

  @override
  AsObservableFuture<T> min([Comparator<T> comparator]) {
    return _inner.min(comparator);
  }

  @override
  Observable<S> ofType<S>(TypeToken<S> typeToken) {
    return _inner.ofType(typeToken);
  }

  @override
  void onAdd(T event) {
    _inner.onAdd(event);
  }

  @override
  Observable<T> onErrorResume(recoveryFn) {
    return _inner.onErrorResume(recoveryFn);
  }

  @override
  Observable<T> onErrorResumeNext(Stream<T> recoveryStream) {
    return _inner.onErrorResumeNext(recoveryStream);
  }

  @override
  Observable<T> onErrorReturn(T returnValue) {
    return _inner.onErrorReturn(returnValue);
  }

  @override
  Observable<T> onErrorReturnWith(returnFn) {
    return _inner.onErrorReturnWith(returnFn);
  }

  @override
  AsObservableFuture pipe(StreamConsumer<T> streamConsumer) {
    return _inner.pipe(streamConsumer);
  }

  @override
  ConnectableObservable<T> publish() {
    return _inner.publish();
  }

  @override
  ReplayConnectableObservable<T> publishReplay({int maxSize}) {
    return _inner.publishReplay();
  }

  @override
  ValueConnectableObservable<T> publishValue() {
    return _inner.publishValue();
  }

  @override
  AsObservableFuture<T> reduce(T Function(T previous, T element) combine) {
    return _inner.reduce(combine);
  }

  @override
  Observable<T> sample(Stream sampleStream) {
    return _inner.sample(sampleStream);
  }

  @override
  Observable<S> scan<S>(S Function(S accumulated, T value, int index) accumulator, [S seed]) {
    return _inner.scan(accumulator, seed);
  }

  @override
  Observable<T> share() {
    return _inner.share();
  }

  @override
  ReplayObservable<T> shareReplay({int maxSize}) {
    return _inner.shareReplay(maxSize: maxSize);
  }

  @override
  ValueObservable<T> shareValue() {
    return _inner.shareValue();
  }

  @override
  AsObservableFuture<T> get single => _inner.single;

  @override
  AsObservableFuture<T> singleWhere(bool Function(T element) test, {T Function() orElse}) {
    return _inner.singleWhere(test, orElse: orElse);
  }

  @override
  StreamSink<T> get sink => _inner.sink;

  @override
  Observable<T> skip(int count) {
    return _inner.skip(count);
  }

  @override
  Observable<T> skipUntil<S>(Stream<S> otherStream) {
    return _inner.skipUntil(otherStream);
  }

  @override
  Observable<T> skipWhile(bool Function(T element) test) {
    return _inner.skipWhile(test);
  }

  @override
  Observable<T> startWith(T startValue) {
    return _inner.startWith(startValue);
  }

  @override
  Observable<T> startWithMany(List<T> startValues) {
    return _inner.startWithMany(startValues);
  }

  @override
  ValueObservable<T> get stream => _inner.stream;

  @override
  Observable<T> switchIfEmpty(Stream<T> fallbackStream) {
    return _inner.switchIfEmpty(fallbackStream);
  }

  @override
  Observable<S> switchMap<S>(Stream<S> Function(T value) mapper) {
    return _inner.switchMap(mapper);
  }

  @override
  Observable<T> take(int count) {
    return _inner.take(count);
  }

  @override
  Observable<T> takeUntil<S>(Stream<S> otherStream) {
    return _inner.takeUntil(otherStream);
  }

  @override
  Observable<T> takeWhile(bool Function(T element) test) {
    return _inner.takeWhile(test);
  }

  @override
  Observable<TimeInterval<T>> timeInterval() {
    return _inner.timeInterval();
  }

  @override
  Observable<T> timeout(Duration timeLimit, {void Function(EventSink<T> sink) onTimeout}) {
    return _inner.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Observable<Timestamped<T>> timestamp() {
    return _inner.timestamp();
  }

  @override
  AsObservableFuture<List<T>> toList() {
    return _inner.toList();
  }

  @override
  AsObservableFuture<Set<T>> toSet() {
    return _inner.toSet();
  }

  @override
  Observable<S> transform<S>(StreamTransformer<T, S> streamTransformer) {
    return _inner.transform(streamTransformer);
  }

  @override
  T get value => _inner.value;

  @override
  Observable<T> where(bool Function(T event) test) {
    return _inner.where(test);
  }

  @override
  Observable<Stream<T>> windowCount(int count, [int startBufferEvery = 0]) {
    return _inner.windowCount(count, startBufferEvery);
  }

  @override
  Observable<Stream<T>> windowTest(bool Function(T event) onTestHandler) {
    return _inner.windowTest(onTestHandler);
  }

  @override
  Observable<Stream<T>> windowTime(Duration duration) {
    return _inner.windowTime(duration);
  }

  @override
  Observable<R> withLatestFrom<S, R>(Stream<S> latestFromStream, R Function(T t, S s) fn) {
    return _inner.withLatestFrom(latestFromStream, fn);
  }

  @override
  Observable<R> zipWith<S, R>(Stream<S> other, R Function(T t, S s) zipper) {
    return _inner.zipWith(other, zipper);
  }

  @override
  Observable<S> mapTo<S>(S value) {
    return _inner.mapTo(value);
  }

  @override
  Observable<List<T>> pairwise() {
    return _inner.pairwise();
  }

  @override
  Observable<GroupByObservable<T, S>> groupBy<S>(S Function(T value) grouper) {
    return _inner.groupBy(grouper);
  }

  @override
  bool get hasValue => _inner.hasValue;

  @override
  void onAddError(Object error, [StackTrace stackTrace]) {
    return _inner.onAddError(error, stackTrace);
  }

  @override
  ValueConnectableObservable<T> publishValueSeeded(T seedValue) {
    return _inner.publishValueSeeded(seedValue);
  }

  @override
  ValueObservable<T> shareValueSeeded(T seedValue) {
    return _inner.shareValueSeeded(seedValue);
  }

  @override
  Observable<T> debounceTime(Duration duration) {
    return _inner.debounceTime(duration);
  }

  @override
  Observable<T> sampleTime(Duration duration) {
    return _inner.sampleTime(duration);
  }

  @override
  Observable<T> throttleTime(Duration duration, {bool trailing = false}) {
    return _inner.throttleTime(duration, trailing: trailing);
  }

  @override
  Observable<List<T>> buffer(Stream window) {
    return _inner.buffer(window);
  }

  @override
  Observable<T> debounce(Stream Function(T event) window) {
    return _inner.debounce(window);
  }

  @override
  Observable<T> throttle(Stream Function(T event) window, {bool trailing = false}) {
    return _inner.throttle(window, trailing: trailing);
  }

  @override
  Observable<Stream<T>> window(Stream window) {
    return _inner.window(window);
  }
}
