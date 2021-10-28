class View
  def list_recipes_to_user(recipes_array)
    recipes_array.each_with_index do |item, index|
      puts "#{index + 1} - #{item.done? ? "[x]" : "[ ]"} - #{item.name} - #{item.description} - #{item.rating}"
    end
  end

  def ask_user_for_recipe
    puts "What is the name of your recipe?"
    name = gets.chomp
    puts "What is the description of your recipe?"
    description = gets.chomp
    puts "What is the rating for this recipe?"
    rating = gets.chomp
    puts "What is the prep time for this recipe?"
    prep_time = gets.chomp
    [name, description, rating, prep_time]
  end

  def ask_user_for_index
    puts "Which recipe would you like to delete?"
    gets.chomp.to_i - 1
  end

  def ask_user_to_mark_as_done
    puts "Which recipe would you like to mark as done?"
    gets.chomp.to_i - 1
  end

  def ask_user_for_ingredient
    puts "What ingredient would you like to search for?"
    gets.chomp
  end

  def looking_for_ingredient(ingredient)
    puts "Looking for #{ingredient} recipes in the internet..."
  end

  def display_list_imported_recipes(imported_recipes_array)
    imported_recipes_array.each_with_index do |element, index|
      puts "#{index + 1} - #{element[:name]}"
    end
  end

  def ask_user_for_index_to_import
    puts "Which recipe would you like to import from the web?"
    puts ">"
    gets.chomp.to_i - 1
  end
end
