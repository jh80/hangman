# frozen_string_literal: true

# Prints designs
module Printable
  def print_box(array, size = @wrong_guess_limit)
    print_box_top
    print_box_side
    (size / 2).upto(size - 2) do |i|
      value = array[i] || ' '
      print i == size - 2 ? value : "#{value} "
    end
    print_box_side
    puts ''
    print_box_side
    0.upto((size / 2) - 1) do |i|
      value = array[i] || ' '
      print i == size / 2 - 1 ? value : "#{value} "
    end
    print_box_side
    puts ''
    print_box_bottom
  end

  def print_box_top
    puts ' _____'
  end

  def print_box_side
    print '|'
  end

  def print_box_bottom
    puts ' -----'
  end
end
