import RouteTemplate from 'ember-route-template';
import Game from './game';
import { Game as GameName } from './games';

interface Signature {
  Args: {
    model: {
      id: GameName
    }
  };
}

export default RouteTemplate<Signature>(<template>
  <Game @game={{@model.id}} />
</template>);
