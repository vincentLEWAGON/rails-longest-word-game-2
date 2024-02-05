require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y) # un tableau constant de voyelles

  def new
    @letters = Array.new(4) { VOWELS.sample } # un tableau de 4 voyelles au hasard
    @letters += Array.new(6) { (('A'..'Z').to_a - VOWELS).sample } # un tableau de 6 consonnes au hasard
    @letters.shuffle! # mélanger les lettres
  end

  def score
    @letters = params[:letters] # récupérer les lettres du formulaire sous forme de chaine !
    @word = (params[:word] || '').upcase # récupérer le mot du formulaire
    @included = included?(@word, @letters) # appelle la méthode included? pour vérifier si le mot est inclus dans les lettres
    # appelle la méthode english_word? pour vérifier si le mot est un mot anglais
    @english_word = english_word?(@word)

    session[:games_played] = session[:games_played].to_i + 1

    if @included && @english_word
      @score = @word.length
      session[:total_score] = session[:total_score].to_i + @score
    end
  end

  private
  def included?(word, letters) # méthode pour vérifier si le mot est inclus dans les lettres
    letters_array = letters.chars # transformer la chaine de caractère en tableau de lettres
    # vérifier si chaque lettre du mot est incluse dans les lettres
    word.chars.all? { |letter| word.count(letter) <= letters_array.count(letter) }
  end

  def english_word?(word)
    # appeler l'API pour vérifier si le mot est un mot anglais
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    # transformer la réponse en JSON
    json = JSON.parse(response.read)
    # retourner la valeur de la clé "found" du JSON
    json['found']
  end
end
