extension SidBaseList<T> on List<T> {
  
  List<T> pad(int targetLenght, T element) {
    if (length >= targetLenght) {
      return this;
    } else {
      return [...this, ...List.filled(targetLenght - length, element)];
    }
  }

  List<T> separateWith(
    T splitter, {
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) =>
      <T>[
        if (alsoFirst || alsoFirstAndLast) splitter,
        if (isNotEmpty) first,
        for (int i = 1; i < length; ++i) ...<T>[splitter, this[i]],
        if (alsoLast || alsoFirstAndLast) splitter,
      ];

  List<T> separateWithMultiple(
    Iterable<T> splitters, {
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) =>
      <T>[
        if (alsoFirst || alsoFirstAndLast) ...splitters,
        if (isNotEmpty) first,
        for (int i = 1; i < length; ++i) ...<T>[...splitters, this[i]],
        if (alsoLast || alsoFirstAndLast) ...splitters,
      ];

  bool checkIndex(int index) {
    if (index < 0) return false;
    if (index >= length) return false;
    return true;
  }

  bool move(int from, int to) {
    if (!this.checkIndex(from)) return false;
    if (!this.checkIndex(to)) return false;
    insert(to, removeAt(from));
    return true;
  }

  T? nullableAt(int index) {
    if (isEmpty) return null;
    if (index < 0) return null;
    if (index >= length) return null;
    return elementAt(index);
  }
}