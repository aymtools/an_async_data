class TestObject {
  final String id;

  TestObject([this.id = '']);
}

class TestEqualsObject extends TestObject {
  TestEqualsObject([super.id = '']);

  @override
  String toString() => 'TestEqualsObject(id: $id)';

  @override
  int get hashCode => Object.hash(id, TestEqualsObject);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestEqualsObject &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

class TestAwayHashObject extends TestObject {
  @override
  final int hashCode = 111111111111111;

  TestAwayHashObject([super.id = '']);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TestAwayHashObject && id == other.id;
  }
}
