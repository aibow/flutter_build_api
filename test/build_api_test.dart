import 'package:flutter_test/flutter_test.dart';

import 'request.dart';

void main() {
  //ApiOptionManager.updateOption(logCallback: print);
  test('restful head', () async {
    // head
    HeadModel headModel = await HeadRequest().head();
    assert(headModel.isExists);
  });
  test('restful get single', () async {
    DataModel result = await SingleDataRequest(id: 10).get<DataModel>();
    assert(result.id == 10);
    assert(result.title.isNotEmpty);
  });
  test('restful get multi', () async {
    List<DataModel> result =
        await MultiDataRequest(start: 0, size: 10).get<List<DataModel>>();
    assert(result.isNotEmpty);
  });
  test('restful post', () async {
    DataModel result = await PostRequest().fetch<DataModel>();
    assert(result.id == 101);
    assert(result.title == 'title');
    assert(result.body == 'body');
    assert(result.userId == 1000);
  });
  test('restful put', () async {
    DataModel result = await PutRequest(id: 10).fetch<DataModel>();
    assert(result.id == 10);
    assert(result.title == 'title');
    assert(result.body == 'body');
    assert(result.userId == 1000);
  });
  test('restful delete', () async {
    int result = await DeleteRequest(id: 10).fetch<int>();
    assert(result == 1);
  });
  test('custom header', () async {
    HeaderModel result = await CustomHeaderRequest().get<HeaderModel>();
    assert(result.customKey == 'CustomValue');
  });
}
