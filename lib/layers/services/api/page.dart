import 'package:cofein/layers/drivers/execeptions/common.dart';
import 'package:cofein/layers/drivers/json.dart';
import 'package:optional/optional.dart';

class Page<T> {
  final int count;
  final Optional<String> next;
  final Optional<String> prev;
  final List<T> results;

  Page(
    this.count,
    this.next,
    this.prev,
    this.results,
  )   : assert(count != null),
        assert(next != null),
        assert(prev != null);

  bool get hasNextPage => next.isNotEmpty;
  // ignore: lines_longer_than_80_chars
  Page.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) factory,
  )   : count = getJsonValue(json, 'count'),
        next = getJsonValueOrEmpty(json, 'next'),
        prev = getJsonValueOrEmpty(json, 'previous'),
        results = transformJsonListOfMap(json, 'results', (it) => factory(it)) {
    require(
      count != null,
      () => SchemeConsistencyException('"count" should not be null'),
    );
    require(
      next != null,
      () => SchemeConsistencyException('"next" should not be null'),
    );
    require(
      prev != null,
      () => SchemeConsistencyException('"prev" should not be null'),
    );
    require(
      results != null,
      () => SchemeConsistencyException('"results" should not be null'),
    );
  }
  Page.fromJson2(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) factory,
      )   : count = getJsonValue(json, 'count'),
        next = getJsonValueOrEmpty(json, 'next'),
        prev = getJsonValueOrEmpty(json, '   '),
        results = transformJsonListOfString(json, 'results',) {
    require(
      count != null,
          () => SchemeConsistencyException('"count" should not be null'),
    );
    require(
      next != null,
          () => SchemeConsistencyException('"next" should not be null'),
    );
    require(
      prev != null,
          () => SchemeConsistencyException('"prev" should not be null'),
    );
    require(
      results != null,
          () => SchemeConsistencyException('"results" should not be null'),
    );
  }
}
