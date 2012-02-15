module Beintoo
  class App
    RESOURCE = "app"

    # returns a map the most delivered vgood with you application and the number those have been erogated. 
    # This call can be very useful because you have visibility on the vgoods which are generating more
    # revenues for you. You could decide for example to provide a functional advantage to users who converted
    # one of these goods, for example giving him more energy in case of a game.
    def topvgood
    end

    # returns a map with your players and the score of those.
    def leaderboard
    end

    # returns a list of contest for your app, you can choose a single contest and to list all or just public contest
    def contestShow
    end
  end
end
