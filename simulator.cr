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

  def load_pots
    @pot1 = File.read_lines("pot1.pot")
    #puts @pot1
    @pot2 = File.read_lines("pot2.pot")
    @pot3 = File.read_lines("pot3.pot")
    @pot4 = File.read_lines("pot4.pot")
  end

  def parse_pots
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
    #puts "#{@teams1}\n\n"
    #puts "#{@teams2}\n\n"
    #puts "#{@teams3}\n\n"
    #puts "#{@teams4}\n\n"
  end

  def get_random_team(pot)
    return pot.sample(1)[0]
  end

  def count_teams_per_federation(group)
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

  def valid_team(team, group)
    # Count each federation's teams in the group
    count = count_teams_per_federation(group)
    # If team is from UEFA, it's valid if there are 0 or 1 UEFA teams in the group
    if team.uefa?
      return count["UEFA"] == 0 || count["UEFA"] == 1
    else
      return count[team.federation] == 0
    end
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
      group << first_team  # TODO generalize this to the next world cup :)
      @teams1.delete(first_team)
    else
      first_team = get_random_team(@teams1)
      group << first_team
      @teams1.delete(first_team)
    end

    # TODO this sucks, because I'm keeping the pots as separated arrays
    # Use an array of arrays
    second_team = get_random_team(@teams2)
    while !valid_team(second_team, group)
      second_team = get_random_team(@teams2)
    end
    group << second_team
    @teams2.delete(second_team)

    # TODO this sucks, because I'm keeping the pots as separated arrays
    # Use an array of arrays
    third_team = get_random_team(@teams3)
    while !valid_team(third_team, group)
      third_team = get_random_team(@teams3)
    end
    group << third_team
    @teams3.delete(third_team)

    # TODO this sucks, because I'm keeping the pots as separated arrays
    # Use an array of arrays
    fourth_team = get_random_team(@teams4)
    while !valid_team(fourth_team, group)
      fourth_team = get_random_team(@teams4)
    end
    group << fourth_team
    @teams4.delete(fourth_team)

    return group
  end
end

simulator = GroupsSimulator.new
simulator.load_pots
simulator.parse_pots
puts simulator.create_group
