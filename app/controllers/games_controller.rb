require 'net/http'
require 'json'

class GamesController < ApplicationController

  def new
    # je créee un tableau de voyels et un tableau de consonnes
    @voyels = ["A", "E", "I", "O", "U", "Y"]
    @consonnes = ("A".."Z").to_a - @voyels
    # je créee un tableau de 10 lettres comprenant 6 consonnes et 4 voyels
    @letters = []
    6.times { @letters << @consonnes.to_a.sample }
    4.times { @letters << @voyels.to_a.sample }
    # j'enregistre les lettres dans une session pour pouvoir les utiliser dans la méthode score
    session[:letters] = @letters
  end

  def score
    # je récupère le mot écrit par l'utilisateur
    @your_word = params[:word]
    # je récupère les lettres tirées
    @letters = session[:letters]
    # je récupère le score
    @score = @your_word.length

    # vérifie si le mot contient des lettres qui sont  dans les lettres tirées
    if @your_word.upcase.chars.all? { |letter| @your_word.upcase.count(letter) <= @letters.count(letter) }
      # j'enreggistre l'URL de l'API dans une variable
      url = URI("https://wagon-dictionary.herokuapp.com/#{@your_word}")
      # je récupère le résultat de l'API
      @result = JSON.parse(Net::HTTP.get(url))
      # je vérifie si le mot est valide
      if @result["found"]
        # si le mot est valide, j'indique le score
        @result = "Félicitations! #{@your_word} est un mot anglais valide. votre score est de #{@score}"
      else
        # si le mot n'est pas valide, j'indique que le mot n'est pas valide
        @result = "Désolé, mais #{@your_word} n'est pas un mot anglais valide"
      end
    else
      # si le mot ne peut pas être construit à partir des lettres tirées, j'indique que le mot ne peut pas être construit
      @result = "Désolé, mais #{@your_word} ne peut pas être construit à partir de #{@letters}"
    end
  end
end
