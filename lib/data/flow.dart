/// Ordem linear da jornada na v2. Por enquanto a jornada é só de batalhas:
/// as telas de objetivos, teoria, checks, quiz, diagnóstico, painel e créditos
/// foram removidas para serem refeitas no novo visual.
const List<String> journeyFlow = [
  'cover',
  'battle1',
  'battle2',
  'battle3',
  'battle4',
  'battle5',
];

/// Total de etapas "de jogo" (sem a capa), usado na barra de progresso.
const int playableSteps = 5;

int indexOfStep(String id) {
  final index = journeyFlow.indexOf(id);
  return index < 0 ? 0 : index;
}

String? stepAfter(String id) {
  final index = journeyFlow.indexOf(id);
  if (index < 0 || index >= journeyFlow.length - 1) return null;
  return journeyFlow[index + 1];
}

bool isBattleStep(String id) => id.startsWith('battle');

/// A etapa anterior é a batalha deste caso?
bool isAfterBattle(String stepId, String battleId) {
  final index = journeyFlow.indexOf(stepId);
  final battleIndex = journeyFlow.indexOf(battleId);
  return battleIndex >= 0 && index > battleIndex;
}
