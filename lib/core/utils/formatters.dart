DateTime formatarData(String data) {
  final hoje = DateTime.now();

  final RegExp regData = RegExp(r'^(\d{2})/(\d{2})/(\d{4})');
  final match = regData.firstMatch(data);
  final DateTime aniversarioFormatado = match != null
      ? DateTime(
          int.parse(match.group(3)!),
          int.parse(match.group(2)!),
          int.parse(match.group(1)!),
        )
      : DateTime(hoje.year, hoje.month, hoje.day);
  
  return aniversarioFormatado;
}

String formatarAniversario(DateTime data) {
  final hoje = DateTime.now();

  bool isAniversarioHoje =
        (hoje.day == data.day &&
        hoje.month == data.month);

    String textoAniversario = isAniversarioHoje
        ? "🎉${data.day}/${data.month}/${hoje.year}🎉"
        : "${data.day}/${data.month}/${hoje.year}";
    
    return textoAniversario;
}
