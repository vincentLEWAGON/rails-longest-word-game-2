require "open-uri" # pour appeler l'API

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y) # je créé un tableau constant de voyelles

  def new # methode appelée par la root
    @letters = Array.new(4) { VOWELS.sample } # un tableau de 4 voyelles au hasard
    @letters += Array.new(6) { (('A'..'Z').to_a - VOWELS).sample } # un tableau de 6 consonnes au hasard
    @letters.shuffle! # mélanger les lettres
  end

  def score
    @letters = params[:letters] # récupérer les lettres du formulaire sous forme de chaine !
    @word = (params[:word] || '').upcase # récupérer le mot du formulaire
    @included = included?(@word, @letters) # appelle la méthode included? pour vérifier si le mot est inclus dans les lettres
    @english_word = english_word?(@word)  # appelle la méthode english_word? pour vérifier si le mot est un mot anglais

    session[:games_played] = session[:games_played].to_i + 1 # je créé une variable liée à la session pour incrémenter le nombre de parties jouées

    if @included && @english_word # si le mot est valide
      @score = @word.length # calculer le score selon la longueur du mot
      session[:total_score] = session[:total_score].to_i + @score # incrémenter le score total
    end
  end

  private
  def included?(word, letters) # méthode pour vérifier si le mot est inclus dans les lettres
    letters_array = letters.chars # transformer la chaine de caractère en tableau de lettres
    word.chars.all? { |letter| word.count(letter) <= letters_array.count(letter) } # vérifie si chaque lettre du mot est incluse dans le tirage
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}") # appelle l'API pour vérifier si le mot est un mot anglais
    json = JSON.parse(response.read) # transformer la réponse en JSON
    json['found'] # retourner la valeur de la clé "found" du JSON
  end
end
