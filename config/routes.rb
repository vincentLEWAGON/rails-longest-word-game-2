Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

root "games#new" # je choisis de rediriger vers la page de jeu directement
get "new" => "games#new", as: :new_game # je crée une route pour la page de jeu
post "score" => "games#score", as: :score_game # je crée une route pour la page de score
end
