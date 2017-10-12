require 'tree/binarytree'
include Tree

class Array
  def count_kinds_of( attribute: )
    k = Hash.new( 0 )
    self.each{ |x| k[ x[ attribute ] ] += 1 }
    return k
  end
end

class SingleElimination

  def initialize( games:, robots: )
    @games = games
    @robots = robots
    @tree = game_code_tree
    # @entries = entries
  end

  # def lines # 上位進出線
  #   h = {}
  #   rounds = @games.to_a.count_kinds_of(attribute: :round).sort
  #   Rails.logger.debug(">>>> rounds: #{rounds.to_yaml}")
  #   rounds.each do |round|
  #     games = @games.select { |g| g.round == round }
  #
  #   end
  #   h
  #
  #   @entries.each
  #
  #
  # end

  def entries
    a = []
    @tree.each do |node|
      @games.each do |game|
        next if game.round != 1 and game.round != 2
          # １回戦と２回戦だけ！　ワイルドカード対応してない？
        if game.code.to_s == node.name then
          @robots.each do |robot|
            next if robot.code != game.left_robot_code and
              robot.code != game.right_robot_code
            has_children = false
            node.children.each do |child_node|
              child_games = @games.select { |g| g.code.to_s == child_node.name }
              child_games && child_games.each do |child_game|
                if child_game.left_robot_code == robot.code or
                    child_game.right_robot_code == robot.code then
                  has_children = true
                  break
                end
              end
              break if has_children
            end
            next if has_children
            a << [ robot.code,
              "#{robot.campus.abbreviation}#{robot.team} #{robot.name}" ]
          end
        end
      end
    end
    a
  end

  private

  def game_code_tree
    rounds = @games.to_a.count_kinds_of(attribute: :round).sort.reverse
    final_round = rounds.min { |x, y| x[1] <=> y[1] }[0]
    root_data = @games.select { |i| i.round == final_round }[0]
    tree = BinaryTreeNode.new(root_data.code.to_s, root_data.winner_robot_code.to_s)
    parents_data = []
    parents_data << root_data
    rounds.each do |round, count|
      next if round == final_round
      parents_data.each do |parent_data|
        parent = tree.find { |node| node.name == parent_data.code.to_s }
        @games.each do |game_data|
          if round == game_data.round then
            if is_related?(parent: parent_data, child: game_data) then
              if round == 5 then
                parent << BinaryTreeNode.new(game_data.code.to_s,
                  game_data.winner_robot_code.to_s)
              else
                parent << BinaryTreeNode.new(game_data.code.to_s,
                  game_data.winner_robot_code.to_s)
              end
            end
          end
        end
      end
      parents_data = @games.select { |i| i.round == round }
    end
    tree
  end

  def is_related?(parent:, child:)
    case parent.left_robot_code
    when child.left_robot_code, child.right_robot_code
      return true
    end
    case parent.right_robot_code
    when child.left_robot_code, child.right_robot_code
      return true
    end
    return false
  end

end
