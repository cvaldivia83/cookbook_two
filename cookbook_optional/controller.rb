require_relative 'view'
require_relative 'recipe'
require_relative 'recipes_scraper'
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

  def import
    # @imported_recipes = []
    ingredient =  @view.ask_user_for_ingredient
    @view.looking_for_ingredient(ingredient)

    @scraper = ScrapeRecipes.new(ingredient)

    imported_array = @scraper.call

    @view.display_list_imported_recipes(imported_array)

    index = @view.ask_user_for_index_to_import

    new_recipe = @scraper.import_prep_time(index)

    # new_url = @imported_recipes[index][:url]

    # html = URI.open(new_url).read
    # doc_file = Nokogiri::HTML(html)

    # doc_file.search('.recipe-meta-item').each do |element|
    #   if element.search('.recipe-meta-item-header').first.text.strip == 'total:'
    #     prep_time = element.search('.recipe-meta-item-body').first.text.strip
    #   end
    # end

    # recipe = Recipe.new(@imported_recipes[index][:name], @imported_recipes[index][:description], @imported_recipes[index][:rating], prep_time )

    @cookbook.add_recipe(new_recipe)
  end

  def mark_recipe_as_done
    list
    index = @view.ask_user_to_mark_as_done
    recipe = @cookbook.find_recipe(index)
    recipe.mark_as_done!
  end
end
