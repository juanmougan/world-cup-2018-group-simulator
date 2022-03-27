# I didn't find how to create an empty array of arrays
# so, I created this small class to hold each Team
class Team
  getter name, federation

  def initialize(name : String, federation : String)
    @name = name
    @federation = federation
  end

  def uefa?
    return @federation == "UEFA"
  end

  def to_s
    "Name: #{@name}\tFederation: #{@federation}"
  end
end

class GroupsSimulator
  @pot1 = [] of String
  @pot2 = [] of String
  @pot3 = [] of String
  @pot4 = [] of String

  @teams1 = [] of Team
  @teams2 = [] of Team
  @teams3 = [] of Team
  @teams4 = [] of Team

  def initialize
    load_pots
    parse_pots
  end

  private def load_pots
    @pot1 = File.read_lines("pot1.pot")
    @pot2 = File.read_lines("pot2.pot")
    @pot3 = File.read_lines("pot3.pot")
    @pot4 = File.read_lines("pot4.pot")
  end

  private def parse_pots
    @pot1.each do |t|
      team_info = t.split(",")
      team = Team.new(team_info[0], team_info[1])
      @teams1 << team
    end

    @pot2.each do |t|
      team_info = t.split(",")
      team = Team.new(team_info[0], team_info[1])
      @teams2 << team
    end

    @pot3.each do |t|
      team_info = t.split(",")
      team = Team.new(team_info[0], team_info[1])
      @teams3 << team
    end

    @pot4.each do |t|
      team_info = t.split(",")
      team = Team.new(team_info[0], team_info[1])
      @teams4 << team
    end
  end

  private def get_random_team(pot)
    return pot.sample(1)[0]
  end

  private def count_teams_per_federation(group)
    count = {
      "UEFA" => 0,
      "CONMEBOL" => 0,
      "CONCACAF" => 0,
      "CAF" => 0,
      "AFC" => 0,
      "OFC" => 0          # Good luck with that, guys from OFC :D
    }
    group.each { |t|
      count[t.federation] = count[t.federation] + 1
    }
    return count
  end

  private def valid_team(team, group)
    # Count each federation's teams in the group
    count = count_teams_per_federation(group)
    # If team is from UEFA, it's valid if there are 0 or 1 UEFA teams in the group
    if team.uefa?
      count_uefa = count["UEFA"]
      return count["UEFA"] == 0 || count["UEFA"] == 1
    else
      return count[team.federation] == 0
    end
  end

  private def get_valid_teams(teams, group)
    all_valid_teams = teams.map{|t| valid_team(t, group)}
    return teams.select{|t| valid_team(t, group)}
  end

  private def get_valid_random_team(teams, group)
    valid_teams = get_valid_teams(teams, group)
    # FIXME there's a bug here which I couldn't figure out...
    if valid_teams.size == 0
      raise "Couldn't get any valid team!"
    end
    return get_random_team(valid_teams)
  end

  private def add_valid_random_team_from_group(teams, group)
    random_team = get_valid_random_team(teams, group)
    group << random_team
    teams.delete(random_team)
  end

  def create_group(group_a = false)
    # Rules:
    #   - Only one team of one federation per group, unless it's UEFA
    #   - Two teams from UEFA are allowed in the same group
    #   - One team from each pot for each group
    #   - Rusia goes to group A
    group = [] of Team

    # First, let's add pot 1
    if group_a
      first_team = @teams1[0]     # Horrible hack, Rusia is the first
    else
      first_team = get_random_team(@teams1)
    end
    group << first_team
    @teams1.delete(first_team)

    # TODO this sucks, because I'm keeping the pots as separated arrays
    # Use an array of arrays
    add_valid_random_team_from_group(@teams2, group)

    # TODO this sucks, because I'm keeping the pots as separated arrays
    # Use an array of arrays
    add_valid_random_team_from_group(@teams3, group)

    # TODO this sucks, because I'm keeping the pots as separated arrays
    # Use an array of arrays
    add_valid_random_team_from_group(@teams4, group)

    return group
  end

  def get_name_only(group)
    names = [] of String
    group.each { |t| names << t.name }
    return names
  end

  def index_to_char(index)
    return 'a' + index
  end

  def create_groups
    # This was the way to create an Array of Arrays
    groups = Array(Array(String)).new
    # Create Group A first
    group_a = create_group(true)
    named_group_a = get_name_only(group_a)
    puts "Group A: #{named_group_a}"
    groups << named_group_a
    # Then, from B to H
    7.times do |i|
      group = create_group
      named_group = get_name_only(group)
      puts "Group #{index_to_char(i+1).upcase}: #{named_group}"
      groups << named_group
    end
    return groups
  end
end
