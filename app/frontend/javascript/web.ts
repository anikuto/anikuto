import 'bootstrap/js/dist/collapse';
import 'bootstrap/js/dist/dropdown';
import 'dayjs/locale/ja';

import axios from 'axios';
import ujs from '@rails/ujs';
import dayjs from 'dayjs';
import Cookies from 'js-cookie';
import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import Turbolinks from 'turbolinks';

import { getTimeZone } from './utils/time-zone';
import vueApp from "./common/vueApp";

document.addEventListener('turbolinks:load', (_event) => {
  const annConfig = (window as any).AnnConfig;

  dayjs.locale(annConfig.viewer.locale);

  Cookies.set('ann_time_zone', getTimeZone(), {
    domain: `.${annConfig.domain}`,
    secure: annConfig.rails.env === 'production',
  });

  axios.defaults.headers.common['X-CSRF-Token'] = document
    .querySelector('meta[name="csrf-token"]')
    ?.getAttribute('content');

  vueApp.start();
});

const application = Application.start();
const context = (require as any).context('./controllers', true, /\.ts$/);
application.load(definitionsFromContext(context));

ujs.start();
Turbolinks.start();
