require 'open-uri'
require 'nokogiri'

class ScrapeRecipes
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    @imported_recipes = []
    #returns a list of recipes from scraping the web
    url = "https://www.allrecipes.com/search/results/?search=#{@ingredient}"
    html_file = URI.open(url).read
    doc = Nokogiri::HTML(html_file)

    doc.search('.card__detailsContainer').each do |item|
      name = item.search('.card__title').first.text.strip
      description = item.search('.card__summary').text.strip
      rating = item.search('.review-star-text').text.strip.slice(/(\d.?\d*)/)
      url = item.search('.manual-link-behavior').attribute('href').value
      @imported_recipes << {name: name, description: description, rating: rating, url: url}
    end
    @imported_recipes
  end

  def import_prep_time(index)
    new_url = @imported_recipes[index][:url]
    html = URI.open(new_url).read
    doc_file = Nokogiri::HTML(html)
    @prep_time = ''

    doc_file.search('.recipe-meta-item').each do |element|
      if element.search('.recipe-meta-item-header').first.text.strip == 'total:'
        @prep_time = element.search('.recipe-meta-item-body').text.strip
      end
    end

    @recipe_from_the_web = Recipe.new(@imported_recipes[index][:name], @imported_recipes[index][:description], @imported_recipes[index][:rating], @prep_time )
  end
end
