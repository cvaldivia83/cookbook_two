require_relative 'view'
require_relative 'recipe'
require 'nokogiri'
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    recipes_array = @cookbook.all
    @view.list_recipes_to_user(recipes_array)
  end

  def create
    new_recipe_array = @view.ask_user_for_recipe
    recipe = Recipe.new(new_recipe_array[0], new_recipe_array[1], new_recipe_array[2], new_recipe_array[3])
    @cookbook.add_recipe(recipe)
  end

  def destroy
    list
    index = @view.ask_user_for_index
    @cookbook.remove_recipe(index)
  end

  def mark
    list
    index = @view.ask_user_to_mark_as_done
    array = @cookbook.all
    chosen_recipe = array[index]
    chosen_recipe.mark_as_done!
  end

  def import
    @imported_recipes = []
   ingredient = @view.ask_user_for_ingredient

  url = "https://www.allrecipes.com/search/results/?search=#{ingredient}"

  html_file = URI.open(url).read

  doc = Nokogiri::HTML(html_file)

    doc.search('.card__detailsContainer').each do |item|
     name =  item.search('.card__title').text.strip
     description = item.search('.card__summary').text.strip
     rating = item.search('.review-star-text').text.strip.slice(/\d.?\d*/)
     url = item.search('.manual-link-behavior').attribute('href')
     @imported_recipes << {name: name, description: description, rating: rating, url: url}
    end

    @view.list_imported_recipes(@imported_recipes)

    index = @view.ask_user_which_recipe_to_import

    selected_recipe = @imported_recipes[index]

    new_url = selected_recipe[:url]

    html = URI.open(new_url).read

    doc = Nokogiri::HTML(html)

    prep_time = ''

    doc.search('.recipe-meta-item').each do |element|
      if element.search('.recipe-meta-item-header').text.strip == 'total:'
        prep_time = element.search('.recipe-meta-item-body').text.strip
      end
    end

    new_recipe = Recipe.new(selected_recipe[:name], selected_recipe[:description], selected_recipe[:rating], prep_time)

    @cookbook.add_recipe(new_recipe)
  end
end
