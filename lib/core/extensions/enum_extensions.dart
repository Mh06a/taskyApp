extension EnumParsing<T extends Enum> on Iterable<T> {
  T parse(String? name, {required T orElse}) => asNameMap()[name] ?? orElse;
}
