import { createContext, useCallback, useContext, useEffect, useMemo, useReducer, useRef } from 'react';
import { TRAINING_ACTS } from '../data/training';
import { CARD_ROUNDS } from '../data/cards';
import { mentorById, mentorByName } from '../data/mentors';

const GameContext = createContext(null);
const STORAGE_KEY = 'assessor-stf-ova:name';

const initialState = {
  screen: 'welcome',
  name: '',
  actIndex: 0,
  lineIndex: 0,
  showSummary: false,
  questionIndex: 0,
  selectedCard: null,
  result: null,
  score: 0,
  answers: [],
  finished: false,
  manualDialogue: null,
};

function resetTraining(state) {
  return {
    ...state,
    actIndex: 0,
    lineIndex: 0,
    showSummary: false,
    manualDialogue: null,
  };
}

function resetCards(state) {
  return {
    ...state,
    questionIndex: 0,
    selectedCard: null,
    result: null,
    score: 0,
    answers: [],
    finished: false,
    manualDialogue: null,
  };
}

function reducer(state, action) {
  switch (action.type) {
    case 'HYDRATE_NAME':
      return { ...state, name: action.name };

    case 'START':
      return {
        ...resetCards(resetTraining(state)),
        screen: 'training',
        name: action.name,
      };

    case 'SHOW_DIALOGUE': {
      const mentor = action.mentor
        ? mentorById(action.mentor)
        : mentorByName(action.name);

      return {
        ...state,
        screen: 'training',
        showSummary: false,
        manualDialogue: {
          mentor: mentor?.id || null,
          text: action.text || '',
          emphasis: action.emphasis || null,
        },
      };
    }

    case 'CLEAR_DIALOGUE':
      return { ...state, manualDialogue: null };

    case 'ADVANCE_LINE': {
      if (state.manualDialogue) {
        return { ...state, manualDialogue: null };
      }
      if (state.showSummary) return state;
      const act = TRAINING_ACTS[state.actIndex];
      if (state.lineIndex < act.lines.length - 1) {
        return { ...state, lineIndex: state.lineIndex + 1 };
      }
      return { ...state, showSummary: true };
    }

    case 'BACK_LINE': {
      if (state.manualDialogue) {
        return { ...state, manualDialogue: null };
      }
      if (state.showSummary) return { ...state, showSummary: false };
      if (state.lineIndex > 0) {
        return { ...state, lineIndex: state.lineIndex - 1 };
      }
      return state;
    }

    case 'NEXT_ACT': {
      if (state.actIndex >= TRAINING_ACTS.length - 1) {
        return { ...resetCards(state), screen: 'cards' };
      }
      return {
        ...state,
        actIndex: state.actIndex + 1,
        lineIndex: 0,
        showSummary: false,
        manualDialogue: null,
      };
    }

    case 'GO_CARDS':
      return { ...resetCards(state), screen: 'cards' };

    case 'SELECT_CARD':
      if (state.result || state.finished) return state;
      return {
        ...state,
        selectedCard:
          state.selectedCard === action.cardId ? null : action.cardId,
      };

    case 'APPLY_CARD': {
      if (!state.selectedCard || state.result || state.finished) return state;
      const round = CARD_ROUNDS[state.questionIndex];
      const correct = state.selectedCard === round.answer;
      return {
        ...state,
        score: state.score + (correct ? 20 : 0),
        answers: [
          ...state.answers,
          {
            roundId: round.id,
            selected: state.selectedCard,
            correct,
          },
        ],
        result: {
          correct,
          selected: state.selectedCard,
          answer: round.answer,
          explanation: round.explanation,
        },
      };
    }

    case 'NEXT_QUESTION': {
      if (!state.result) return state;
      if (state.questionIndex >= CARD_ROUNDS.length - 1) {
        return { ...state, finished: true, result: null, selectedCard: null };
      }
      return {
        ...state,
        questionIndex: state.questionIndex + 1,
        selectedCard: null,
        result: null,
      };
    }

    case 'RESTART_CARDS':
      return { ...resetCards(state), screen: 'cards' };

    case 'GO_WELCOME':
      return {
        ...initialState,
        name: state.name,
      };

    default:
      return state;
  }
}

export function GameProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);
  const hydrated = useRef(false);

  useEffect(() => {
    if (hydrated.current) return;
    hydrated.current = true;
    try {
      const saved = window.localStorage.getItem(STORAGE_KEY);
      if (saved) dispatch({ type: 'HYDRATE_NAME', name: saved });
    } catch {
      // O jogo continua normalmente quando o armazenamento não está disponível.
    }
  }, []);

  useEffect(() => {
    if (!state.name) return;
    try {
      window.localStorage.setItem(STORAGE_KEY, state.name);
    } catch {
      // Sem persistência: o nome segue apenas em memória.
    }
  }, [state.name]);

  const showDialogue = useCallback((name, text, options = {}) => {
    dispatch({ type: 'SHOW_DIALOGUE', name, text, ...options });
  }, []);

  useEffect(() => {
    const command = (name, text, options = {}) =>
      dispatch({ type: 'SHOW_DIALOGUE', name, text, ...options });
    window.assessorSTF = { ...(window.assessorSTF || {}), showDialogue: command };
    window.showDialogue = command;
    return () => {
      if (window.showDialogue === command) delete window.showDialogue;
      if (window.assessorSTF?.showDialogue === command) {
        delete window.assessorSTF.showDialogue;
      }
    };
  }, []);

  const value = useMemo(
    () => ({
      state,
      dispatch,
      showDialogue,
      isManual: Boolean(state.manualDialogue),
      currentAct: TRAINING_ACTS[state.actIndex],
      currentLine:
        state.manualDialogue ||
        TRAINING_ACTS[state.actIndex].lines[state.lineIndex],
      currentRound: CARD_ROUNDS[state.questionIndex],
      totalActs: TRAINING_ACTS.length,
      totalRounds: CARD_ROUNDS.length,
    }),
    [state, showDialogue],
  );

  return <GameContext.Provider value={value}>{children}</GameContext.Provider>;
}

export function useGame() {
  const context = useContext(GameContext);
  if (!context) {
    throw new Error('useGame deve ser usado dentro de GameProvider.');
  }
  return context;
}

export function personalize(text, name) {
  const clean = (name || '').trim();
  return text.replaceAll('{name}', clean || 'assessor(a)');
}
