# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-rails-nested-form", to: "https://ga.jspm.io/npm:stimulus-rails-nested-form@4.0.0/dist/stimulus-rails-nested-form.es.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "stimulus-lightbox", to: "https://ga.jspm.io/npm:stimulus-lightbox@3.0.0/dist/stimulus-lightbox.es.js"
pin "lightgallery", to: "https://ga.jspm.io/npm:lightgallery@2.6.0/lightgallery.es5.js"
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.1.0/dist/stimulus.js"
pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.9.5/dist/hotkeys.esm.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js"
