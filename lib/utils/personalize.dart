/// Substitui `{nome}` pelo nome informado no onboarding.
String personalizeText(String text, String name) {
  final clean = name.trim();
  return text.replaceAll('{nome}', clean.isEmpty ? 'assessor(a)' : clean);
}
