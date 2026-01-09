# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "rails-ujs", to: "rails-ujs.js"
pin "jquery" , to: "jquery.js"
pin "jquery-ui" , to: "jquery-ui.min.js"
pin "jquery-pagination", to: "jquery.pagination.js"
pin "bootstrap", to: "bootstrap.min.js"
pin "common", to: "common.js"
pin "index", to: "index.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
