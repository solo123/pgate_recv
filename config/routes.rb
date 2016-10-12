Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'recv_notify', to: 'recv_post#notify_fun'
  post 'recv_callback', to: 'recv_post#callback_fun'
  post 'notify/:sender', to: 'recv_post#do_notify'
end
