require 'JSON'

class Node
  attr_accessor :name, :neighbors
  @@all = {}

  def initialize(args)
    @name = args['name']
    @neighbors = []
    @@all[@name] = self
  end

  def self.find_or_create_by(args)
    find_by(args) || new(args)
  end

  def self.find_by(args)
    @@all[args['name']]
  end

  def bacon?
    name == "Kevin Bacon"
  end
end

class BaconFinder
  attr_accessor :actor, :traveled_path, :visited_nodes, :node_queue

  def initialize(actor)
    @actor = actor
    @traveled_path = []
    @visited_nodes = {}
    @node_queue = []
  end

  def self.load_actors
    file_names = Dir.entries("./films").reject{|name| name.chars.first == '.'}

    file_names.each do |file_name|
      json_hash = JSON.parse File.read("./films/#{file_name}")
      film = Node.find_or_create_by(json_hash["film"])

      json_hash["cast"].each do |actor_hash|
        actor = Node.find_or_create_by(actor_hash)
        film.neighbors << actor
        actor.neighbors << film
      end
    end
  end

  def find_bacon
    @node_queue << @actor

    until node_queue.empty?
      current_node = node_queue.shift
      traveled_path << current_node
      return pretty_path if current_node.bacon?

      node_neighbors = current_node.neighbors
      node_neighbors.each do |neighbor|
        @node_queue << neighbor unless visited_nodes[neighbor.name]
        visited_nodes[current_node.name] = true
      end
    end
  end

  def short_path
    backtrace = [traveled_path.last]

    traveled_path.reverse_each do |this_node|
      last_node = backtrace.first
      backtrace.unshift(this_node) if last_node.neighbors.include?(this_node)
    end

    return backtrace
  end

  def pretty_path
    pairs = short_path.map(&:name).each_slice(2).to_a
    pairs.map{|pair|"#{pair.first} -(#{pair.last})-> "}.join('')[0..-19]
  end

  def self.cli
    load_actors
    while true
      puts 'enter an actor name (or type quit):'
      input = gets.chomp
      break if input == 'quit'

      if actor = Node.find_by('name' => input)
        puts new(actor).find_bacon
      else
        puts "I don't know that actor. Try again."
      end
    end
  end
end

BaconFinder.cli