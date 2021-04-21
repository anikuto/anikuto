import { Controller } from 'stimulus';

import { EventDispatcher } from '../utils/event-dispatcher';

export default class extends Controller {
  showSidebar(event: Event) {
    event.preventDefault();
    new EventDispatcher('sidebar:show').dispatch();
  }
}
