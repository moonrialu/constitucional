import { GameProvider, useGame } from './state/GameContext';
import CardGameScreen from './screens/CardGameScreen';
import TrainingScreen from './screens/TrainingScreen';
import WelcomeScreen from './screens/WelcomeScreen';

function ScreenRouter() {
  const { state } = useGame();

  return (
    <div key={state.screen} className="animate-fade">
      {state.screen === 'welcome' && <WelcomeScreen />}
      {state.screen === 'training' && <TrainingScreen />}
      {state.screen === 'cards' && <CardGameScreen />}
    </div>
  );
}

export default function App() {
  return (
    <GameProvider>
      <ScreenRouter />
    </GameProvider>
  );
}
