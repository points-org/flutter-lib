DateTime parseDateTime(String value) {
  if (value == null) {
    return null;
  }

  if (value.length == '1982-12-12T00:00:00'.length) {
    value = value + 'Z';
  }

  return DateTime.parse(value).toLocal();
}