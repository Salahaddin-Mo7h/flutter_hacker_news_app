import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../providers/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _newestIds = PublishSubject<List<int>>();
  final _bestIds = PublishSubject<List<int>>();
  final _jobIds = PublishSubject<List<int>>();
  final _questionIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  // Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<List<int>> get newestIds => _newestIds.stream;
  Stream<List<int>> get bestIds => _bestIds.stream;
  Stream<List<int>> get jobIds => _jobIds.stream;
  Stream<List<int>> get questionIds => _questionIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream; 

  // Getters in Sink
  get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  fetchNewestIds() async {
    final ids = await _repository.fetchNewestIds();
    _newestIds.sink.add(ids);
  }

  fetchBestIds() async {
    final ids = await _repository.fetchBestIds();
    _bestIds.sink.add(ids);
  }

  fetchJobIds() async {
    final ids = await _repository.fetchJobIds();
    _jobIds.sink.add(ids);
  }

  fetchQuestionIds() async {
    final ids = await _repository.fetchQuestionIds();
    _questionIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{}
    );
  }

  dispose() {
    _topIds.close();
    _newestIds.close();
    _bestIds.close();
    _jobIds.close();
    _questionIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}